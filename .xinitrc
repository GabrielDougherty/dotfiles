[ -f "$HOME/.profile" ] && . "$HOME/.profile"
#exec ck-launch-session startxfce4
#xset +fp /usr/local/lib/share/ghostscript/fonts
# update font path
xset +fp /usr/local/share/fonts/ghostscript/
xset +fp /usr/local/share/fonts/terminus
feh --bg-fill ~/Pictures/by_gathering3_2880.jpg

# get rid of annoying beep
xset -b

#xsetroot -solid gray40
conky | dzen2 &
export LC_CTYPE=en_US.UTF-8

exec ck-launch-session cwm

/home/gabriel/scripts/battery.sh &
