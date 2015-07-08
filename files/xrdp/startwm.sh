#!/bin/sh
# might not be needed, lives in /etc/xrdp/startwm.sh

if [ -r /etc/default/locale ]; then
    . /etc/default/locale
    export LANG LANGUAGE
fi

startlxde
