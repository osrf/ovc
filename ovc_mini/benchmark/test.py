#!/usr/bin/python3
import numpy as np
import argparse
import os
import json
from pathlib import Path
from typing import Dict, List
from pprint import pprint
from subprocess import check_output


def to_Mbps(bps: float) -> str:
    return f"{round(bps * 1e-6, 2)} Mbps"


def process_data(data: Dict) -> None:
    bps = []
    for interval in data['intervals']:
        bps.append(interval['sum']['bits_per_second'])

    samples = len(data['intervals'])
    avg = np.average(bps)
    sigma = np.std(bps)
    ci_2 = max(0, avg - (2 * sigma))
    ci_3 = max(0, avg - (3 * sigma))

    print(f"Number of samples: {samples}")
    print(f"Average: {to_Mbps(avg)}")
    print(f"Sigma: {to_Mbps(sigma)}")
    print(f"95% confidence interval: {to_Mbps(ci_2)}")
    print(f"99.7% confidence interval: {to_Mbps(ci_3)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Network performance statistics built on top of iperf3.')
    parser.add_argument('server_addr',
                        type=str,
                        help='Address of the iperf server.')
    parser.add_argument('--server_port',
                        type=int,
                        default=5201,
                        help='Port iperf server is listening on.')
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

    args = parser.parse_args()
    window_sizes = [8, 16, 32, 64, 128, 256]

    for window_size in window_sizes:
        # Read https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wireless-lan-wlan/212892-802-11ac-wireless-throughput-testing-and.html
        cmd = (
            f"iperf3"
            f" -R"  # Reverses iperf so the server sends to the client
            f" -J"  # Output in JSON format
            f" -c {args.server_addr}"
            f" -p {args.server_port}"
            f" -i {args.interval}"
            f" -t {args.time_per_test}"
            f" -P {args.parallel_streams}"
            f" -w {window_size}k")
        print(cmd)
        out = check_output(cmd.split())
        json_obj = json.loads(out)
        process_data(json_obj)
