#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ]; then
        read boundary
        read disposition
        read ctype
        read junk
        cat > /tmp/file.tmp
		eval `echo $disposition | tr -d '\r' | tr -d '\n' | cut -f4 -d " "`
		cp /tmp/file.tmp /run/media/mmcblk0p1/$filename
		sync
		sync
fi

echo "Content-Type: text/plain"
echo ""
echo "Write $filename to /run/media/mmcblk0p1"
echo "Done"

exit 0

