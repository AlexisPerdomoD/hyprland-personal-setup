# lauch Wofi
if ! pgrep wofi >/dev/null; then
    wofi --show drun --height 16% --width 20% &
else
    killall wofi
fi
