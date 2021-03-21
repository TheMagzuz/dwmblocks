#!/bin/sh
printf " %s" `free -h | awk '/Mem:/ { print $3 "/" $2 }'` 
