#!/bin/sh
# Just a simple test for printing multiple progress bar

ECHO() {
    echo $@
    [ -z "$up" ] && up=1 || up=$((up+1)) # set lines to move up afterwards
}
while sleep 1; do
    [ -n "$up" ] && tput cuu $up && up='' # move up $up lines
    ECHO "line$((i=i+1))"
    ECHO "line$((i=i+1))"
    ECHO "line$((i=i+1))"
    ECHO "line$((i=i+1))"
done
