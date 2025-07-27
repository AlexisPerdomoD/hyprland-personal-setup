#!/bin/env bash

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
    lxappearance

ln -sf ./hypr $HOME/.config/hypr
ln -sf ./mako $HOME/.config/mako
ln -sf ./waybar $HOME/.config/waybar
ln -sf ./wofi $HOME/.config/wofi
ln -sf ./zellij $HOME/.config/zellij
ln -sf ./xdg-desktop-portal $HOME/.config/xdg-desktop-portal

# Modificar slack.desktop para lanzar con flags Wayland
SLACK_DESKTOP="/usr/share/applications/slack.desktop"
if [ -f "$SLACK_DESKTOP" ]; then
    sudo sed -i 's|^Exec=slack|Exec=slack --enable-features=WaylandWindowDecorations --ozone-platform=wayland|' "$SLACK_DESKTOP"
fi
