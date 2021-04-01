#!/usr/bin/env python3
import argparse
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import colors


parser = argparse.ArgumentParser()
parser.add_argument('input')
args = parser.parse_args()

data = []

with open(args.input) as f:
    lines = f.readlines()
    for line in lines:
        line = line.strip()
        if len(line) <= 1:
            continue
        tokens = line.split()
        frame_start = int(tokens[0])
        frame_end = int(tokens[1])
        userland = int(tokens[2])
        data.append((frame_start, frame_end, userland))

data = np.asarray(data)
frame_txlen = data[:,1] - data[:,0]
print(f'mean frame TX length: {np.mean(frame_txlen)}')

userland_latency = data[:,2] - data[:,1]
plt.hist(userland_latency, bins=200)
plt.xlabel('microseconds')
plt.title('Histogram of latency between end of image TX and its arrival in host userland')
plt.show()
