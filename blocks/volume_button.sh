#!/bin/sh
SINK=$(get-main-sink)
case $1 in
    1) pactl set-sink-mute $SINK toggle; muted=`pactl list sinks | grep "Sink #$SINK" -A 12 | awk '/Mute:/ { printf $2 }'`; [ $muted = 'no' ] && un='un'; notify-send "Sound ${un}muted" ;;
    3) pactl set-sink-volume $SINK 50%; notify-send "Set volume to 50%" ;;
esac
sigdwmblocks 2
