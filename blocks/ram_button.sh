#!/bin/sh
usage=`ps axch -o cmd:15,%mem --sort=-%mem | head -n 10`
notify-send "Top 10 most ram consuming processes" "$usage"
