# Qtile layouts and layout rules

from libqtile import layout
from libqtile.config import Match
from .theme import colors


layout_conf = {
    "border_focus": colors["focus"][0],
    "border_width": 1,
    "margin": 4
}

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_conf),
    layout.Matrix(columns=2, **layout_conf),
    layout.TreeTab(**layout_conf),
    # layout.MonadWide(**layout_conf),
    # layout.Bsp(**layout_conf),
    # layout.RatioTile(**layout_conf),
    # layout.Columns(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        # From reddit: https://www.reddit.com/r/qtile/comments/sgiscd/comment/huwrmlg/?utm_source=share&utm_medium=web2x&context=3
        Match(wm_class="confirm"),
        Match(wm_class="confirmreset"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="gnome-calculator"),             # Calculator
        Match(wm_class="popup-input"),                  # Custom wm_class
        Match(wm_class="Com.cisco.anyconnect.gui"),     # Cisco VPN
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
    border_focus=colors["focus"][0],
    border_width=1,
)
