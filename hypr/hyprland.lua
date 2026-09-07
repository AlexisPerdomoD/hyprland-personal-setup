-- GLOBAL COMMANDS -------------------------------------------------------------
TERM_CMD = 'alacritty'
FANCY_TERM_CMD = 'kitty'
FILE_MANAGER_CMD = 'thunar'
MAIN_EDITOR_CMD = 'neovide'
MENU_CMD = 'killall wofi; wofi --show drun --prompt Search --height 16% --width 20%   --insensitive # --allow-images'
SCREEN_SHOT_CMD = 'hyprshot -m region -o ~/Pictures/Screenshots'
SCREEN_RECORDER_CMD = '~/.config/hypr/scripts/screen_recorder.sh'

-- STARTUP ---------------------------------------------------------------------
hl.on('hyprland.start', function()
    hl.exec_cmd 'dms run'
    hl.exec_cmd 'ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr &'
    hl.exec_cmd 'hyprctl setcursor Bibata-Modern-Classic 16'
    hl.exec_cmd 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP GDK_BACKEND QT_QPA_PLATFORM SDL_VIDEODRIVER _JAVA_AWT_WM_NONREPARENTING QT_QPA_PLATFORMTHEME'

    hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')
    hl.env('XDG_SESSION_TYPE', 'wayland')
    hl.env('XDG_SESSION_DESKTOP', 'Hyprland')
    hl.env('GDK_BACKEND', 'wayland,x11')
    hl.env('QT_QPA_PLATFORM', 'wayland')
    hl.env('OZONE_PLATFORM', 'wayland')
    hl.env('SDL_VIDEODRIVER', 'wayland')
    hl.env('_JAVA_AWT_WM_NONREPARENTING', 1)
    hl.env('QT_QPA_PLATFORMTHEME', 'qt5ct')
    hl.env('HYPRCURSOR_THEME', 'Bibata-Modern-Classic')
    hl.env('XCURSOR_SIZE', 16)
    hl.env('HYPRCURSOR_SIZE', 16)
    hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')
end)

-- GENERAL ---------------------------------------------------------------------
hl.monitor {
    output = '',
    mode = 'preferred',
    position = 'auto',
    scale = 'auto',
}

hl.config {
    general = {
        resize_on_border = true,
        allow_tearing = false,
        layout = 'master',
    },

    master = {
        new_status = 'inherit',
        orientation = 'right',
        mfact = 0.70,
    },

    misc = {
        disable_hyprland_logo = false,
        font_family = 'Terminess Nerd Font',
        on_focus_under_fullscreen = 1,
        focus_on_activate = true,
        vrr = 2,
    },

    input = {
        repeat_delay = 110,
        repeat_rate = 180,
        accel_profile = 'adaptive',
        kb_layout = 'us',
        follow_mouse = 1,
        sensitivity = 0.7,
        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        inactive_timeout = 60,
        hide_on_key_press = true,
    },

    gestures = {
        workspace_swipe_touch = true,
    },
}

-- MODULES ---------------------------------------------------------------------
require 'modules.animations'
require 'modules.decorations'
require 'modules.keybindings'
require 'modules.windowrules'

-- DMS OVERRIDES ----------------------------------------------------------------
pcall(require, 'dms.colors')
pcall(require, 'dms.layout')
pcall(require, 'dms.outputs')
pcall(require, 'dms.windowrules')
