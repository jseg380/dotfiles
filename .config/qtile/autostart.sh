#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Activity
# python $HOME/.config/qtile/activity.py $SCRIPTPATH/activity/schedule.txt &
python $HOME/.config/qtile/activity.py &  # Not in classes anymore
