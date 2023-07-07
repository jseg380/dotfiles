#!/bin/bash

# Wait for nmcli to connect to a network if there is one available
# Not the best way but it does the trick as it has not taken nmcli 
# longer than 10 seconds to connect to an available network
sleep 10

#··············································································
# Functions

# Write in the log a message
#  $1  : message to write
# [$2] : boolean that indicates whether to write the time or not
function writeLog() {
  # There are no "boolean" data types in bash so as a convention "true" and 
  # "false" will be used. As in this function it's only important if the value 
  # is "false", it doesn't check whether is a "boolean" data type
  time=""
  message="$1"
  if [ "$2" != "false" ]; then
    time=$(date +"%H:%M:%S")
    message="[$time]: $message"
  fi

  printf "$message\n" >> $log_file
}


#··············································································
# Variables

# SSIDs
current_ssid=$(iwgetid -r)
target_ssid="eduroam"
# Files
log_file="/tmp/sf.log"
error_file="/tmp/sf_error.log"
# Icons
icon="$HOME/.config/safeeyes/icons/safeeyes_enabled.svg"
disabled_icon="$HOME/.config/safeeyes/icons/safeeyes_disabled.svg"
# Decision
decision=""
# Notification summary
summary="Safe eyes"


#··············································································
# Main

# If log file does not exist or it exist and has something in it, then reset it
if ! test -e $log_file || test -s $log_file; then
  printf "" > $log_file
fi

writeLog "$(date +"%A, %d %B %Y - %H:%M")" "false"
writeLog "Current WiFi SSID: $current_ssid"
writeLog "Target  WiFi SSID: $target_ssid"

if [ "$current_ssid" == "$target_ssid" ]; then
  writeLog "$current_ssid == $target_ssid  ->  not starting safe eyes"
  notify-send --expire-time=3000 \
              --icon=$disabled_icon \
              "$summary" \
              "Connected to $target_ssid \nSafe eyes not started"
  exit 0
fi

# current_ssid != target_ssid
writeLog "$current_ssid != $target_ssid -> asking whether to start safe eyes"

while [ "$decision" == "" ]; do
  decision=$(notify-send --action yes=ACCEPT \
                         --action no=DECLINE \
                         --expire-time=0 \
                         --icon=$icon \
                         "$summary" \
                         "Start Safe eyes?")
done

# Wait to not make the notifications instantaneous
sleep 1
writeLog "Decision: $decision"

if [ "$decision" != "yes" ]; then
  writeLog "Safe eyes not started"
  notify-send --expire-time=3000 \
              --icon=$disabled_icon \
              "$summary" \
              "Safe eyes not started"
  exit 0
fi

writeLog "Starting safe eyes..."
# Check whether a process launched in background was able to launch 
# successfully or not:
# https://stackoverflow.com/a/33564955
safeeyes 2> $error_file &
pid=$!
count=$(ps -A | grep $pid | wc -l)
if [[ $count -eq 0 ]]; then
  if ! wait $pid; then
    writeLog "An error occurred trying to execute Safe Eyes:"
    writeLog "$(cat $error_file)" "false"
    notify-send --expire-time=4000 \
                --icon=$disabled_icon \
                "$summary" \
                "<span color='red'><b>An error occurred executing Safe Eyes</b></span>"
    rm $error_file
    exit 1
  fi
fi

writeLog "... safe eyes started successfully"
notify-send --expire-time=4000 \
            --icon=$icon \
            "$summary" \
            "<span color='green'><b>Safe eyes started successfully</b></span>"
rm $error_file
