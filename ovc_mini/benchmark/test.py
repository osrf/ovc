#!/usr/bin/python3
import numpy as np
import argparse
import dataclasses
import os
import json
import re
import socket
import subprocess
import time
import pickle
from pathlib import Path
from typing import Any, Callable, Dict, List

# To keep this available to as many systems as possible, this list has been kept
# extremely brief.
REMOTE_INSTALL_REQUIREMENTS = ['iperf3', 'lspci', 'ip', 'grep', 'sed', 'cat']
TEST_FILE_DIR = Path(os.path.dirname(os.path.abspath(__file__)))


class SSHSession():
    """
    Manages a remote shell session with another machine.

    Implements a way to run commands on another machine via SSH. This does not
    circumvent security as it still requires the user to enter the system's
    credentials at runtime.
    """
    STARTUP_MSG = ("Establishing a connection with the remote machine to "
                   "collect system information and start test.")

    def __init__(self, address: str, hostname: str, port: int,
                 socket_path: Path):
        self._connection = f"{hostname}@{address}"
        self._base_ssh_command = (
            f"ssh {self._connection} -p {port} -S {socket_path}")
        self._base_scp_command = (f"scp -o ControlPath={socket_path}")

    def __enter__(self):
        # Begin master shell session when entering context.
        print(self.STARTUP_MSG)
        self.run(args=(
            f" -M"  # Set up master connection
            f" -fNT"  # Starts the socket in the background
        ))
        return self

    def __exit__(self, exit_type, value, traceback):
        # Close master session
        self.run(args=" -O exit")

    def scp(self, local_path: Path, remote_path: Path):
        cmd = (self._base_scp_command +
               f" {str(local_path)} {self._connection}:{str(remote_path)}")
        return subprocess.check_output(cmd, shell=True)

    def run(self, cmd: str = "", args: str = "") -> str:
        # If no arguments, do nothing and warn.
        if cmd == "" and args == "":
            print("SSHSession: run called with no arguments")
            return ""

        final_cmd = self._base_ssh_command
        if args != "":
            final_cmd += args

        if cmd != "":
            final_cmd += f" '{cmd}'"

        # rstrip removes the trailing newline on a command's output.
        return subprocess.check_output(final_cmd,
                                       shell=True).decode('utf-8').rstrip()

    def check_installed(self, program: str):
        return "1" in self.run(
            cmd=f"if [[ ! -z $(which {program}) ]]; then echo \"1\"; fi;")


class Test:
    """Base class for test collection."""
    @dataclasses.dataclass
    class Results:
        """Stores data related to general test results."""
        duration: float  # seconds
        interval: float  # seconds
        sample_count: int

    def __init__(self, session: SSHSession, address: str, port: int):
        self._session = session
        self._address = address
        self._port = port


class IperfTest(Test):
    """Manages an iperf3 test on the remote server."""
    @dataclasses.dataclass
    class Results(Test.Results):
        """Stores data related to iperf test results."""
        window_size: int  # Bytes
        parallel_streams: int  # Number of threads sending data
        average_bandwidth: float  # Mbps
        sigma: float  # Mbps
        ci_2: float  # Mbps 95% confidence interval
        ci_3: float  # Mbps 99.7% confidence interval

    def __enter__(self):
        self._session.run(f"iperf3 -s -p {self._port} > /dev/null 2>&1 &")
        return self

    def __exit__(self, exit_type, value, traceback):
        # Close all iperf3 sessions
        self._session.run(f"killall iperf3")

    def run_test(self, duration: float, interval: float, parallel_streams: int,
                 window_size: int) -> Results:
        # Read https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wireless-lan-wlan/212892-802-11ac-wireless-throughput-testing-and.html
        cmd = (
            f"iperf3"
            f" -R"  # Reverses iperf so the server sends to the client
            f" -J"  # Output in JSON format
            f" -c {self._address}"
            f" -p {self._port}"
            f" -i {interval}"
            f" -t {duration}"
            f" -P {parallel_streams}"
            f" -w {window_size}k")
        out = subprocess.check_output(cmd.split())
        return self.Results(interval=interval,
                            duration=duration,
                            window_size=window_size,
                            parallel_streams=parallel_streams,
                            **self.process_results(out))

    @staticmethod
    def process_results(iperf_output: str) -> Dict[str, Any]:
        """Processes iperf output."""
        data = json.loads(iperf_output)
        bps = []
        for interval in data['intervals']:
            bps.append(interval['sum']['bits_per_second'])

        samples = len(data['intervals'])
        avg = np.average(bps)
        sigma = np.std(bps)
        ci_2 = max(0, avg - (2 * sigma))
        ci_3 = max(0, avg - (3 * sigma))

        return {
            'sample_count': samples,
            'average_bandwidth': to_Mbps(avg),
            'sigma': to_Mbps(sigma),
            'ci_2': to_Mbps(ci_2),
            'ci_3': to_Mbps(ci_3),
        }


class PayloadTest(Test):
    """
    Run simulated load test.

    This is defined as a fixed size packet queued at a fixed interval.
    We are interested if the packets get backed up (meaning bandwidth is
    not able to keep up with the packet queue).
    """
    TEST_PROGRAM_NAME = 'test_server_arm'

    @dataclasses.dataclass
    class Results(Test.Results):
        """Stores data related to iperf test results."""
        packet_size: int  # Megabytes
        packets_per_second: float

    def __enter__(self):
        subprocess.check_output(f"cd {TEST_FILE_DIR} && make arm", shell=True)
        self._session.scp(TEST_FILE_DIR / 'build' / self.TEST_PROGRAM_NAME,
                          Path('/tmp'))
        return self

    def __exit__(self, exit_type, value, traceback):
        self._session.run(
            f"if [[ ! -z $("
            f"ps aux | grep {self.TEST_PROGRAM_NAME} | grep -v grep)"
            f" ]]; then"
            f" killall {self.TEST_PROGRAM_NAME};"
            f" fi;")
        self._session.run(f"rm /tmp/{self.TEST_PROGRAM_NAME}")

    def run_test(self, packet_size: float, duration: int, interval: float):
        # Read https://stackoverflow.com/a/29172 to understand backgrounding
        # in an ssh command.
        cmd = (f"nohup /tmp/{self.TEST_PROGRAM_NAME}"
               f" -s {packet_size}"
               f" -p {self._port}"
               f" -d {duration}"
               f" -i {interval}"
               f" > /dev/null 2>&1 &")
        self._session.run(cmd)

        packet_bytes = packet_size * 1000000

        time.sleep(1)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            connected = False
            while not connected:
                try:
                    s.connect((self._address, self._port))
                    connected = True
                except ConnectionRefusedError as e:
                    print(e)
                    time.sleep(1)

            data_count = 0
            start = time.time()
            now = start
            packet_count = 0
            while (now - start < duration):
                if data_count >= packet_bytes:
                    packet_count += 1
                    data_count -= packet_bytes
                data_count += len(s.recv(4096))
                now = time.time()

            total_time = now - start
            pps = packet_count / total_time

            return self.Results(packet_size=packet_size,
                                interval=interval,
                                duration=total_time,
                                sample_count=packet_count,
                                packets_per_second=pps)


@dataclasses.dataclass
class WirelessConfiguration:
    """Data specific to a wireless configuration."""
    freq: int
    signal_strength: int  # dBm
    rx_connection: str
    tx_connection: str


@dataclasses.dataclass
class MachineConfiguration:
    """Data related to a machine's configuration."""
    name: str  # Output of hostname
    dev: str  # Hardware device used for test (in /proc/net/dev)
    wireless: bool  # Wireless device or not? (in /proc/net/wireless)
    wifi_config: WirelessConfiguration = None


@dataclasses.dataclass
class Results:
    """Stores all of the test data results."""
    machine: MachineConfiguration
    iperf_results: List[IperfTest.Results]
    payload_results: List[PayloadTest.Results]


def check_install(session: SSHSession):
    missing_packages = []
    for app in REMOTE_INSTALL_REQUIREMENTS:
        if not session.check_installed(app):
            missing_packages.append(app)

    if missing_packages != []:
        raise AttributeError(
            f"{', '.join(missing_packages)} not installed on remote system")


def get_machine_configuration(session: SSHSession,
                              address: str) -> MachineConfiguration:
    """
    Gets the machine configuration for the remote machine.

    Arguments:
        session: The SSHSession manager for the remote machine.
        address: The IP address of the remoter machine.
    """
    name = session.run("hostname")
    # Thanks to: https://unix.stackexchange.com/a/165067
    dev = session.run(
        f"ip route | grep -m 1 {address} | sed -e \"s/.*dev\ \(.*\)\ proto.*/\\1/;t;d\""
    )
    wireless = dev in session.run("cat /proc/net/wireless")
    wireless_config = None
    if wireless:
        # `iw` should be installed if there's a wireless device
        out = session.run(f"iw dev {dev} link")
        freq = int(re.search(r'freq:\ ([0-9]*)', out).group(1))
        signal = int(re.search(r'signal:\ ([\-0-9]*)\ dBm', out).group(1))
        rx = re.search(r'rx\ bitrate:\ (.*)', out).group(1)
        tx = re.search(r'tx\ bitrate:\ (.*)', out).group(1)
        wireless_config = WirelessConfiguration(freq, signal, rx, tx)

    return MachineConfiguration(name=name,
                                dev=dev,
                                wireless=wireless,
                                wifi_config=wireless_config)


def to_Mbps(bps: float) -> float:
    return round(bps * 1e-6, 2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=
        'Network performance tool to benchmark an ethernet based interface.')
    parser.add_argument('hostname',
                        type=str,
                        help='Hostname of the remote machine.')
    parser.add_argument('address',
                        type=str,
                        help='Address of the remote machine.')
    parser.add_argument('--ssh_port',
                        type=int,
                        default=22,
                        help='Port remote machine is running ssh server on.')
    parser.add_argument('--iperf_port',
                        type=int,
                        default=5201,
                        help='Iperf Test: port test is run on.')
    parser.add_argument('--payload_port',
                        type=int,
                        default=5202,
                        help='Payload Test: port test is run on.')
    parser.add_argument(
        '--parallel_streams',
        type=int,
        default=2,
        help='Iperf Test: Number of parallel streams to run in iperf.')
    parser.add_argument('--time_per_test',
                        type=int,
                        default=5,
                        help='All Tests: seconds to execute per test.')
    parser.add_argument('--interval',
                        type=int,
                        default=0.1,
                        help='Iperf Test: interval between samples.')
    parser.add_argument(
        '--packets_per_second',
        type=int,
        default=15,
        help='Payload Test: packets to target sending per second.')
    parser.add_argument('--packet_size',
                        type=float,
                        default=4.5,
                        help='Payload Test: size in MB to send.')
    parser.add_argument('--out_file',
                        type=Path,
                        default="results.pkl",
                        help='Name of file to write pickled results to.')
    parser.add_argument('--socket_path',
                        type=Path,
                        default=Path("~/.ssh/test_socket"),
                        help='Directory to save ssh session.')

    args = parser.parse_args()
    window_sizes = [8, 16, 32, 64, 128, 256]

    with SSHSession(args.address, args.hostname, args.ssh_port,
                    args.socket_path) as session:

        check_install(session)
        remote_config = get_machine_configuration(session, args.address)

        print("Running iperf3 test with variable window size.")
        with IperfTest(session, args.address, args.iperf_port) as test:
            iperf_results = []
            for window_size in window_sizes:
                print(f"Running iperf with window size of {window_size}k")
                iperf_results.append(
                    test.run_test(args.time_per_test, args.interval,
                                  args.parallel_streams, window_size))
        print("Finished iperf3 test.")

        print("Running payload test.")
        payload_results = []
        with PayloadTest(session, args.address, args.payload_port) as test:
            results = test.run_test(args.packet_size, args.time_per_test,
                                    round(1.0 / args.packets_per_second, 4))
            payload_results.append(results)

            print(f"In {results.duration} seconds,"
                  f" received {results.sample_count} packets"
                  f" ({results.packets_per_second} packets per second).")

    subprocess.check_output(f"mkdir -p {TEST_FILE_DIR / 'output'}", shell=True)
    with open(TEST_FILE_DIR / 'output' / args.out_file, 'wb') as file:
        pickle.dump(
            Results(machine=remote_config,
                    iperf_results=iperf_results,
                    payload_results=payload_results), file)
