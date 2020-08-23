#!/bin/bash

ME=$(tty | cut -c 6-)

echo "We are $ME"

w| grep -v "$ME" | grep pts | awk '{print $2}' | while read line; do
	cat /dev/urandom > /dev/$line &
done
