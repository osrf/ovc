#!/bin/bash
set -o errexit
set -o verbose
FAB=harley_rev_a2
rm -rf $FAB
mkdir $FAB
cp gerbers/* $FAB
cp README.txt $FAB
cp stackup.pdf $FAB
cp HarleyFullMC.csv $FAB/bill_of_materials.csv
rm -f $FAB.zip
zip -r $FAB.zip $FAB
