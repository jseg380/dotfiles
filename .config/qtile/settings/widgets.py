from libqtile import widget
from .theme import colors
from libqtile.widget.battery import Battery, BatteryState
#from .thingsiplay.widget import output   # Should substitute GetPollCommand, but doesn't work

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)

def base(fg='text', bg='dark'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg='text', bg='dark', fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark"):
    return widget.TextBox(
        **base(fg, bg),
        # text="", # Icon: nf-oct-triangle_left
        text="", # Icon: nf-cod-triangle_left
        fontsize=34,
        padding=-2
    )


def workspaces(): 
    return [
        # separator(),
        widget.GroupBox(
            **base(fg='light'),
            font='JetBrainsMono Nerd Font',
            fontsize=19,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
        separator(),
        widget.WindowName(**base(fg='focus'), fontsize=14, padding=5),
        separator(),
    ]


# Battery Icon & % | Replaces widget.Battery
class MyBattery(Battery):
  def build_string(self, status):
    symbols = ""
    index = int(status.percent * 10)
    index = min(max(index, 0), 9) # 0 to 9
    char = symbols[index]
    if status.state == BatteryState.CHARGING:
      char += ""
      if status.state == BatteryState.UNKNOWN:
        char = ""
    return self.format.format(char=char, percent=status.percent)

battery = MyBattery(
    **base(fg='light'),
    format = '{char} {percent:2.0%}')

primary_widgets = [
    *workspaces(),

    separator(),

    powerline('color4', 'dark'),

    icon(bg="color4", text='  '), # Icon: nf-mdi-brightness_6
    
    widget.Backlight(
        background=colors['color4'],
        foreground=colors['text'],
        backlight_name='amdgpu_bl1',
        change_command='brightness {0}',
        update_interval=10,            # 0.2s default value
    ),

    powerline('color3', 'color4'),

    icon(bg="color3", text=' '),  # Icon: nf-fa-feed
    
    widget.Net(**base(bg='color3'), interface='wlan0'),

    powerline('color2', 'color3'),

    widget.CurrentLayoutIcon(**base(bg='color2'), scale=0.65),

    widget.CurrentLayout(**base(bg='color2'), padding=5),

    powerline('color1', 'color2'),

    icon(bg="color1", fontsize=17, text=' '), # Icon: nf-mdi-calendar_clock

    widget.Clock(**base(bg='color1'), format='%d/%m/%Y - %H:%M '),

    powerline('dark', 'color1'),

    battery,

    widget.Systray(background=colors['dark'], padding=5),
]

secondary_widgets = [
    *workspaces(),

    separator(),

    powerline('color1', 'dark'),

    widget.CurrentLayoutIcon(**base(bg='color1'), scale=0.65),

    widget.CurrentLayout(**base(bg='color1'), padding=5),

    powerline('color2', 'color1'),

    icon(bg="color2", fontsize=17, text=' '), # Icon: nf-mdi-calendar_clock

    widget.Clock(**base(bg='color2'), format='%d/%m/%Y - %H:%M '),

    # powerline('dark', 'color2'),
]

widget_defaults = {
    'font': 'JetBrainsMono Nerd Font Bold',
    'fontsize': 14,
    'padding': 0,
}
extension_defaults = widget_defaults.copy()
