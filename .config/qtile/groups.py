# Groups configuration

from libqtile.config import Key, Group
from libqtile.command import lazy
from keys import mod, keys
from libqtile.config import ScratchPad, DropDown
from os import environ

terminal = environ.get("TERMINAL")

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # Switch to explicit group
            Key([mod], i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # Carry focused window to explicit group
            Key([mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Carry focused window to group {}".format(i.name),
            ),
            # Send focused window to explicit group
            Key([mod, "mod1", "shift"], i.name, 
                lazy.window.togroup(i.name),
                desc="Send focused window to group {}".format(i.name)),
        ]
    )

# Append a scratchpad group
conf = {
    "warp_pointer": False,
    "on_focus_lost_hide": False,
    "opacity": 0.80,
}

groups.append(
    ScratchPad(
        "scratch", [
            # Define a drop down terminal
            # it is placed in the upper third of the screen by default
            DropDown(
                "term",
                "alacritty -a 'Terminal'",
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.2,
                **conf
            ),

        ]
    )
)

# Define keys to toggle the dropdown terminals
keys.extend([
    Key([mod, "shift"], "Return", 
        lazy.group["scratch"].dropdown_toggle("term")),
])
