#!/bin/bash
set -o errexit
set -o verbose
FAB=harley_ghost_rider__rev_a
rm -rf $FAB
mkdir $FAB
cp gerbers/* $FAB
cp README.txt $FAB
cp stackup.pdf $FAB
cp HarleyGhostRider.csv $FAB/bill_of_materials.csv
rm -f $FAB.zip
zip -r $FAB.zip $FAB
