#!/bin/bash
# 
# Script to take a break after using the computer for 2 hours (not taking
# into account suspended time)
#

limit="2h"

# Sleep for 2 hours
sleep "$limit"

# Icon
icon=""
if [ "$XDG_CONFIG_HOME" == "" ]
then
  icon="$HOME/.config/safeeyes/icons/eye-health.svg"
else
  icon="$XDG_CONFIG_HOME/safeeyes/icons/eye-health.svg"
fi

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
