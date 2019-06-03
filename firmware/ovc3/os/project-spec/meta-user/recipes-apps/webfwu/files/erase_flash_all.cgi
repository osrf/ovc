#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ]; then
        read boundary
        read disposition
        read ctype
        read junk
		echo $boundary > /tmp/boundary
		echo $disposition > /tmp/disposition
		echo $ctype > /tmp/ctype
		echo $junk > /tmp/junk
fi

echo "Content-Type: text/plain"
echo ""
echo "Flash erasing..."
echo ""
for i in `ls /dev/mtd?`; do echo "Erase $i, please wait..."; flash_erase $i 0 0; done
echo "...done"


exit 0

