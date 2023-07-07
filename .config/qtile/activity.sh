#!/bin/bash

file="/home/juanma/.activity.log"
log_file="/tmp/activity.log"

first_time="true"
sleep 3

while true; do
  time=$(notify-send --action -1=None --action 5=5 --action 10=10 --action 15=15 \
                     --action 20=20 --action 30=30 --expire-time=0 "Choose interval duration" \
                     "To control your use of computer")

  if [ "$time" != "" ]; then
    break
  fi
done

if [ $time -eq -1 ]; then
  echo "Option chosen: Not to start the program" >> $log_file
  notify-send -t 3000 "Activity" "Time won't be registered this session"
  exit 0
fi

echo "Interval time chosen: $time min ($(( $time * 60 )) s)" >> $log_file

# Default time
if [ $time -lt 5 ] || [ $time -gt 30 ]; then
  echo "$time is an invalid time. Switching to default (15 min)" >> $log_file
  time=15
fi

start_time="$(date +"%d/%m/%y  -  %H:%M")"

while true
do
  declare before=5
  # Sleep
  sleep $(( $time * 60 - $before ))

  # Warn about the upcoming control
  notify-send -t 2500 "ACTIVITY" "You will be asked in $before seconds"
  sleep $before

  # Write date just before writing, in case the session ends before the first time
  if [ "$first_time" == "true" ]; then
    if test -e $file ; then
      echo "$file exists, adding current session start time" > $log_file
      echo -e "\n" >> $file
      echo "$start_time" >> $file
    else
      echo "WARNING $file doesn't exist, creating it" > $log_file
      echo "$start_time" > $file
    fi
    first_time=false
  fi

  # Action: ask "What have you been doing these last 5 minutes?"
  echo -e "[$(date +"%H:%M:%S")]: What have you been doing these last $time minutes?\n" >> $file
  gedit $file
  echo "Gedit closed at $(date +"%H:%M:%S")" >> $log_file
  
  # Remind about the next control
  sleep 1 # Small delay to not send it at the exact moment gedit is closed
  notify-send -t 4000 "You will be asked again in $time minutes"
done
