#!/bin/sh

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$((sum + i))
    done
    cache=$HOME/.cache/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf "%d\\n" "$sum" > "$cache"
    printf "%d\\n" $(($sum - $old))
}

rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

networkdevices=`ip link | awk '$9 == "UP" { print $2 }'`

dt=`echo "$networkdevices" | xargs | cut -c-1`

# tr doesn't like multi-byte characters, so sed will have to do
dt=`echo "$dt" | sed 's/e//g; s/w//g' #| tr "ew" ""`

printf "%s %4sB   %4sB" $dt $(numfmt --to=iec $rx) $(numfmt --to=iec $tx)
