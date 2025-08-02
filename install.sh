#!/bin/env bash

REPO_PATH="$(pwd)"
yay -S --needed --noconfirm \
    hyprland \
    hyprpaper \
    hyprshot \
    python-pywal16 \
    wlogout \
    mako \
    wofi \
    alacritty \
    gtk3 \
    gtk4 \
    slurp \
    wf-recorder \
    zellij \
    thunar \
    bibata-cursor-theme \
    pavucontrol-qt \
    qt5ct \
    qt6ct \
    lxappearance \
    fastfetch \
    btop \
    caelestia-shell-git

# @deprecated
# waybar \
# Waybar status bar configuration
# [ "$(readlink "$HOME/.config/waybar")" != "$REPO_PATH/waybar" ] &&
#     ln -sf "$REPO_PATH/waybar" "$HOME/.config/waybar"

# Create symbolic links for configuration directories if they don't already exist or point to different locations
# This ensures all config files are managed from this repository

# Hyprland window manager configuration
[ "$(readlink "$HOME/.config/hypr")" != "$REPO_PATH/hypr" ] &&
    ln -sf "$REPO_PATH/hypr" "$HOME/.config/hypr"

# Mako notification daemon configuration
[ "$(readlink "$HOME/.config/mako")" != "$REPO_PATH/mako" ] &&
    ln -sf "$REPO_PATH/mako" "$HOME/.config/mako"

# Wofi application launcher configuration
[ "$(readlink "$HOME/.config/wofi")" != "$REPO_PATH/wofi" ] &&
    ln -sf "$REPO_PATH/wofi" "$HOME/.config/wofi"

# Zellij terminal multiplexer configuration
[ "$(readlink "$HOME/.config/zellij")" != "$REPO_PATH/zellij" ] &&
    ln -sf "$REPO_PATH/zellij" "$HOME/.config/zellij"

# XDG desktop portal configuration for screen sharing and other desktop integration features
[ "$(readlink "$HOME/.config/xdg-desktop-portal")" != "$REPO_PATH/xdg-desktop-portal" ] &&
    ln -sf "$REPO_PATH/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

# Fastfetch system information display configuration
[ "$(readlink "$HOME/.config/fastfetch")" != "$REPO_PATH/fastfetch" ] &&
    ln -sf "$REPO_PATH/fastfetch" "$HOME/.config/fastfetch"

# Firefox styling
[ "$(readlink "$HOME/.config/firefox")" != "$REPO_PATH/firefox" ] &&
    ln -sf "$REPO_PATH/firefox" "$HOME/.config/firefox"

# thunar
[ "$(readlink "$HOME/.config/Thunar")" != "$REPO_PATH/thunar" ] &&
    ln -sf "$REPO_PATH/thunar" "$HOME/.config/Thunar"
# thunar
[ "$(readlink "$HOME/.config/btop")" != "$REPO_PATH/btop" ] &&
    ln -sf "$REPO_PATH/btop" "$HOME/.config/btop"
# caelestia-shell-git
[ "$(readlink "$HOME/.config/caelestia")" != "$REPO_PATH/caelestia" ] &&
    ln -sf "$REPO_PATH/caelestia" "$HOME/.config/caelestia"

# Modificar electron app lanzadores para compatibilidad con wayland
DESKTOP_FILE="/usr/share/applications/insomnia.desktop"
INSOMNIA_DESKTOP="/usr/share/applications/slack.desktop"

[[ -f "$INSOMNIA_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=slack|Exec=slack --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$INSOMNIA_DESKTOP"

[[ -f "$INSOMNIA_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=insomnia|Exec=insomnia --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$DESKTOP_FILE"
