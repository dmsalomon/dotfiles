#!/bin/sh

slock &

case "$(hostname)" in
tini)
	export GDK_SCALE=2.1
	export GDK_DPI_SCALE=1
	export QT_SCALE_FACTOR=1.8
	export FORCE_DEVICE_SCALE_FACTOR=1.8
	xset s 600 600
	;;
deuce)
	export GDK_SCALE=3
	export GDK_DPI_SCALE=1
	export QT_SCALE_FACTOR=2.5
	export FORCE_DEVICE_SCALE_FACTOR=2.5
	xset s 300 300
	xmodmap -e 'remove control = Control_R' -e 'add mod4 = Control_R'
	;;
esac

# setup a gnome keyring
dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# use scroll lock to switch between english/hebrew
setxkbmap -layout 'us, il' -option 'grp:sclk_toggle'
#setxkbmap -option caps:swapescape
xset r rate 400 30

autocutsel -fork
autocutsel -selection PRIMARY -fork
unclutter -b

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
export AWT_TOOLKIT=MToolkit
export PATH="$HOME/.bin:$PATH"
wal -Rn
xwallpaper --zoom ~/.wal

case "${wm:-bspwm}" in
bspwm)
	locker &
	picom &
	sxhkd &
	nextcloud &
	exec bspwm
	;;
*)
	exec "$wm"
	;;
esac
