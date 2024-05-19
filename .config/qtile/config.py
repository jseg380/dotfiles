# Qtile Config File
# http://www.qtile.org/

from settings.groups import groups
from settings.keys import mod, keys
from settings.layouts import layouts, floating_layout
from settings.mouse import mouse
from settings.screens import screens
from settings.widgets import widget_defaults, extension_defaults

from libqtile import hook
from os.path import join as path_join
from subprocess import run as sub_run
from settings.keys import home_env


auto_fullscreen = True
bring_front_click = False
cursor_warp = True
#dgroups_key_binder = None
#dgroups_app_rules = []
#floating_layout = []
floats_kept_above = True
focus_on_window_activation = "urgent"
# follow_mouse_focus = True
auto_minimize = False
reconfigure_screens = True
wmname = "LG3D"     # For Java UI Toolkits to work correctly


# @hook.subscribe.startup_once
# def autostart():
#     pass
