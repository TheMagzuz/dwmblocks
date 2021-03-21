#!/bin/sh
ICONsn="🔇" # Muted
ICONsl="🔈" # Low volume
ICONsm="🔉" # Medium volume
ICONsh="🔊" # High volume
volume=$(pulsemixer --get-volume)
vl=$(echo $volume | cut -f1 -d " ")
vr=$(echo $volume | cut -f2 -d " ")

muted=$(pulsemixer --get-mute)

# Get the highest of the left and right volumes 
v=$(echo -e "$vl\n$vr" | sort -n | tail -1)

[ $v -gt 20 ] && icon=$ICONsl
[ $v -gt 40 ] && icon=$ICONsm
[ $v -gt 60 ] && icon=$ICONsh 

[ $muted -eq 1 ] && icon=$ICONsn

printf "$icon "
([ $vl -eq $vr ] && printf "$vl%%") || printf "$vl%% $vr%%"


#pacmd list-sinks |
    #awk '
        #BEGIN {
            #ICONsn = "🔇" # Muted
            #ICONsl = "🔈" # Low volume
            #ICONsm = "🔉" # Medium volume
            #ICONsh = "🔊" # High volume
            ##ICONsn = "\x0c\x0b" # headphone unplugged, not muted
            ##ICONsm = "\x0d\x0b" # headphone unplugged, muted
            ##ICONhn = "\x0c\x0b" # headphone plugged in, not muted
            ##ICONhm = "\x0d\x0b" # headphone plugged in, muted
        #}
        #{
            #if (f) {
                #if ($1 == "index:") {
                    #exit
                #}
                #if ($1 == "muted:" && $2 == "yes") {
                    #m = 1
                #} else if ($1 == "volume:") {
                    #if ($3 == $10) {
                        #vb = $5
                    #} else {
                        #vl = $5
                        #vr = $12
                    #}
                    #if ($5 > 10) {
                        #icon = ICONsl
                    #}
                    #if ($5 > 30) {
                        #icon = ICONsm
                    #}
                    #if ($5 > 60) {
                        #icon = ICONsh
                    #}
                #} else if ($1 == "active" && $2 == "port:" && $3 ~ /headphone/) {
                    #h = 1
                #}
            #} else if ($1 == "*" && $2 == "index:") {
                #f = 1
            #}
        #}
        #END {
            #if (f) {
                #printf "%s ", m ? ICONsn : icon
                #if (vb) {
                    #printf vb
                #} else {
                    #printf "L%s R%s\n", vl, vr
                #}
            #}
        #}
    #'
