# Qtile screens
# Multimonitor support

from libqtile.config import Screen
from libqtile import bar
from libqtile.log_utils import logger
from .widgets import primary_widgets, secondary_widgets
from subprocess import run as sub_run
from subprocess import PIPE as sub_PIPE


def status_bar(widgets):
    return bar.Bar(widgets, 24, opacity=0.92)


screens = [Screen(top=status_bar(primary_widgets))]

xrandr = "xrandr | grep ' connected' | wc -l"

command = sub_run(
    xrandr,
    shell=True,
    stdout=sub_PIPE,
    stderr=sub_PIPE,
)

if command.returncode != 0:
    error = command.stderr.decode("UTF-8")
    logger.error(f"Failed counting monitors using '{xrandr}':\n{error}")
    connected_monitors = 1
else:
    connected_monitors = int(command.stdout.decode("UTF-8"))

if connected_monitors > 1:
    for _ in range(1, connected_monitors):
        screens.append(Screen(top=status_bar(secondary_widgets)))
