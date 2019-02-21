#! /bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -layout pl
localectl set-x11-keymap pl
/usr/bin/twmnd &
exec i3

