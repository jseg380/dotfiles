#!/bin/bash

# There's room for improvement

################################################################################
# DECLARATIONS

# Name of the program
re_name="([^/\d]+)[^/]*$"
[[ $0 =~ $re_name ]]
name=${BASH_REMATCH[1]}

# Regex for testing if it's an integer
re_int='^[0-9]+$'

# Styles for each type
styles=(15 15 10 10 5 10 10)

# Saved type and style file
conf_file="$HOME/.config/rofi/launchers/default"

# Default type and style
declare type="1"
declare style="1"


################################################################################
# FUNCTIONS

function verify_args() {
  if ! [[ $1 =~ $re_int ]]; then
    echo "Error. 1st argument must be a positive integer."
    echo "Try '$name --help' for more information."
    exit 1
  elif ! [[ $2 =~ $re_int ]]; then
    echo "Error. 2nd argument must be either a positive integer or '--values'"
    echo "Try '$name --help' for more information."
    exit 1
  elif [ $1 -gt 7 ] || [ $1 -lt 1 ];then
    echo "Error. Types are between 1 and 7 both included."
    echo "Try '$name --help' for more information."
    exit 1
  elif [ $2 -gt ${styles[$(($1 - 1))]} ] || [ $2 -lt 1 ]; then
    echo "Error. Type $1 has ${styles[$(($1 - 1))]} styles."
    echo "Try '$name --help' for more information."
    exit 1
  fi
}


################################################################################
# PROGRAM

# If there are no args, then run it with the saved values

#if test -e $conf_file ; then
#  type=$(head -1 $conf_file)
#  style=$(tail -1 $conf_file)
#else
#  echo -e "$type\n$style" > $conf_file
#fi


# Number of arguments verification

if [ $# -gt 3 ]; then
  echo "Error. This program takes at most 3 arguments, but $# were received."
  echo "Try '$name --help' for more information."
  exit 1
fi


# Show help

if [ $# -eq 1 ] && ([ "$1" == "--help" ] || [ "$1" == "-h" ]); then
  echo "This program launches rofi with a custom theme."
  echo "Use:"
  echo "$name [--set] [type] [style]"
  echo "   --set    is used to change the saved values"
  echo "  [type]    must be an integer in [1, 7]"
  echo " [style]    must be a positive integer in [1, max], where max value will"
  echo "            depend on the type chosen."
  echo
  echo "To see the available list of types use '$name \$style --values'"
  exit 0
fi


# Program itself

if [ $# -eq 3 ] && [ "$1" == "--set" ]; then   # Setting new saved values
  verify_args $2 $3
  echo -e "$2\n$3" > $conf_file
  exit 0
elif [ $# -eq 3 ]; then
  echo "Error. Option '$1' unrecognized."
  echo "Try '$name --help' for more information."
  exit 1
elif [ $# -eq 2 ]; then     # Running program once with different type and style
  verify_args $1 $2
  
  if [ "$2" == "--values" ]; then
    echo "Type $1 has ${styles[$(($1 - 1))]} possible styles."
    exit 0
  else
    type="$1"
    style="$2"
  fi
elif [ $# -eq 1 ]; then
  echo "Error. Option '$1' unrecognized."
  echo "Try '$name --help' for more information."
  exit 1
fi




dir="$HOME/.config/rofi/launchers/type-$type"
theme="style-$style"

## Run
$HOME/.config/rofi/usr_bin/rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi





