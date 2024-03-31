#!/bin/bash
#
# Author: jseg380
# File: ~/.local/libexec/safeeyes.sh
#

#··············································································
# Variables {{{ var

# SSIDs
current_ssid=""
target_ssid_array=("eduroam" "cviugr")
target_ssid="${target_ssid_array[@]}"

# Path
data_path="${XDG_DATA_HOME:-$HOME/.local/share}"

# Files
log_path="${data_path}/safeeyes"
log_file="${log_path}/sf.log"

# Icons
icon_path="${data_path}/icons/safeeyes"

icon="${icon_path}/safeeyes_enabled.svg"
disabled_icon="${icon_path}/safeeyes_disabled.svg"

# Decision
decision=""

# Notification summary
summary="Safe eyes"

# var }}}

#··············································································
# Functions {{{ fun

# Write in the log a message
#     $1 : string, message to write
#   [$2] : boolean, whether to write timestamp or not
function writeLog() {
  # If log file does not exist, create it
  [ -d "${log_path}" ] || mkdir -p "${log_path}"
  [ -f "${log_file}" ] || touch "${log_file}"
  
  message="${1}"
  if [ "${2}" != "false" ]
  then
    time="$(date +'%H:%M:%S') $(basename $0)[$$]"
    message="${time}: ${message}"
  fi

  printf -- "${message}\n" >> "${log_file}"
}

# fun }}}

#··············································································
# Main {{{ main

writeLog "-- Starting $(date +%s) --" "false"

# If safeeyes is already running then exit
if [ "$(pgrep -f $(which safeeyes) | wc -w)" != "0" ]
then
  writeLog "Safe Eyes already running. PID=$(pgrep -f $(which safeeyes))"
  exit 0
fi

# Wait for NetworkManager to connect to a network if there is one available
nm-online -t 20 -s -q

writeLog "nm-online finished with exit status $?"

current_ssid="$(iwgetid -r)"
writeLog "Current WiFi SSID: ${current_ssid}"
writeLog "Targets WiFi SSID: (${target_ssid})"

if printf '%s\0' "${target_ssid_array[@]}" | grep -Fxqz -- "${current_ssid}"
then
  writeLog "${current_ssid} in (${target_ssid})  ->  not starting safe eyes"
  notify-send --expire-time=3000 \
              --icon="${disabled_icon}" \
              "${summary}" \
              "Connected to ${current_ssid}\nSafe eyes not started"
  exit 0
fi

# Current_ssid is not targeted
writeLog "${current_ssid} not in (${target_ssid}) -> asking whether to start safe eyes"

while [ "${decision}" == "" ]
do
  decision="$(notify-send --action yes=ACCEPT \
                          --action no=DECLINE \
                          --expire-time=0 \
                          --icon="${icon}" \
                          "${summary}" \
                          "Start Safe eyes?")"
done

# Small delay so that notifications don't overlap
sleep 1
writeLog "Decision: ${decision}"

if [ "${decision}" != "yes" ]
then
  writeLog "Safe eyes not started"
  notify-send --expire-time=3000 \
              --icon="${disabled_icon}" \
              "${summary}" \
              "Safe eyes not started"
  exit 0
fi

writeLog "Starting safe eyes"

# Check whether a process launched in background was able to launch 
# successfully or not:
# https://stackoverflow.com/a/33564955
safeeyes 2> /dev/null &
sf_pid=$!

if [ "$(ps -A | grep $sf_pid | wc -l)" == "0" ]
then
  if ! wait $sf_pid
  then
    writeLog "ERROR: Safe Eyes failed to execute"
    notify-send --expire-time=4000 \
                --icon="${disabled_icon}" \
                "${summary}" \
                "<span color='red'><b>An error occurred executing Safe Eyes</b></span>"
    exit 1
  fi
fi

writeLog "Safe eyes started successfully"
disown $sf_pid
writeLog "Disowning the process. Exit code $?"

notify-send --expire-time=4000 \
            --icon="${icon}" \
            "${summary}" \
            "<span color='green'><b>Safe eyes started successfully</b></span>"
exit 0

# main }}}
