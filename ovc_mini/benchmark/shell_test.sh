#!/bin/bash

# Default values
OUT_DIR_DEFAULT=output
SERVER_PORT_DEFAULT=5201
TIME_PER_TEST_DEFAULT=5
PARALLEL_STREAMS_DEFAULT=2

# Read in user adjustments to variables.
OUT_DIR="${OUT_DIR:-$OUT_DIR_DEFAULT}"
SERVER_PORT="${SERVER_PORT:-$SERVER_PORT_DEFAULT}"
TIME_PER_TEST="${TIME_PER_TEST:-$TIME_PER_TEST_DEFAULT}"
PARALLEL_STREAMS="${PARALLEL_STREAMS:-$PARALLEL_STREAMS_DEFAULT}"

# Test variables
# See https://www.controlup.com/resources/blog/entry/using-iperf-to-baseline-network-performance/
WINDOW_SIZES=(8 16 64 128 256)

help () {
  cat << EOF
Help menu for test.sh
---
Variables:
  WIFI_ADDR: [Required] Set this to the server's wifi address.
  SERVER_PORT: Set this to the port the server is listening on (default $SERVER_PORT_DEFAULT).
  TIME_PER_TEST: Set this to the port the server is listening on.
  PARALLEL_STREAMS: Number of streams to send data over.
EOF
}

run_test () {
  # Read https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wireless-lan-wlan/212892-802-11ac-wireless-throughput-testing-and.html
  # Add -u -b2g to test UDP bandwidth up to 2 Gbps
  # -R reverses the test such that the server sends to the host.
  # Default args test TCP performance.
  cmd="iperf3 -R -c $WIFI_ADDR -p $SERVER_PORT -i 0.5 -t $TIME_PER_TEST -w $1k -P $PARALLEL_STREAMS"
  echo $cmd
  # -J converts the output to JSON
  $cmd #-J >> $OUT_DIR/test_$1k.json
}

if [[ $1 == "-h" ]]; then
  help
  exit
fi

if [[ -z "${WIFI_ADDR}" ]]; then
  echo "Missing WiFi address. Read the help menu with '-h'."
  exit
fi

# Create a dir to output results of the iperf tests
mkdir -p $OUT_DIR

for i in ${WINDOW_SIZES[@]}; do
  run_test $i
done
