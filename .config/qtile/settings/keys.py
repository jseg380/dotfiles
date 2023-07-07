# Qtile keybindings

from libqtile.config import Key
from libqtile.command import lazy


mod = "mod4"

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # Change window sizes (MonadTall)
    ([mod, "shift"], "l", lazy.layout.grow()),
    ([mod, "shift"], "h", lazy.layout.shrink()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    ([mod, "shift"], "j", lazy.layout.shuffle_down()),
    ([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Toggle between different layouts as defined below
    ([mod], "Tab", lazy.next_layout()),
    ([mod, "shift"], "Tab", lazy.prev_layout()),

    # Kill window
    ([mod], "w", lazy.window.kill()),

    # Switch focus of monitors
    ([mod], "period", lazy.next_screen()),
    ([mod], "comma", lazy.prev_screen()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.restart()),

    # Lock to greeter
    ([mod], "y", lazy.spawn("dm-tool lock")),

    # ------------ App Configs ------------

    # STOCK rofi
    # Menu
    #([mod], "m", lazy.spawn("rofi -show drun")),

    # CUSTOM rofi
    # Menu
    ([mod], "m", lazy.spawn("/home/juanma/.config/rofi/launchers/rofi.sh 1 5")),

    # Shutdown menu
    ([mod, "shift"], "m", lazy.spawn("/home/juanma/.config/rofi/powermenu/type-1/powermenu.sh")),

    # Browsers
    ([mod], "b", lazy.spawn("firefox")),
    ([mod], "c", lazy.spawn("google-chrome-stable")),

    # File Explorer
    ([mod], "e", lazy.spawn("pcmanfm")),

    # Terminal
    ([mod], "Return", lazy.spawn("kitty")),

    # Visual Studio Code
    ([mod], "v", lazy.spawn("code")),

    # Screenshot (Core shot)
    #([mod], "s", lazy.spawn("coreshot")),
    ([mod, "shift"], "s", lazy.spawn("coreshot -s")),

    # ------------ Hardware Configs ------------

    # CHANGE TO MAKE USE NOTIFICATION (both volume and brightness)
    # Volume
    #([], "XF86AudioLowerVolume", lazy.spawn(
    #    "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    #)),
    ([], "XF86AudioLowerVolume", lazy.spawn(
        "/home/juanma/.local/bin/volume -5%"
    )),
    #([], "XF86AudioRaiseVolume", lazy.spawn(
    #    "pactl set-sink-volume @DEFAULT_SINK@ +5%"
    #)),
    ([], "XF86AudioRaiseVolume", lazy.spawn(
        "/home/juanma/.local/bin/volume +5%"
    )),
    #([], "XF86AudioMute", lazy.spawn(
    #    "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    #)),
    ([], "XF86AudioMute", lazy.spawn(
        "/home/juanma/.local/bin/volume --toggle-mute"
        )),

    # Brightness
    # Bugs: duplicated or triplicated keystrokes when pressed once
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    #([], "XF86MonBrightnessUp", 
    #    lazy.spawn("/home/juanma/.local/bin/brightness +5% ")),
    #([], "XF86MonBrightnessDown", 
    #    lazy.spawn("/home/juanma/.local/bin/brightness -5% ")),
]]
