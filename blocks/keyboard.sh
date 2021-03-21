#!/bin/sh
layout=`setxkbmap -query | awk '/layout:/ {printf $2}'`
printf " %s" "${layout^^}"
