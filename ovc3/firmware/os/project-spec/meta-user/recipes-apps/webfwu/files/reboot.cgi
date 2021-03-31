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
echo "Reboot... Please wait..."

reboot
exit 0

