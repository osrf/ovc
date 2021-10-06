#!/usr/bin/python3
import argparse
import dataclasses
import os
import pickle
import re
import subprocess
import time
from pathlib import Path
from typing import List

import benchmark

# To keep this available to as many systems as possible, this list has been kept
# extremely brief.
REMOTE_INSTALL_REQUIREMENTS = ['iperf3', 'lspci', 'ip', 'grep', 'sed', 'cat']
FILE_DIR = Path(os.path.dirname(os.path.abspath(__file__)))


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
    iperf_results: List[benchmark.IperfBench.Results]
    payload_results: List[benchmark.PayloadBench.Results]


def check_install(session: benchmark.SSHSession):
    missing_packages = []
    for app in REMOTE_INSTALL_REQUIREMENTS:
        if not session.check_installed(app):
            missing_packages.append(app)

    if missing_packages != []:
        raise AttributeError(
            f"{', '.join(missing_packages)} not installed on remote system")


def get_machine_configuration(session: benchmark.SSHSession,
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
                        help='Iperf Bench: port test is run on.')
    parser.add_argument('--payload_port',
                        type=int,
                        default=5202,
                        help='Payload Bench: port test is run on.')
    parser.add_argument(
        '--parallel_streams',
        type=int,
        default=2,
        help='Iperf Bench: Number of parallel streams to run in iperf.')
    parser.add_argument('--time_per_test',
                        type=int,
                        default=5,
                        help='All Benchmarks: seconds to execute per test.')
    parser.add_argument('--interval',
                        type=int,
                        default=0.1,
                        help='Iperf Bench: interval between samples.')
    parser.add_argument(
        '--packets_per_second',
        type=int,
        default=15,
        help='Payload Bench: packets to target sending per second.')
    parser.add_argument('--packet_size',
                        type=float,
                        default=4.5,
                        help='Payload Bench: size in MB to send.')
    parser.add_argument('--out_file',
                        type=Path,
                        default=f"{round(time.time())}.pkl",
                        help=('Name of file to write pickled results to.'
                              ' Defaults to saving as integer timestamp.'))
    parser.add_argument('--socket_path',
                        type=Path,
                        default=Path("~/.ssh/test_socket"),
                        help='Directory to save ssh session.')
    parser.add_argument('--no_iperf',
                        action='store_true',
                        help='Whether to run iperf benchmark.')
    parser.add_argument('--no_payload',
                        action='store_true',
                        help='Whether to run payload benchmark.')

    args = parser.parse_args()
    window_sizes = [8, 16, 32, 64, 128, 256]

    with benchmark.SSHSession(args.address, args.hostname, args.ssh_port,
                              args.socket_path) as session:

        check_install(session)
        remote_config = get_machine_configuration(session, args.address)

        iperf_results = []
        if not args.no_iperf:
            print("Running iperf3 benchmark with variable window size.")
            with benchmark.IperfBench(session, args.address,
                                      args.iperf_port) as test:
                for window_size in window_sizes:
                    print(f"Running iperf3 with window size of {window_size}k")
                    iperf_results.append(
                        test.run_test(args.time_per_test, args.interval,
                                      args.parallel_streams, window_size))
            print("Finished iperf3 benchmark.")
        else:
            print("Skipped iperf3 benchmark.")

        payload_results = []
        if not args.no_payload:
            print("Running payload benchmark.")
            with benchmark.PayloadBench(session, args.address,
                                        args.payload_port) as test:
                results = test.run_test(
                    args.packet_size, args.time_per_test,
                    round(1.0 / args.packets_per_second, 4))
                payload_results.append(results)

                print(
                    f"In {results.duration} seconds,"
                    f" received {results.sample_count} packets"
                    f" ({results.sample_count/results.duration} packets per second)."
                )
        else:
            print("Skipped payload benchmark.")

    subprocess.check_output(f"mkdir -p {FILE_DIR / 'output'}", shell=True)
    with open(FILE_DIR / 'output' / args.out_file, 'wb') as file:
        pickle.dump(
            Results(machine=remote_config,
                    iperf_results=iperf_results,
                    payload_results=payload_results), file)
