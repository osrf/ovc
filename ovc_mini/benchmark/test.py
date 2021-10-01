#!/usr/bin/python3
import numpy as np
import argparse
import dataclasses
import os
import json
import re
import subprocess
from pathlib import Path
from typing import Any, Callable, Dict, List

# To keep this available to as many systems as possible, this list has been kept
# extremely brief.
REMOTE_INSTALL_REQUIREMENTS = ['iperf3', 'lspci', 'ip', 'grep', 'sed', 'cat']


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
        self.base_ssh_command = (
            f"ssh {hostname}@{address} -p {port} -S {socket_path}")

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

    def run(self, cmd: str = "", args: str = "") -> str:
        # If no arguments, do nothing and warn.
        if cmd == "" and args == "":
            print("SSHSession: run called with no arguments")
            return ""

        final_cmd = self.base_ssh_command
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
class iperfResults:
    """Stores data related to iperf test results."""
    duration: float  # seconds
    interval: float  # seconds
    sample_count: int
    window_size: int  # Bytes
    parallel_streams: int  # Number of threads sending data
    average_bandwidth: float  # Mbps
    sigma: float  # Mbps
    ci_2: float  # Mbps 95% confidence interval
    ci_3: float  # Mbps 99.7% confidence interval


@dataclasses.dataclass
class Results:
    """Stores all of the test data results."""
    machine: MachineConfiguration
    iperf_results: List[iperfResults]


class iperfTest:
    """Manages an iperf3 test on the remote server."""
    def __init__(self, session: SSHSession, address: str, port: int):
        self._session = session
        self._address = address
        self._port = port

    def __enter__(self):
        self._session.run(f"iperf3 -s -p {args.iperf_port} > /dev/null 2>&1 &")
        return self

    def __exit__(self, exit_type, value, traceback):
        # Close all iperf3 sessions
        self._session.run(f"killall iperf3")

    def run_test(self, duration: float, interval: float, parallel_streams: int,
                 window_size: int) -> iperfResults:
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
        return iperfResults(interval=interval,
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
    parser.add_argument('--port',
                        type=int,
                        default=22,
                        help='Port remote machine is listening on.')
    parser.add_argument('--iperf_port',
                        type=int,
                        default=5201,
                        help='Port iperf is run on.')
    parser.add_argument('--parallel_streams',
                        type=int,
                        default=2,
                        help='Number of parallel streams to run in iperf.')
    parser.add_argument('--time_per_test',
                        type=int,
                        default=5,
                        help='Seconds to execute per test.')
    parser.add_argument('--interval',
                        type=int,
                        default=0.1,
                        help='Interval between samples.')
    parser.add_argument('--out_dir',
                        type=Path,
                        default=Path(os.getcwd()) / "output",
                        help='Directory to send output.')
    parser.add_argument('--socket_path',
                        type=Path,
                        default=Path("~/.ssh/test_socket"),
                        help='Directory to save ssh session.')

    args = parser.parse_args()
    window_sizes = [8, 16, 32, 64, 128, 256]

    with SSHSession(args.address, args.hostname, args.port,
                    args.socket_path) as session:

        check_install(session)
        remote_config = get_machine_configuration(session, args.address)

        # Run iperf3 generic test with variable window size.
        print("Running iperf3 test.")
        with iperfTest(session, args.address, args.iperf_port) as iperf:
            iperf_results = []
            for window_size in window_sizes:
                print(f"Running iperf with window size of {window_size}k")
                iperf_results.append(
                    iperf.run_test(args.time_per_test, args.interval,
                                   args.parallel_streams, window_size))

        # Run simulated load test.
        # This is defined as a fixed size packet queued at a fixed interval.
        # We are interested if the packets get backed up (meaning bandwidth is
        # not able to keep up with the packet queue).

    print(Results(remote_config, iperf_results))
