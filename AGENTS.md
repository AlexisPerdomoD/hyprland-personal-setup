# AGENTS.md — Hyprland Personal Setup

Static dotfiles repo managed via symlinks. No build system, no tests, no package manager.

## Setup

- Run `install.sh` **from repo root** — uses `$(pwd)` for symlink targets, so `cd /repo && ./install.sh`.
- Installs packages via `yay` (AUR helper) and `pacman`, then creates `ln -sf` from repo dirs → `~/.config/<app>`.
- Re-running install.sh is safe; it refreshes symlinks.

## Architecture

| Dir | Symlinked to | Notes |
|-----|-------------|-------|
| `hypr/` | `~/.config/hypr` | Main compositor config; entrypoint `hyprland.conf` |
| `shell/` | `~/.bashrc`, `~/.zshrc` | Shell configs |
| `alacritty/` | `~/.config/alacritty` | Imports `dank-theme.toml` |
| `btop/` | `~/.config/btop` | Themes dir is gitignored (generated) |
| `foot/` | `~/.config/foot` | Imports `dank-colors.ini` |
| `thunar/` | `~/.config/Thunar` | File manager bindings |
| `firefox/` | `~/.config/firefox` | Just `userChrome.css` |
| `xdg-desktop-portal/` | `~/.config/xdg-desktop-portal` | Wayland portal config |
| `DankMaterialShell/` | `~/.config/DankMaterialShell` | Active shell/panel system |
| `Wallpapers/` | `~/Documents/Wallpapers` | Wallpaper image collection |

## Keypoints

- **DankMaterialShell (DMS)** is the active panel/shell — replaces legacy `caelestia/`. Settings in `DankMaterialShell/settings.json`.
- **`hypr/scheme/current.conf`** is **generated** (by matugen) and gitignored — sourced first by `hyprland.conf`. Agent must not edit it.
- **`.gitignore`** covers generated color files: `hypr/scheme`, `btop/themes`, `mako/colors`, `wofi/colors.css`, `waybar/colors.css`, `.config/`.
- **`hyprland.conf`** sources: `scheme/current.conf`, `modules/*.conf`, `dms/*.conf`.
- **Monitor:** DP-2 at 2560x1440@144Hz. Master layout, mfact 0.70.
- **Terminal:** alacritty (primary), foot (secondary). Both use Nerd Fonts.
- **Shell:** zsh with starship prompt, fzf, zsh-autosuggestions (auto-cloned on first run).
- **Color system:** matugen (Material You) via DMS templates. Old `set_wallpaper.sh` uses pywal (legacy pipeline).

## Scripts (`hypr/scripts/`)

- `set_wallpaper.sh` — cycles wallpapers via pywal (legacy). Reads from `~/Documents/Wallpapers/`.
- `brightness.sh` — external monitor brightness via `ddcutil` (requires `sudo`). Args: `up`/`down`.
- `screen_recorder.sh` — toggles wf-recorder with slurp region select. Has 300s auto-stop fallback.

## Keybindings (notable)

- `SUPER + D` — DMS dock launcher
- `SUPER + SHIFT + D` — DMS floating launcher
- `SUPER + hjkl` — focus Vim-style
- `SUPER + W` — cycle wallpaper
- `SUPER + S` — toggle scratchpad
- `CTRL + SHIFT + T` — open terminal
- `SUPER + Z` — neovide
- `SUPER + E` — thunar
- `CTRL + ALT + S` — region screenshot (hyprshot)
- `CTRL + ALT + SHIFT + R` — screen record toggle
- `SUPER + V` — toggle float, `SUPER + F` — fullscreen, `SUPER + X` — kill

## Environment

Wayland-native stack: `GDK_BACKEND=wayland,x11`, `QT_QPA_PLATFORM=wayland`, `OZONE_PLATFORM=wayland`. Cursor: Bibata-Modern-Classic 16px.
