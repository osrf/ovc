#!/bin/bash
set -o errexit
set -o verbose
iverilog -s tb tb.v top.v
./a.out
