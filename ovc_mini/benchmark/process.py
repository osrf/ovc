#!/usr/bin/python3

import os
import pickle
from pathlib import Path

import benchmark
from test import MachineConfiguration, Results, WirelessConfiguration

DATA_DIR = Path(os.path.dirname(os.path.abspath(__file__))) / 'output'

if __name__ == '__main__':
    runs = []
    for filename in DATA_DIR.glob('*.pkl'):
        with open(filename, 'rb') as f:
            runs.append(pickle.load(f))
