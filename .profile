#: Qtile {{{
if [ "$DESKTOP_SESSION" = "qtile" ]
then
  #: Screen, wallpaper {{

  #: Monitors
  if ! set-monitor 2> /dev/null
  then
    mainMonitor=$(xrandr | grep -P ' connected .*primary.*' | awk '{print $1}')
    params=""

    while IFS= read -r line 
    do
      monitorName="$(echo $line | awk '{print $1}')"
      params="$params --output $monitorName --auto --left-of $mainMonitor"
    done < <(xrandr | grep 'connected' | grep -v "$mainMonitor")
    
    xrandr --output $mainMonitor --primary --auto $params
  fi

  #: Compositor
  which picom && pgrep picom || picom & disown

  #: Wallpaper
  which feh && {
    wallpaper="$XDG_DATA_HOME/wallpaper/fallback.png";
    [ -f "$wallpaper" ] || wallpaper="$XDG_DATA_HOME/wallpaper/fallback.png";
    feh --no-fehbg --bg-scale "$wallpaper";
  }

  #: }}


  #: Input {{

  #: Keyboard layout
  setxkbmap es
  #: To alternate between spanish (es) and english (us) layout by pressing
  #: <Meta>(Win) and <Space> simultaneously
  # setxkbmap -layout es,us -option grp:win_space_toggle

  #: Mouse
  mouseName="Logitech"
  mouseId=$(xinput list | grep -P "$mouseName\s+.*pointer" | 
            grep -vi "keyboard" | sed -n -E 's/.*id=([0-9]+).*/\1/p')
  if [ "$mouseId" != "" ]
  then
    xinput set-prop $mouseId \
           'Coordinate Transformation Matrix' 0.60 0 0 0 0.60 0 0 0 1
  fi

  #: }}


  #: Xresources
  xrdb -load "$XDG_CONFIG_HOME/X11/Xresources"
fi
#: }}}
