# Qtile Config File
# http://www.qtile.org/

from typing import List  # noqa: F401
import hooks
from keys import mod, keys, home
from groups import groups
from layouts import layouts, floating_layout
from widgets import widget_defaults, extension_defaults
from screens import screens
from mouse import mouse
from libqtile.backend.wayland import InputConfig

# Configure input devices

wl_input_rules = {
    "type:keyboard": InputConfig(
#       kb_layout="gb", 
        kb_layout="us", 
#       kb_options="caps:escape_shifted_capslock,altwin:prtsc_rwin,compose:ins"
        )
}

# Misc options
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
auto_minimize = False
focus_on_window_activation = "smart"
reconfigure_screens = True

wmname = "Qtile"
