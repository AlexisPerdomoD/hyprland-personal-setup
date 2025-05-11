#!/bin/env zsh

local timeout=30
while ! pgrep -x hyprpaper >/dev/null; do
    if [[ $timeout -eq 0 ]]; then
        notify-send "hyprpaper not running"
        exit 1
    fi
    timeout=$((timeout - 1))
    sleep 0.1
done

local WALLPAPER_DIR="$HOME/Documents/Wallpapers/"
local HISTORY_FILE="$HOME/Documents/.wallpaper_history"
local next_index=0
local last_wallpaper=""
local WALLPAPERS=($(find "$WALLPAPER_DIR" -type f | sort))

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    notify-send "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

if [[ -f $HISTORY_FILE ]]; then
    last_wallpaper=$(cat $HISTORY_FILE)
fi

if [[ $last_wallpaper == "" ]]; then
    next_index=1
else
    for i in {1..$#WALLPAPERS[@]}; do

        if [[ ${WALLPAPERS[$i]} == $last_wallpaper ]]; then
            local new_value=$((i + 1))
            if [[ $new_value -gt $#WALLPAPERS ]]; then
                next_index=1
                break
            fi

            next_index=$((new_value))
            break
        fi
    done
fi

if [[ $next_index == 0 ]]; then
    next_index=1
fi

WALLPAPER="${WALLPAPERS[$next_index]}"
echo "$WALLPAPER" >"$HISTORY_FILE"
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper " ,$WALLPAPER"

# Uncomment below if using `swww` for smooth transitions
# swww img "$WALLPAPER" --transition-type grow --transition-duration 1
