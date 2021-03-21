#!/bin/sh
td=`cat /tmp/spotify-trackdata`

getField() {
    echo "$td" | awk -v pattern=$1 '$0 ~ pattern { $1 = ""; printf $0}' | sed "s/^ *//"
}

title=`getField "xesam:title"`
artist=`getField "xesam:artist"`
albumName=`getField "xesam:album"`
albumArtUrl=`getField mpris:artUrl`

albumArtPath="/etc/spotify-albumart/$albumName"

[ ! -f "$albumArtPath" ] && curl "$albumArtUrl" > "$albumArtPath"

notify-send "Now playing" "$title - $artist" -i "$albumArtPath"
