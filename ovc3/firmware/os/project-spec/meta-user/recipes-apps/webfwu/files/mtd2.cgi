#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ]; then
        read boundary
        read disposition
        read ctype
        read junk
        eval `echo $disposition | tr -d '\r' | tr -d '\n' | cut -f4 -d " "`
        cat > /tmp/$filename
        flashcp -v /tmp/$filename /dev/mtd2 > /dev/null
        rm /tmp/$filename

fi

echo "Content-Type: text/plain"
echo ""
echo "Write $filename to /dev/mtd2"
echo "Done"

exit 0

