# Screens Config

from libqtile import qtile
from libqtile.config import Screen, Key
from libqtile.command import lazy
from libqtile import bar
from libqtile.log_utils import logger
from widgets import primary_widgets, secondary_widgets
from keys import keys, mod


def status_bar(widgets):
    return bar.Bar(
        widgets, 24, background="#000000AA", margin=[0, 10, 0, 10]
    )  # Margin = N E S W


screens = [
    Screen(
        wallpaper=".cache/wallpaper",
        wallpaper_mode="fill",
        top=status_bar(primary_widgets),
    )
]

connected_monitors = 1  # len(qtile.core.outputs)
logger.warning(f"Found {connected_monitors} monitor(s)")

if connected_monitors > 1:
    for _ in range(1, connected_monitors):
        screens.append(
            Screen(
                wallpaper=".cache/wallpaper",
                wallpaper_mode="fill",
                top=status_bar(primary_widgets),
            )
        )

# Keys for sending windows to explicit monitors
for i in range(connected_monitors):
    keys.extend([Key([mod, "mod1"], str(i), lazy.window.toscreen(i))])
