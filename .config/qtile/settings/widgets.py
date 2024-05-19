# Qtile widgets

from libqtile import widget
from .theme import colors
from libqtile.widget.battery import Battery, BatteryState
from libqtile.lazy import lazy
from random import randrange
from pathlib import Path
from os.path import join as pjoin


# Generic functions {{{
def base(fg="text", bg="dark"):
    return {
        "foreground": colors[fg] if fg in colors else fg,
        "background": colors[bg] if bg in colors else bg
    }


def separator(bg="dark", size=16):
    return widget.Sep(**base(fg=bg, bg=bg), linewidth=size)


def icon(fg="text", bg="dark", fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark"):
    return widget.TextBox(
        **base(fg, bg),
        text="",       # Icon: nf-cod-triangle_left
        fontsize=34,
        padding=-2
    )
# }}}


# Custom widgets {{{
# Battery Icon and Percentage
class CustomBattery(Battery):
  def build_string(self, status):
    symbols = ""
    index = min(max(int(status.percent * 10), 0), 9) # 0 to 9
    char = symbols[index]

    if status.state == BatteryState.CHARGING:
        char += ""
    elif status.state == BatteryState.UNKNOWN:
        char = ""
    elif status.percent <= 0.3:
        char = "!!!"

    return str(self.format).format(char=char, percent=status.percent)


class RandomWord(widget.TextBox):
    def __init__(self, fg="text", bg="dark"):
        self.generate_random_word()
        super().__init__(
            **base(fg=fg, bg=bg),
            text=self.word,
            mouse_callbacks={
                'Button1': lazy.spawn(f"xdg-open 'https://www.collinsdictionary.com/dictionary/german-english/{self.word}'"),
                'Button3': lazy.spawn(f"xdg-open 'https://dictionary.cambridge.org/dictionary/german-english/{self.word}'"),
            }
        )
    
    def generate_random_word(self):
        self.word = "error"
        words_file = pjoin(Path(__file__).parent.parent.resolve(), "1000-german-words.txt")
        with open(words_file, "r") as f:
            all_words = f.readlines()
            self.word = all_words[randrange(0, len(all_words) - 1)].replace("\n", "")
# }}}


# Widgets present in both screens {{{
def workspaces(): 
    return [
        widget.GroupBox(
            **base(fg="light"),
            font="JetBrainsMono Nerd Font",
            fontsize=19,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors["active"],
            inactive=colors["inactive"],
            rounded=False,
            highlight_method="block",
            urgent_alert_method="block",
            urgent_border=colors["urgent"],
            this_current_screen_border=colors["focus"],
            this_screen_border=colors["grey"],
            other_current_screen_border=colors["dark"],
            other_screen_border=colors["dark"],
            disable_drag=True
        ),

        widget.WindowName(**base(fg="focus"), fontsize=14, padding=5),
    ]

def word_widget(fg="text", bg="dark", left_bg="dark"):
    return [
        powerline(fg=bg, bg=left_bg),

        icon(fg=fg, bg=bg, fontsize=20, text="󱍊 "), # Icon: nf-md-head_question

        RandomWord(fg=fg, bg=bg),

        separator(bg=bg, size=4),
    ]

def layout(fg="text", bg="dark", left_bg="dark"):
    return [
        powerline(fg=bg, bg=left_bg),

        separator(bg=bg, size=2),
        
        widget.CurrentLayoutIcon(**base(fg=fg, bg=bg), scale=0.65),

        separator(bg=bg, size=2),

        widget.CurrentLayout(**base(fg=fg, bg=bg), padding=5),
    ]

def date_and_time(fg="text", bg="dark", left_bg="dark"):
    return [
        powerline(fg=bg, bg=left_bg),

        separator(bg=bg, size=1),

        icon(fg=fg, bg=bg, fontsize=17, text=" "), # Icon: nf-mdi-calendar_clock

        widget.Clock(**base(fg=fg, bg=bg), format="%d/%m/%Y - %H:%M "),
    ]

# }}}

def my_func(text):
    return text.split(' ')[0]

# Primary widgets {{{
primary_widgets = [
    *workspaces(),
    
    # *word_widget(bg="color4"),
    # *layout(bg="color2", left_bg="color4"),

    *layout(bg="color2", left_bg="dark"),

    *date_and_time(bg="color1", left_bg="color2"),

    powerline(fg="dark", bg="color1"),

    CustomBattery(**base(fg="light"), format = "{char} {percent:2.0%}", 
                  notify_below=31, notification_timeout=0),

    widget.Systray(background=colors["dark"], padding=8),

    separator(bg="dark", size=8)
]
# }}}


# Secondary widgets {{{
secondary_widgets = [
    *workspaces(),

    *layout(bg="color1", left_bg="dark"),

    *date_and_time(bg="color2", left_bg="color1"),
]
# }}}


widget_defaults = {
    "font": "JetBrainsMono Nerd Font Bold",
    "fontsize": 14,
    "padding": 0,
}
extension_defaults = widget_defaults.copy()
