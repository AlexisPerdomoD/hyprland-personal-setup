#!/bin/env bash

yay -S --needed --noconfirm hyprland hyprpaper hyprshot python-pywal16 wlogout mako waybar wofi alacritty gtk-3.0 gtk-4.0 slurp wf-recorder zellij

ln -sf ./hypr ~/.config/hypr
ln -sf ./mako ~/.config/mako
ln -sf ./waybar ~/.config/waybar
ln -sf ./wofi ~/.config/wofi
ln -sf ./zellij ~/.config/zellij
