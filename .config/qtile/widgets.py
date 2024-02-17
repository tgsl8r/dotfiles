# Widgets
# https://www.nerdfonts.com/cheat-sheet

import os
import subprocess
from libqtile import qtile
from libqtile import widget
from libqtile.lazy import lazy
from colours import colours


widget_defaults = dict(
    font="FiraCode Nerd Font", fontsize="14", padding=2, foreground=colours["blue"]
)

extension_defaults = widget_defaults.copy()

primary_widgets = [
    widget.Spacer(length=10),
    widget.GroupBox(
        padding=0,
        active=colours["yellow"],
        borderwidth=3,
        inactive=colours["blue"],
        this_current_screen_border=colours["yellow"],
        this_screen_border=colours["yellow"],
        other_screen_border=colours["blue"],
        other_current_screen_border=colours["blue"],
        font="FiraCode Nerd Font",
        fontsize=14,
        highlight_method="line",
        highlight_color=["00000000", "00000000"],
    ),
    widget.CurrentLayoutIcon(scale=0.5, **widget_defaults),
    # widget.CurrentLayout(**widget_defaults),
    widget.Spacer(length=5),
    widget.WindowName(),
    widget.Spacer(),
    widget.Prompt(),
    widget.CheckUpdates(
        **widget_defaults,
        update_interval=600,
        distro="Arch_paru",
        custom_command="~/.local/bin/bar/updates",
        display_format=" {updates}",
        colour_have_updates=colours["yellow"],
        execute='alacritty zsh -c "paru -Syu"',
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
    widget.KeyboardLayout(configured_keyboards=["gb", "us"]),
    widget.Spacer(length=5),
    widget.GenPollText(
        fmt="| {}",
        update_interval=1,
        **widget_defaults,
        func=lambda: subprocess.check_output(
            os.path.expanduser("~/.local/bin/bar/brightness")
        ).decode(),
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/brightness down"), shell=True
            ),
            "Button3": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/brightness up"), shell=True
            ),
        },
    ),
    widget.Spacer(length=5),
    widget.GenPollText(
        fmt="| {}",
        update_interval=1,
        **widget_defaults,
        func=lambda: subprocess.check_output(
            os.path.expanduser("~/.local/bin/bar/volume")
        ).decode(),
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/volume down"), shell=True
            ),
            "Button2": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/volume mute"), shell=True
            ),
            "Button3": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/volume up"), shell=True
            ),
        },
    ),
    widget.Spacer(length=5),
    widget.GenPollText(
        fmt="| {}",
        update_interval=1,
        **widget_defaults,
        func=lambda: subprocess.check_output(
            os.path.expanduser("~/.local/bin/bar/network")
        ).decode(),
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/network ShowInfo"), shell=True
            ),
            "Button3": lambda: lazy.spawn("alacritty -e nmtui", shell=True),
        },
    ),
    widget.Spacer(length=5),
    widget.GenPollText(
        fmt="| {}",
        update_interval=1,
        **widget_defaults,
        func=lambda: subprocess.run(
            ["/home/toby/.asdf/shims/python", "home/toby/.local/bin/bar/battery.py"],
            check=True,
            capture_output=True,
        )
        .stdout()
        .decode(),
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/bar/battery.py --c left-click"),
                shell=True,
            )
        },
    ),
    widget.Spacer(length=5),
    widget.Clock(
        format="| %Y-%m-%d %a %I:%M %p",
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/calendar show"), shell=True
            ),
            "Button3": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/calendar edit"), shell=True
            ),
        },
    ),
]

secondary_widgets = [
    widget.Spacer(length=10),
    widget.GroupBox(
        padding=0,
        active=colours["yellow"],
        borderwidth=3,
        inactive=colours["blue"],
        this_current_screen_border=colours["yellow"],
        this_screen_border=colours["yellow"],
        other_screen_border=colours["blue"],
        other_current_screen_border=colours["blue"],
        font="FiraCode Nerd Font",
        fontsize=12,
        highlight_method="line",
        highlight_color=["00000000", "00000000"],
    ),
    widget.CurrentLayoutIcon(scale=0.6, **widget_defaults),
    widget.CurrentLayout(**widget_defaults),
    widget.Spacer(),
    widget.Clock(
        format="| %Y-%m-%d %a %I:%M %p",
        mouse_callbacks={
            "Button1": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/calendar.sh show"), shell=True
            ),
            "Button3": lambda: lazy.spawn(
                os.path.expanduser("~/.local/bin/calendar.sh edit"), shell=True
            ),
        },
    ),
]
