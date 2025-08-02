#!/bin/env bash

REPO_PATH="$(pwd)"
yay -S --needed --noconfirm \
    hyprland \
    hyprpaper \
    hyprshot \
    python-pywal16 \
    wlogout \
    mako \
    waybar \
    wofi \
    alacritty \
    gtk-3.0 \
    gtk-4.0 \
    slurp \
    wf-recorder \
    zellij \
    bibata-cursor-theme \
    pavucontrol-qt \
    bluemoon \
    qt5ct \
    qt6ct \
    lxappearance \
    fastfetch

ln -sf $REPO_PATH/hypr $HOME/.config/hypr
ln -sf $REPO_PATH/mako $HOME/.config/mako
ln -sf $REPO_PATH/waybar $HOME/.config/waybar
ln -sf $REPO_PATH/wofi $HOME/.config/wofi
ln -sf $REPO_PATH/zellij $HOME/.config/zellij
ln -sf $REPO_PATH/xdg-desktop-portal $HOME/.config/xdg-desktop-portal
ln -sf $REPO_PATH/fastfetch $HOME/.config/fastfetch

# Modificar electron app lanzadores para compatibilidad con wayland
DESKTOP_FILE="/usr/share/applications/insomnia.desktop"
INSOMNIA_DESKTOP="/usr/share/applications/slack.desktop"

[[ -f "$INSOMNIA_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=slack|Exec=slack --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$INSOMNIA_DESKTOP"

[[ -f "$INSOMNIA_DESKTOP" ]] &&
    sudo sed -i 's|^Exec=insomnia|Exec=insomnia --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$DESKTOP_FILE"
