# Key configuration

import os
from libqtile.config import Key
from libqtile.command import lazy

home = os.path.expanduser('~')
terminal = os.environ.get("TERMINAL")
mod = "mod4"

keys = [
    # Move focus to next screen
    Key([mod, "mod1"], "return",
        lazy.next_screen(),
        desc="Move focus to next screen",
        ),
    # Switch active groups
    Key([mod, "mod1"], "l",
        lazy.screen.next_group(skip_empty=True),
        desc="Move to next active group"
        ),
    Key([mod, "mod1"], "h",
        lazy.screen.prev_group(skip_empty=True),
        desc="Move to previous active group"
        ),
    # Switch between windows in current stack pane
    Key([mod], "h",
        lazy.layout.left(),
        desc="Move focus left"
        ),
    Key([mod], "l",
        lazy.layout.right(),
        desc="Move focus right"
        ),
    Key([mod], "j",
        lazy.layout.down(),
        desc="Move focus down"
        ),
    Key([mod], "k",
        lazy.layout.up(),
        desc="Move focus up"
        ),
    # Switch window focus to next pane
    Key([mod], "n", lazy.layout.next(),
        desc="Switch window focus to next pane"
        ),
    # Move window on the current screen
    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        desc='Shuffle left'
        ),
    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        desc='Shuffle right'
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        desc='Shuffle down'
        ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        desc='Shuffle up'
        ),
    # Window sizing
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        desc='Grow down'
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        desc='Grow up'
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        desc='Grow left'
        ),
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        desc='Grow right'
        ),
    Key([mod, "control"], "n",
        lazy.layout.normalize(),
        desc='normalize window size ratios'
        ),
    Key([mod, "control"], "m",
        lazy.layout.maximize(),
        desc='toggle window between minimum and maximum sizes'
        ),
    # Flip in the BSP layout
    Key([mod, "shift", "control"], "j",
        lazy.layout.flip_down(),
        desc='Flip down'
        ),
    Key([mod, "shift", "control"], "k",
        lazy.layout.flip_up(),
        desc='Flip up'
        ),
    Key([mod, "shift", "control"], "h",
        lazy.layout.flip_left(),
        desc='Flip left'
        ),
    Key([mod, "shift", "control"], "l",
        lazy.layout.flip_right(),
        desc='Flip right'
        ),
    Key([mod, "control"], "o",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc='Expand window (MonadTall), increase number in master pane (Tile)'
        ),
    Key([mod, "control"], "i",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
        ),

    # Toggle floating
    Key([mod, "control"], "f", lazy.window.toggle_floating(),
        desc="Toggle floating"
        ),
    # Cycle through windows in the floating layout
    Key([mod, "shift"], "i",
        lazy.window.toggle_minimize(),
        lazy.group.next_window(),
        lazy.window.bring_to_front()
        ),

    # Toggle Fullscreen
    Key([mod], "f",
        lazy.window.toggle_fullscreen(),
        lazy.hide_show_bar(position='all'),
        desc='Toggle fullscreen and the bars'
        ),
    # Toggle bars
    Key([mod], "b",
        lazy.hide_show_bar(position='all'),
        desc="Toggle bars"
        ),

    # Toggle stack split.
    Key([mod, "shift"], "s",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"
        ),
    # Swap panes of split stack
    Key([mod, "shift"], "space",
        lazy.layout.rotate(),
        desc="Swap panes of split stack"
        ),


    # Toggle between different layouts
    Key([mod], "Tab",
        lazy.next_layout(),
        desc="Toggle between layouts"
        ),

    # Qtile system keys
    Key([mod, "control"], "backspace",
        lazy.spawn("" + home + "/.local/bin/powermenu"),
        desc="Launch Power menu"
        ),
    Key([mod], "backspace",
        lazy.spawn("swaylock -f -i .cache/wallpaper"),
        desc="Lock screen"
        ),
    Key([mod, "control"], "r",
        lazy.reload_config(),
        desc="Restart qtile"
        ),
    Key([mod, "control"], "q",
        lazy.shutdown(),
        desc="Shutdown qtile"
        ),
    Key([mod], "q",
        lazy.window.kill(),
        desc="Kill focused window"
        ),
    Key([mod], "v",
        lazy.spawn('clipman pick --tool=CUSTOM --tool-args="fuzzel -d"'),
        desc="Paste from clipman"
        ),

    # Fuzzel
    Key(["control"], "space",
        lazy.spawn("fuzzel"),
        desc="Launch Fuzzel menu"
        ),
    # Window Switcher
    Key([mod, "control"], "w",
        lazy.spawn(home + "/.local/bin/qtile-window-switcher.py"),
        desc="Launch the Window Switcher",
        ),
    # Emoji Picker
    Key([mod, "control"], "e",
        lazy.spawn(home + "/.local/bin/bemoji -n"),
        desc="Launch emoji menu"
        ),

    # Install updates
    Key([mod, "control"], "u",
        lazy.spawn(home + "/.local/bin/bar/updates key-update"),
        desc="Install updates"
        ),
    
    # App Launching
    Key([mod], "r",
        lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"
        ),
    Key([mod], "Return",
        lazy.spawn("alacritty"),
        desc="Launch terminal"
        ),
    Key([mod], "w",
        lazy.spawn("qutebrowser"),
        desc="Launch browser"
        ),

    # ------------ Thinkpad Hardware Keys ------------
    # Volume
    Key([], "XF86AudioMute",
        lazy.spawn(home + "/.local/bin/bar/volume mute"),
        desc='Mute audio'
        ),
    Key([], "XF86AudioMicMute",
        lazy.spawn(home + "/.local/bin/bar/volume micmute"),
        desc='Mute microphone'
        ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn(home + "/.local/bin/bar/volume down"),
        desc='Volume down'
        ),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn(home + "/.local/bin/bar/volume up"),
        desc='Volume up'
        ),

    # Brightness
    Key([], "XF86MonBrightnessDown",
        lazy.spawn(home + "/.local/bin/bar/brightness down"),
        desc='Brightness down'
        ),
    Key([], "XF86MonBrightnessUp",
        lazy.spawn(home + "/.local/bin/bar/brightness up"),
        desc='Brightness up'
        ),

    # Screenshots
    # Take a screenshot of the focused screen
    Key([mod], "p",
        lazy.spawn(home + "/.local/bin/screenshot"),
        desc='Screenshot the currently focused screen to the screenshots folder'
        ),
    # Take a screenshot of the focused window
    Key([mod, "shift"], "p",
        lazy.spawn(home + "/.local/bin/screenshot focused-window"),
        desc='Screenshot the focused window to the screenshots folder'
        ),
    # Take a screenshot of the selected region
    Key([mod, "mod1"], "p",
        lazy.spawn(home + "/.local/bin/screenshot selected-region"),
        desc='Screenshot a region of the screen to the screenshots folder'
        ),
    # Capture region of screen to clipboard
    Key([mod, "mod1", "control"], "p",
        lazy.spawn(home + "/.local/bin/screenshot save-to-clipboard"),
        desc='Screenshot a region of the screen to the clipboard'
        ),
]

# for i in range(1, 5):
#     keys.append(Key(["control", "mod1"], "F" + str(i),
#                     lazy.core.change_vt(i),
#                     desc='Change to virtual console ' + str(i)
#                     ),)
