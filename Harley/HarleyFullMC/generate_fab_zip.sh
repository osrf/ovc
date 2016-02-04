#!/bin/bash
set -o errexit
set -o verbose
FAB=harley_rev_a
rm -rf $FAB
mkdir $FAB
cp gerbers/* $FAB
cp README.txt $FAB
cp stackup.pdf $FAB
cp HarleyFullMC.csv $FAB/bill_of_materials.csv
# TODO: figure out how to generate component XY file
rm -f $FAB.zip
zip -r $FAB.zip $FAB
