#!/bin/sh
usage=`top -bn 10 -d 0.01 -o "%CPU" | sed -n '7,17p' | awk '{print $9,$NF}'`

notify-send "Top 10 most CPU consuming processes" "$usage"
