#!/bin/bash
set -o errexit
set -o verbose
FAB=harley_uimu
rm -rf $FAB
mkdir $FAB
cp gerbers/* $FAB
rm -f $FAB.zip
zip -r $FAB.zip $FAB
