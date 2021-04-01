#!/bin/bash
# convert to PGM and just grab the text part
#convert squares_64x32.png -compress none squares_64x32.pgm
#sed -e 1,4d < squares_64x32.pgm > squares_64x32.txt

# convert to binary stream (row-wise)
convert -size 64x32 -depth 8 squares_64x32.png gray:squares_64x32.bin  
convert -size 1280x64 -depth 8 fullwidth_squares_gradient_background.png gray:fullwidth_squares_gradient_background.bin
convert -size 128x64 -depth 8 128x64.png gray:128x64.bin
convert -size 128x64 -depth 8 128x64_superbright.png gray:128x64_superbright.bin
convert -size 128x64 -depth 8 128x64_superdark.png gray:128x64_superdark.bin
convert -size 640x64 -depth 8 cowells_stairs_640x64.png gray:cowells_stairs_640x64.bin
convert -size 1280x64 -depth 8 image0006_middle.png gray:image0006_middle.bin
#convert -size 1280x1024 -depth 8 image0006.png gray:image0006.bin
