#!/usr/bin/bash
# changes wallpaper from a list of images in $WALLPAPER_DIR abd updates avalible colors for services

WALLPAPER_DIR="$HOME/Documents/Wallpapers/"
HISTORY_FILE="$HOME/Documents/.wallpaper_history"
NEXT_WALLPAPER_POSITION=0
LAST_WALLPAPER=""
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f | sort))
SOCKET_PATH=$(find "$XDG_RUNTIME_DIR/hypr" -type s -name ".hyprpaper.sock" | sort -r | head -n1)
# Espera a que hyprpaper cree su socket (máx 1s)
for i in {1..100}; do
    if [ -S $SOCKET_PATH ]; then
        break
    fi
    sleep 0.01
done

[ -S $SOCKET_PATH ] || exit 1

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    notify-send "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

[[ -f $HISTORY_FILE ]] &&
    LAST_WALLPAPER=$(cat $HISTORY_FILE)

if [[ $LAST_WALLPAPER != "" ]]; then
    for ((i = 0; i < ${#WALLPAPERS[@]}; i++)); do

        if [[ ${WALLPAPERS[$i]} == $LAST_WALLPAPER ]]; then
            NEXT_WALLPAPER_POSITION=$((i + 1))

            [[ $NEXT_WALLPAPER_POSITION -ge ${#WALLPAPERS[@]} ]] &&
                NEXT_WALLPAPER_POSITION=0

            break
        fi

    done
fi

WALLPAPER="${WALLPAPERS[$NEXT_WALLPAPER_POSITION]}"
wal -i $WALLPAPER &&
    hyprctl hyprpaper preload $WALLPAPER &&
    hyprctl hyprpaper wallpaper " ,$WALLPAPER" &&
    echo $WALLPAPER >$HISTORY_FILE ||
    exit 1

ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors.css"
ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/wofi/colors.css"
ln -sf "$HOME/.cache/wal/colors-mako" "$HOME/.config/mako/colors"
