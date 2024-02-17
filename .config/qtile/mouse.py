# Mouse controls for floating windows

from libqtile.config import Drag, Click
from libqtile.command import lazy
from keys import mod

mouse = [
    Drag(
        [mod, "shift"], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod, "control"], "Button1",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click(
        [mod], "Button1",
        lazy.window.bring_to_front()
    )
]
