#!/usr/bin/env python
import rosbag
import sys

if len(sys.argv) != 2:
  print("usage: extract_timestamps.py BAGFILE")
  sys.exit(1)

with open('timestamps.txt', 'w') as f:
  for topic, msg, t in rosbag.Bag(sys.argv[1]).read_messages():
    #print("t: {} topic: {}".format(t, topic))
    # convert string topic names to numbers for easy import to octave
    topic_idx = 0
    if topic == 'image':
      topic_idx = 1
    elif topic == 'imu':
      topic_idx = 2
    f.write("{} {}\n".format(msg.header.stamp, topic_idx))
