# Qtile workspaces

from libqtile.config import Key, Group
from libqtile.lazy import lazy
from .keys import mod, keys


groups = [Group(i) for i in [
    "   ",     # nf-fa-firefox
    "   ",     # nf-fae-python
    "   ",     # nf-dev-terminal
    "   ",     # nf-fa-code
    "   ",     # nf-oct-git_merge
    " 󰡨  ",     # nf-linux-docker
    " 󰉋  ",     # nf-md-folder
    " 󰋩  ",     # nf-md-image
    " 󰌨  ",     # nf-md-layers
]]

for i, group in enumerate(groups):
    actual_key = str(i + 1)
    keys.extend([
        # Switch to workspace N
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
    ])
