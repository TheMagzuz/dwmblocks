#!/bin/sh


[ ! -f /tmp/spotify-trackdata ] && /home/markus/scripts/update-spotify-track

( [ ! -f /tmp/spotify-trackdata ] || [ -z "$(cat /tmp/spotify-trackdata)" ] || [ -z "$(ps -a | grep 'spt')" ] ) && exit 0

function toHMS() {
    local T=$1/1000000
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    
    local DF=`printf "%02g" $D`
    local HF=`printf "%02g" $H`
    local MF=`printf "%02g" $M`
    local SF=`printf "%02g" $S`
    
    o=""
    [ $D -gt 0 ] && o=$o:$DF
    [ $H -gt 0 ] && o=$o:$HF
    o=$o:$MF:$SF
    o=`echo $o | cut -c 2-`
    echo $o
}


progress=`dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotifyd /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Position' | awk '{
    if ($1 == "variant") {
        printf $3
    }
}'`

[ -z $progress ] && exit 0

md=`cat /tmp/spotify-trackdata`

length=`echo "$md" | awk '/mpris:length/ {
        gsub(/^[ \t]+/, "", $0)
        printf $2
}
'`

[ -z $length ] && exit 

title=`echo "$md" | awk '/xesam:title/ {
        $1=""
        gsub(/^[ \t]+/, "", $0)
        print $0
}' | tr -d "\n"`

artist=`echo "$md" | awk '/xesam:artist/ {
    $1=""
    gsub(/^[ \t]+/, "", $0)
    print $0
}'`

playing=`echo "$md" | awk '/playstatus/ {
        $1=""
        gsub(/^[ \t]+/, "", $0)
        print $0
}'`
[  "$playing" = "Playing" ] && playicon=""
[ "$playing" = "Paused" ] && playicon=""
( [ "$shuffle" = "true" ] && shuffleicon="咽" ) ||shuffleicon=""
flags="$shuffle$playicon"
track="$title - $artist"

titlelen=`echo "$track" | wc -c`

scrollcount=28
if [ $titlelen -gt $scrollcount ]; then
    scrollidx=0
    [ -f /tmp/spotify-scrollidx ] && scrollidx=`cat /tmp/spotify-scrollidx`
    doubled="$track -- $track"
    dlen=`echo $doubled | wc -c`
    track=${doubled:$scrollidx:$scrollcount}
    echo $((($scrollidx+1)%($titlelen+2))) > /tmp/spotify-scrollidx
fi


[ -z $length ] || fl=`toHMS $length`
[ -z $length ] && fl="??:??"
fp=`toHMS $progress`
echo "$flags $track $fp/$fl"
#printf "%s %s %s/%s" $flags $track $fp $fl
