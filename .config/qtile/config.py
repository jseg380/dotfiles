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


main = None
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'urgent'
wmname = 'LG3D'
qtile_path = path_join(home_env, ".config", "qtile")


@hook.subscribe.startup_once
def autostart():
    sub_run([path_join(qtile_path, 'autostart.sh')])
