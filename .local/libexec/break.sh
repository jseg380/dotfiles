#!/bin/bash
#
# Author: jseg380
# File: ~/.local/libexec/break.sh
#
# Script to take a break after using the computer for 2 hours (not taking
# into account suspended time)
#

limit="2h"

# Sleep for 2 hours
sleep "$limit"

# Icon
icon="${XDG_DATA_HOME:-$HOME/.local/share}/icons/safeeyes/eye-health.svg"

# Time limit has been reached
notify-send -t 0 -i "$icon" \
  "Take a break" "<span color='red'><b>You have been using the PC for $limit</b>\nTake a break of at least 30 min</span>"

# Extra 
extra=5 # in minutes
sleep "${extra}m"

# Count the minutes past the limit
while true
do
  notify-send -t 0 -i "$icon" \
    "Take a break" "<span color='red'><b>$extra min more than $limit elapsed</b></span>"
  extra=$(( $extra + 1 ))

  sleep 1m
done
