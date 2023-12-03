# Hooks configuration

import asyncio
import os
import subprocess
import time
from libqtile import qtile
from libqtile import hook
from libqtile.command import lazy

from groups import groups
from libqtile.log_utils import logger


# Startup
@hook.subscribe.startup_once
def autostart():
    lazy.hide_show_bar(position="all")
    lazy.core.hide_cursor()
    home = os.path.expanduser("~")
    subprocess.Popen([home + "/.config/qtile/autostart.sh"])


# Reload config on screen changes
@hook.subscribe.screens_reconfigured
async def outputs_changed():
    logger.warning("Screens reconfigured")
    await asyncio.sleep(1)
    logger.warning("Reloading config...")
    qtile.reload_config()


# Show cursor on mouse wiggle (may not work with one widow open)
@hook.subscribe.client_mouse_enter
def client_mouse_enter(client):
    qtile.core.unhide_cursor()


# Work around for matching Spotify
@hook.subscribe.client_new
def slight_delay(window):
    time.sleep(0.04)


# If Spotify opens move it to group 9
@hook.subscribe.client_name_updated
def spotify(window):
    if window.name == "Spotify":
        window.togroup(group_name="9")


# If mpv opens float it at pos x, y, w, h, borderwidth, border color
@hook.subscribe.client_managed
def repos(window):
    if window.get_wm_class() and "mpv" in window.get_wm_class():
        window.floating = True
        window.place(1200, 650, 640, 360, 2, "#ffffff")


# If 'libreoffice' opens toggle floating off
@hook.subscribe.client_new
def libreoffice(window):
    wm_class = window.get_wm_class()
    if wm_class is None:
        wm_class = []
    if [x for x in wm_class if x.startswith("libreoffice")]:
        window.disable_floating()
