#!/usr/bin/python3

import argparse
import dataclasses
import os
import pickle
from matplotlib import pyplot as plt
from pathlib import Path
from typing import Dict

import numpy as np

import benchmark
from test import MachineConfiguration, Results, WirelessConfiguration

DATA_DIR = Path(os.path.dirname(os.path.abspath(__file__))) / 'output'


def window_performance(runs: Dict[str, Results]) -> None:
    window_size_set = set()
    num_results = len(runs.keys())
    for data in runs.values():
        for result in data.iperf_results:
            window_size_set.add(result.window_size)

    window_sizes = list(window_size_set)
    window_sizes.sort()
    labels = window_sizes

    x = np.arange(len(labels))  # the label locations
    # Only use half of the space between graph points
    proportion = 0.35
    distribution = np.linspace(-1, 1, num_results) * proportion
    width = 2 * proportion / num_results  # the width of the bars

    def make_plot(ax, key: str):
        idx = 0
        for file, data in runs.items():
            if [] == data.iperf_results:
                continue
            values = [0] * len(window_sizes)
            for result in data.iperf_results:
                ws = result.window_size
                if ws in window_sizes:
                    values[window_sizes.index(ws)] = dataclasses.asdict(
                        result)[key]
            label = (f"{file} - {data.machine.name} - {data.machine.dev} - "
                     f"{result.duration}s")
            if data.machine.wireless:
                label += f" - {data.machine.wifi_config.signal_strength}dB"
                label += f" - {data.machine.wifi_config.tx_connection}"
            rects = ax.bar(x + distribution[idx], values, width, label=label)

            idx += 1
            #ax.bar_label(rects, padding=3)

        ax.set_ylabel('Mbps')
        ax.set_xlabel('Window Size (KBytes)')
        ax.set_xticks(x)
        ax.set_xticklabels(labels)
        ax.legend()

    ax1 = plt.subplot(311)
    ax1.set_title('Network performance by Window Size: Average Performance')
    make_plot(ax1, 'average_bandwidth')
    ax2 = plt.subplot(312)
    ax2.set_title('95% Confidence Interval')
    make_plot(ax2, 'ci_2')
    ax3 = plt.subplot(313)
    ax3.set_title('99.7% Confidence Interval')
    make_plot(ax3, 'ci_3')


def payload_performance(runs: Dict[str, Results]) -> None:
    intervals = {}
    # Collect all unique interval data
    for file, data in runs.items():
        for result in data.payload_results:
            if result.interval not in intervals:
                intervals[result.interval] = []
            label = (f"{file} - {data.machine.name} - {data.machine.dev} - "
                     f"{result.packet_size}MB - {round(result.duration)}s")
            if data.machine.wireless:
                label += f" - {data.machine.wifi_config.signal_strength}dB"
                label += f" - {data.machine.wifi_config.tx_connection}"
            intervals[result.interval].append((label, result))

    n = 1
    num_intervals = len(intervals.keys())
    for interval, data in intervals.items():
        if n > 9:
            raise ValueError('Too many intervals')
        ax = plt.subplot((num_intervals * 100) + 10 + n)
        if n == 1:
            plt.title("Payload performance test results")
        n += 1
        plt.axhline(
            y=interval,
            color='r',
            linestyle='-',
            label=f"Target interval {interval} ({round(1/interval)}Hz)")
        for label, result in data:
            times = np.array(result.receive_times)
            times = np.diff(times)  # Make relative
            plt.plot(times, label=label)

        ax.set_ylabel('dt since last packet (s)')
        ax.set_xlabel('Packet Count')
        ax.legend()


if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        description='Network benchmark data processor/visualizer.')
    parser.add_argument('--wireless_only',
                        action='store_true',
                        help='Show only wireless results.')
    args = parser.parse_args()

    runs = {}
    for filename in DATA_DIR.glob('*.pkl'):
        with open(filename, 'rb') as f:
            runs[filename.stem] = pickle.load(f)

    filtered_runs = {}
    for filename, data in runs.items():
        include = True
        if args.wireless_only and not data.machine.wireless:
            include = False

        # Passed all filters.
        if include == True:
            filtered_runs[filename] = data

    plt.figure(1)
    window_performance(filtered_runs)
    plt.figure(2)
    payload_performance(filtered_runs)
    plt.show()
