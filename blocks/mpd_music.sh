#!/bin/sh
systemctl --user is-active --quiet mopidy || exit 1
[ -z $(mpc current) ] && exit 2
fulldata=`mpc status -f '%title% - %artist%'`
track=`echo "$fulldata" | head -n1`
position=`echo "$fulldata" | sed -n '2 p' | awk '{ printf $3 }'`
titlelen=`echo "$track" | wc -c`

maxlen=28

if [ $titlelen -gt $maxlen ]; then
    scrollidx=0
    [ -f /tmp/spotify-scrollidx ] && scrollidx=`cat /tmp/spotify-scrollidx`
    doubled="$track -- $track"
    track=${doubled:$scrollidx:$maxlen}
    echo $((($scrollidx+1)%($titlelen+2))) > /tmp/spotify-scrollidx
fi

echo -n "$track $position"
