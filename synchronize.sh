#!/bin/bash
#
# Author: jseg380
# File: Dotfiles/synchronize.sh
#

bin=".local/bin"
conf=".config"
dest="$HOME/.dotfiles"

# Full directories (with all their files)
dirs=(
  "$bin/c_program"
  "$conf/bat"
  "$conf/cava"
  "$conf/fish"
  "$conf/kitty"
  "$conf/nvim"
  "$conf/ranger"
  "$conf/rofi"
  "$conf/wallpaper"
  "$conf/starship.toml"
  "$conf/safeeyes/icons"
)

# Files
files=(
  ".bashrc"
  ".xprofile"
  "$bin/battery"
  "$bin/brightness"
  "$bin/cursor"
  "$bin/percentage"
  "$bin/sensitivity"
  "$bin/set-monitor"
  "$bin/volume"
  "$bin/xob-brightness-js"
  "$bin/xob-pulse-py"
  "$conf/lvim/config.lua"
  "$conf/qtile/config.py"
  "$conf/qtile/config.json"
  "$conf/qtile/autostart.sh"
  "$conf/qtile/activity.py"
  "$conf/qtile/settings/*.py"
  "$conf/qtile/themes/*"
  "$conf/safeeyes/script-safeeyes.sh"
)


# Copy directories
for i in "${dirs[@]}"; do
  if [[ $(diff -q -r $HOME/$i $dest/$i) != "" ]]; then 
    cp -u -i -r -T $HOME/$i $dest/$i
  fi
done

# Copy files
for i in "${files[@]}"; do
  array=($i)
  for i in "${array[@]}"; do
    if [ "$(diff -q $HOME/$i $dest/$i)" != "" ]; then 
      cp -i $HOME/$i $dest/$i
    fi
  done
done
