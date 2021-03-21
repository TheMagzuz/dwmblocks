#!/bin/sh
IDLE=$(mpstat | grep "all" | cut -c 92-)
LOAD="$(bc <<< "100-$IDLE")"
printf " $LOAD%%"
