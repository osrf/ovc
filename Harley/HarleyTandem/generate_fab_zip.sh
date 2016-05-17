#!/bin/bash
set -o errexit
set -o verbose
FAB=harley_tandem_rev_a
rm -rf $FAB
mkdir $FAB
cp gerbers/* $FAB
cp README.txt $FAB
cp harley_tandem_stackup.pdf ${FAB}/${FAB}__pcb_stackup.pdf
cp HarleyTandem.csv ${FAB}/${FAB}__bill_of_materials.csv
rm -f $FAB.zip
zip -r $FAB.zip $FAB
