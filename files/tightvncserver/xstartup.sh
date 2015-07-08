#!/bin/sh
# belongs in ~/.vnc/xstartup, chmod 755
# Uncomment the following two lines for normal desktop:
unset SESSION_MANAGER
/usr/bin/startlxde

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
#vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
