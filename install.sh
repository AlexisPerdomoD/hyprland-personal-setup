#!/bin/env bash

yay -S --needed --noconfirm hyprland hyprpaper hyprshot python-pywal16 wlogout mako waybar wofi alacritty gtk-3.0 gtk-4.0 slurp wf-recorder zellij bibata-cursor-theme

ln -sf ./hypr $HOME/.config/hypr
ln -sf ./mako $HOME/.config/mako
ln -sf ./waybar $HOME/.config/waybar
ln -sf ./wofi $HOME/.config/wofi
ln -sf ./zellij $HOME/.config/zellij
ln -sf ./xdg-desktop-portal $HOME/.config/xdg-desktop-portal
