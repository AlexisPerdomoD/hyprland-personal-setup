#!/bin/env bash

REPO_PATH="$(pwd)"

########## CORE ##############
sudo pacman -S --needed --noconfirm hyprland alacritty gtk3 gtk4 slurp zellij thunar bibata-cursor-theme qt5ct qt6ct lxappearance fastfetch btop foot neovide
# DEPRECADO
# hyprpaper \
# hyprshot \
# python-pywal16 \
# wf-recorder \
# caelestia-shell-git

########### FONTS ############
sudo pacman -S --needed --noconfirm ttf-meslo-nerd ttf-fantasque-nerd ttf-martian-mono-nerd ttf-profont-nerd ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-go-nerd ttf-terminus-nerd ttf-hack-nerd

########## LINKS ############
# Wallpapers
[ "$(readlink "$HOME/Documents/Wallpapers")" != "$REPO_PATH/Wallpapers" ] &&
    ln -sf "$REPO_PATH/Wallpapers" "$HOME/Documents/Wallpapers"

[ "$(readlink "$HOME/.bashrc")" != "$REPO_PATH/shell/.bashrc" ] &&
    ln -sf "$REPO_PATH/shell/.bashrc" "$HOME/.bashrc"

[ "$(readlink "$HOME/.config/hypr")" != "$REPO_PATH/hypr" ] &&
    ln -sf "$REPO_PATH/hypr" "$HOME/.config/hypr"

[ "$(readlink "$HOME/.config/xdg-desktop-portal")" != "$REPO_PATH/xdg-desktop-portal" ] &&
    ln -sf "$REPO_PATH/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

[ "$(readlink "$HOME/.config/fastfetch")" != "$REPO_PATH/fastfetch" ] &&
    ln -sf "$REPO_PATH/fastfetch" "$HOME/.config/fastfetch"

[ "$(readlink "$HOME/.config/alacritty")" != "$REPO_PATH/alacritty" ] &&
    ln -sf "$REPO_PATH/alacritty" "$HOME/.config/alacritty"

[ "$(readlink "$HOME/.config/firefox")" != "$REPO_PATH/firefox" ] &&
    ln -sf "$REPO_PATH/firefox" "$HOME/.config/firefox"

[ "$(readlink "$HOME/.config/Thunar")" != "$REPO_PATH/thunar" ] &&
    ln -sf "$REPO_PATH/thunar" "$HOME/.config/Thunar"

[ "$(readlink "$HOME/.config/btop")" != "$REPO_PATH/btop" ] &&
    ln -sf "$REPO_PATH/btop" "$HOME/.config/btop"

# [ "$(readlink "$HOME/.config/caelestia")" != "$REPO_PATH/caelestia" ] &&
#     ln -sf "$REPO_PATH/caelestia" "$HOME/.config/caelestia"

[ "$(readlink "$HOME/.config/foot")" != "$REPO_PATH/foot" ] &&
    ln -sf "$REPO_PATH/foot" "$HOME/.config/foot"

########### WAYLAND COMPATIBILITY #############
INSOMNIA_DESKTOP="/usr/share/applications/insomnia.desktop"
SLACK_DESKTOP="/usr/share/applications/slack.desktop"

[[ -f "$SLACK_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=slack|Exec=slack --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$SLACK_DESKTOP"

[[ -f "$INSOMNIA_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=insomnia|Exec=insomnia --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$INSOMNIA_DESKTOP"
