#!/bin/bash

echo "List of server's IPv4 addresses:"
ifconfig | grep "inet\ " | grep -v "127.0.0.1" | awk '{print $2}'
echo

# Reports iperf stats in terms of megabits.
iperf3 -s -f m
