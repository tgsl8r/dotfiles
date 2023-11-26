#!/bin/sh

# Autostart script for Qtile

export wallpaper='~/.cache/wallpaper'

dbus-update-activation-environment --systemd \
	WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP

# Authentication dialog
pkill -f /usr/libexec/polkit-gnome-authentication-agent-1
/usr/libexec/polkit-gnome-authentication-agent-1 &

# ssh-agent
eval $(ssh-agent)
ssh-add ~/.ssh/toby-archpad

# Kill any existing pipewire / wireplumber daemons and only then try to start a new set.
pkill -u "${USER}" -x pipewire\|wireplumber 1>/dev/null 2>&1
/usr/bin/pipewire &> /dev/null &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber

# Start xdg-desktop-portal-wlr  
pkill -f /usr/libexec/xdg-desktop-portal-wlr
/usr/libexec/xdg-desktop-portal-wlr &

# Kanshi
pkill -f kanshi
kanshi &

# Notification daemon
pkill -f dunst
dunst &

# clipboard
wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"

# wlsunset
# pkill -f wlsunset
# wlsunset -l 57.4 -L -1.9 &

# Swayidle daemon
# pkill -f swayidle
# swayidle \
#	timeout 5 'qtile cmd-obj -o core -f hide_cursor' resume 'qtile cmd-obj -o core -f unhide_cursor' \
#	timeout 300 'swaylock -f -i $wallpaper' \
#	timeout 600 'wlopm --off \*' resume 'wlopm --on \*' &
