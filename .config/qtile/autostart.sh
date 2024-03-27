#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Activity
# With schedule
#python $HOME/.config/qtile/activity.py $SCRIPTPATH/activity/schedule.txt &
# Without schedule
#python $HOME/.config/qtile/activity.py &

# Break
$HOME/.config/qtile/break.sh &
