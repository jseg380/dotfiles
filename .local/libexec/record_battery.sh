#!/bin/bash
#
# Author: jseg380
# File: ~/.local/libexec/record_battery.sh
#

#··············································································
# Variables {{{

programName="$(basename $0)"
# valid_args=("start" "end" "charge" "discharge")
valid_args=("start" "end")
boot_id="$(journalctl -b --output=export | grep -m 1 '_BOOT_ID=' | 
           awk -F'=' '{print $2}')"


# According to the XDG spec: https://superuser.com/a/1767882 STATE is used
# sometimes for logging but the whole point of this script is logging so the
# information is considered important enough to go to DATA
xdg_data="${XDG_DATA_HOME:-$HOME/.local/share}"
log_file="${xdg_data}/battery/record_battery.log"

xdg_state="${XDG_STATE_HOME:-$HOME/.local/state}"
lock_file="${xdg_state}/battery/record_battery.lock"

# }}}


#··············································································
# Functions {{{

function info_program() {
cat <<EOF
Usage: $programName [OPTION] TIME

Record battery status.

Options:
  -h, --help    display this help and exit

Times (case insensitive):
$(for i in "${valid_args[@]}"; do echo "  ${i^}"; done)
EOF
}

function check_arg() {
    for valid_arg in "${valid_args[@]}"
    do
        [ "${1,,}" = "${valid_arg,,}" ] && return 0
    done

    return 1
}

function get_battery() {
    echo "$(battery --simple)"
}

# }}}


#··············································································
# Main {{{

if [ $# -ne 1 ]
then
    echo "$programName: incorrect amount of arguments"
    echo "Try '$programName --help' for more information."
    exit 1
fi

case "$1" in
    "-h" | "--help")
        info_program
        exit 0
        ;;
    "-"*)
        echo "$programName: unrecognized option '$1'"
        echo "Try '$programName --help' for more information."
        exit 1
        ;;
    *)
        if ! check_arg $1
        then
            echo "$programName: unrecognized time '$1'"
            echo "Try '$programName --help' for more information."
            exit 2
        fi
        ;;
esac


# Create log parent folder if it doesn't exist
[ -d ${log_file%/*} ] || mkdir -p "${log_file%/*}"

option="${1,,}"

if [ "$option" = "start" ]
then
    # If lock file has current boot id it's the same session, do nothing
    [ -f "$lock_file" ] && [ "$(cat \"$lock_file\")" = "$boot_id" ] && exit 1
    
    elapsed_time="$(date +'%d/%m/%Y - %H:%M:%S')"
    current_battery=$(get_battery)
    echo -e -n "\n$elapsed_time\n$current_battery" >> $log_file

    # Create lock (in order not to write the beginning two consercutive times)
    # Create lock parent folder if it doesn't exist
    [ -d ${lock_file%/*} ] || mkdir -p "${lock_file%/*}"

    echo -n "$boot_id" > "$lock_file"
elif [ "$option" = "end" ]
then
    elapsed_time="$(awk '{print int($1)}' /proc/uptime)"
    start_battery=$(tail -1 $log_file | awk '{print $1}')
    current_battery=$(get_battery)
    sed -i "\$s/.*/${elapsed_time}: ${start_battery} - ${current_battery}\n/" \
           "$log_file"

    # Unlock file
    echo -n > "$lock_file"
fi

# }}}
