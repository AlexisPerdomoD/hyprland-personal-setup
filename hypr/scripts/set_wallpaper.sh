#!/bin/env zsh
# changes wallpaper from a list of images in $WALLPAPER_DIR abd updates avalible colors for services

timeout=30
while ! pgrep -x hyprpaper >/dev/null; do
    if [[ $timeout -eq 0 ]]; then
        notify-send "hyprpaper not running"
        exit 1
    fi
    timeout=$((timeout - 1))
    sleep 0.1
done

WALLPAPER_DIR="$HOME/Documents/Wallpapers/"
HISTORY_FILE="$HOME/Documents/.wallpaper_history"
NEXT_WALLPAPER_POSITION=0
LAST_WALLPAPER=""
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f | sort))

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    notify-send "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

if [[ -f $HISTORY_FILE ]]; then
    LAST_WALLPAPER=$(cat $HISTORY_FILE)
fi

if [[ $LAST_WALLPAPER == "" ]]; then
    NEXT_WALLPAPER_POSITION= 1
else
    for i in {1..$#WALLPAPERS[@]}; do

        if [[ ${WALLPAPERS[$i]} == $LAST_WALLPAPER ]]; then
            NEXT_WALLPAPER_POSITION=$((i + 1))

            if [[ $NEXT_WALLPAPER_POSITION -gt $#WALLPAPERS ]]; then
                NEXT_WALLPAPER_POSITION= 1
            fi

            break
        fi
    done
fi

if [[ $NEXT_WALLPAPER_POSITION == 0 ]]; then
    NEXT_WALLPAPER_POSITION=1
fi

WALLPAPER="${WALLPAPERS[$NEXT_WALLPAPER_POSITION]}"
echo "$WALLPAPER" >"$HISTORY_FILE"

hyprctl hyprpaper preload $WALLPAPER &&
    hyprctl hyprpaper wallpaper " ,$WALLPAPER" &&
    wal -i $WALLPAPER &&
    ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors.css" &&
    ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/wofi/colors.css"

# Unomment below if using `swww` for smooth transitions
