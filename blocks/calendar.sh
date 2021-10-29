#!/bin/sh
ICON="📆"
printf "$ICON %s" "$(date '+%a, %b %d, (W%W), %R')"
