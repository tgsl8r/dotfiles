# Widgets
# https://www.nerdfonts.com/cheat-sheet

import os
import subprocess
from libqtile import qtile
from libqtile import widget
from libqtile.lazy import lazy
from colors import colors


widget_defaults = dict(
    font='FiraCode Nerd Font',
    fontsize='14',
    padding=2,
    foreground=colors['light0']
)

extension_defaults = widget_defaults.copy()

primary_widgets = [
    widget.Spacer(length=10),
    widget.GroupBox(
        padding=0,
        active=colors['light0'],
        borderwidth=3,
        inactive=colors['light4'],
        this_current_screen_border=colors['neutral_green'],
        this_screen_border=colors['neutral_green'],
        other_screen_border='#00000000',
        other_current_screen_border='#00000000',
        font='FiraCode Nerd Font',
        fontsize=14,
        highlight_method='line',
        highlight_color=['00000000', '00000000']
    ),
    widget.CurrentLayoutIcon(scale=0.5, **widget_defaults),
    # widget.CurrentLayout(**widget_defaults),
    widget.Spacer(length=5),
    widget.Prompt(),
    widget.WindowName(),
    widget.Spacer(),
    widget.CheckUpdates(
        **widget_defaults,
        update_interval=600,
        distro='Arch_paru',
        custom_command='~/.local/bin/bar/updates',
        display_format=' {updates}',
        colour_have_updates=colors['neutral_green'],
        execute='alacritty zsh -c "pikaur -Syu"'
    ),
    widget.Spacer(length=5),
#    widget.GenPollText(
#        update_interval=1, 
#        **widget_defaults, 
#        func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/bar/idleinhibit")).decode(), 
#        mouse_callbacks=
#        {'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/idleinhibit toggle"), shell=True)}
#        ),
    widget.Spacer(length=5),
    widget.KeyboardLayout(configured_keyboards=['gb', 'us']),
    widget.Spacer(length=5),
    widget.GenPollText(
        update_interval=1, 
        **widget_defaults, 
        func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/bar/brightness")).decode(), 
        mouse_callbacks={
            'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/brightness down"), shell=True), 
            'Button3': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/brightness up"), shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(
        update_interval=1, 
        **widget_defaults, 
        func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/bar/volume")).decode(), 
        mouse_callbacks={
            'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/volume down"), shell=True), 
            'Button2': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/volume mute"), shell=True), 
            'Button3': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/volume up"), shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(
            update_interval=1, 
            **widget_defaults, 
            func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/bar/network")).decode(), 
            mouse_callbacks={
                'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/network ShowInfo"), shell=True), 
                'Button3': lambda: lazy.spawn("alacritty -e nmtui", shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(
        update_interval=1, 
        **widget_defaults, 
        func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/bar/battery.py")).decode(), 
        mouse_callbacks={
            'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/bar/battery.py --c left-click"), shell=True)}),
    widget.Spacer(length=5),
    widget.Clock(
        format="| %Y-%m-%d %a %I:%M %p",
        mouse_callbacks={
            'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/calendar show"), shell=True),
            'Button3': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/calendar edit"), shell=True)
            }
        ),
]

secondary_widgets = [
    widget.Spacer(length=10),
    widget.GroupBox(
        padding=0,
        active=colors['light0'],
        borderwidth=3,
        inactive=colors['light4'],
        this_current_screen_border=colors['neutral_green'],
        this_screen_border=colors['neutral_green'],
        other_screen_border='#00000000',
        other_current_screen_border='#00000000',
        font='GoMono Nerd Font',
        fontsize=12,
        highlight_method='line',
        highlight_color=['00000000', '00000000']
    ),
    widget.CurrentLayoutIcon(scale=0.6, **widget_defaults),
    widget.CurrentLayout(**widget_defaults),
    widget.Spacer(),
    widget.Clock(
        format="| %Y-%m-%d %a %I:%M %p",
        mouse_callbacks={
            'Button1': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/calendar.sh show"), shell=True),
            'Button3': lambda: lazy.spawn(os.path.expanduser("~/.local/bin/calendar.sh edit"), shell=True)
            }
        ),
]
