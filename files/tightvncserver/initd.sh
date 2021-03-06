#!/bin/sh
# update-rc.d tightvncserver defaults
### BEGIN INIT INFO
# Provides:          tightvncserver
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop tightvncserver
### END INIT INFO

# More details see:
# http://www.penguintutor.com/linux/tightvnc

### Customize this entry
# Set the USER variable to the name of the user to start tightvncserver under
export USER='mahmoud'
### End customization required

eval cd ~${USER}

case "$1" in
  start)
    su $USER -c '/usr/bin/tightvncserver :1'
    echo "Starting TightVNC server for $USER "
    ;;
  stop)
    pkill Xtightvnc
    echo "Tightvncserver stopped"
    ;;
  restart)
      pkill Xtightvnc
      echo "Tightvncserver stopped"
      su $USER -c '/usr/bin/tightvncserver :1'
      echo "Starting TightVNC server for $USER "
      ;;
  *)
    echo "Usage: /etc/init.d/tightvncserver {start|stop|restart}"
    exit 1
    ;;
esac
exit 0
