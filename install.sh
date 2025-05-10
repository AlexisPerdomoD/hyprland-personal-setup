sudo pacman -S --needed --noconfirm hyprland hyprpaper hyprshot wlogout mako waybar wofi alacritty gtk-3.0 gtk-4.0 slurp wf-recorder zellij

rm -rf ~/.config/hypr
rm -rf ~/.config/mako
rm -rf ~/.config/waybar
rm -rf ~/.config/wofi
rm -rf ~/.config/zellij

ln -s ./hypr ~/.config/hypr
ln -s ./mako ~/.config/mako
ln -s ./waybar ~/.config/waybar
ln -s ./wofi ~/.config/wofi
ln -s ./zellij ~/.config/zellij
