# Qtile keybindings

from libqtile.config import Key
from libqtile.lazy import lazy
from os import getenv
from os.path import join as p_join
from getpass import getuser

# Paths
home_env = getenv("HOME", f"/home/{getuser()}")
local_bin = p_join(home_env, ".local/bin")
rofi_path = p_join(home_env, ".config/rofi")

# Variables
term = "kitty"

mod = "mod4"

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # Change window sizes
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

    # Rofi application menu
    ([mod], "m", lazy.spawn(p_join(rofi_path, "launchers/rofi.sh 1 5"))),

    # Rofi power management menu
    ([mod, "shift"], "m", lazy.spawn(p_join(rofi_path, "powermenu/type-1/powermenu.sh"))),

    # Browsers
    ([mod], "b", lazy.spawn("firefox")),
    ([mod], "c", lazy.spawn("google-chrome-stable")),

    # File Explorer
    ([mod], "e", lazy.spawn(f"{term} ranger {home_env}")),

    # Terminal
    ([mod], "Return", lazy.spawn(term)),

    # Screenshot
    ([mod, "shift"], "s", lazy.spawn("flameshot gui")),

    # ------------ Hardware Configs ------------

    # Volume
    ([], "XF86AudioLowerVolume", lazy.spawn(p_join(local_bin, "volume -5%"))),
    ([], "XF86AudioRaiseVolume", lazy.spawn(p_join(local_bin, "volume +5%"))),
    ([], "XF86AudioMute", lazy.spawn(p_join(local_bin, "volume --toggle-mute"))),

    # Brightness
    # Bugs: duplicated or triplicated keystrokes when pressed once
    ([], "XF86MonBrightnessUp", lazy.spawn(p_join(local_bin, "brightness +5% "))),
    ([], "XF86MonBrightnessDown", lazy.spawn(p_join(local_bin, "brightness -5% "))),
]]
