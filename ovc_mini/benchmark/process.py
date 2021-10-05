#!/usr/bin/python3

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
    distribution = np.linspace(-1, 1, num_results)
    width = 0.7 / num_results  # the width of the bars

    fig, ax = plt.subplots()
    idx = 0
    for file, data in runs.items():
        values = [0]*len(window_sizes)
        for result in data.iperf_results:
            ws = result.window_size
            if ws in window_sizes:
                values[window_sizes.index(ws)] = result.average_bandwidth

        rects = ax.bar(x + width*distribution[idx], values, width, label=file)
        idx += 1
        #ax.bar_label(rects, padding=3)

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel('Mbps')
    ax.set_title('Network performance by Window Size')
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.legend()

    fig.tight_layout()

    plt.show()

if __name__ == '__main__':
    runs = {}
    for filename in DATA_DIR.glob('*.pkl'):
        with open(filename, 'rb') as f:
            runs[filename.stem] = pickle.load(f)

    window_performance(runs)
