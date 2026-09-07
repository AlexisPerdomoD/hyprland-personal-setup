local main_mod = 'SUPER'

-- DANK MATERIAL SHELL KEYBINDINGS --------------------------------------------

hl.bind(main_mod .. ' + D', hl.dsp.exec_cmd 'dms ipc call launcher openWith all', { desc = 'Dock Menu' })
hl.bind(main_mod .. ' + E', hl.dsp.exec_cmd 'dms ipc call launcher openWith files', { desc = 'Dock File Finder' })
hl.bind(main_mod .. ' + SHIFT + D', hl.dsp.exec_cmd 'dms ipc call spotlight open', { desc = 'Floating Menu' })
hl.bind(main_mod .. ' + W', hl.dsp.exec_cmd 'dms ipc call powermenu toggle', { desc = 'Dock Power Menu' })

-- KEYBINDINGS ----------------------------------------------------------------
hl.bind('CTRL + SHIFT + T', hl.dsp.exec_cmd(TERM_CMD), { desc = 'Terminal' })
hl.bind(main_mod .. ' + RETURN', hl.dsp.exec_cmd(FANCY_TERM_CMD), { desc = 'Fancy Terminal' })
hl.bind(main_mod .. ' + SHIFT + E', hl.dsp.exec_cmd(FILE_MANAGER_CMD), { desc = 'File Manager' })
hl.bind(main_mod .. ' + N', hl.dsp.exec_cmd(MAIN_EDITOR_CMD), { desc = 'Main Editor' })
hl.bind(main_mod .. ' + SHIFT + X', hl.dsp.window.kill {}, { desc = 'Kill Active Window' })
hl.bind(main_mod .. ' + Q', hl.dsp.window.close {}, { desc = 'Close Active Window' })
hl.bind(main_mod .. ' + SHIFT + M', hl.dsp.exit {}, { desc = 'Exit Hyprland' })
hl.bind(main_mod .. ' + V', hl.dsp.window.float { action = 'toggle' }, { desc = 'Toggle Floating Window' })
hl.bind(main_mod .. ' + F', hl.dsp.window.fullscreen {}, { desc = 'Fullscreen' })
hl.bind(main_mod .. ' + P', hl.dsp.window.pin {}, { desc = 'Pin Window' })
hl.bind(main_mod .. ' + A', hl.dsp.exec_cmd 'ani-cli --dmenu', { desc = 'Ani-cli' })

hl.bind('CTRL + ALT + S', hl.dsp.exec_cmd(SCREEN_SHOT_CMD), { desc = 'Screenshot' })
hl.bind('CTRL +ALT + SHIFT + R', hl.dsp.exec_cmd(SCREEN_RECORDER_CMD), { desc = 'Screen Recorder' })

-- MOVEMENT -------------------------------------------------------------------
hl.bind(main_mod .. ' + LEFT', hl.dsp.focus { direction = 'left' }, { desc = 'Focus Left' })
hl.bind(main_mod .. ' + H', hl.dsp.focus { direction = 'left' }, { desc = 'Focus Left' })
hl.bind(main_mod .. ' + RIGHT', hl.dsp.focus { direction = 'right' }, { desc = 'Focus Right' })
hl.bind(main_mod .. ' + L', hl.dsp.focus { direction = 'right' }, { desc = 'Focus Right' })
hl.bind(main_mod .. ' + UP', hl.dsp.focus { direction = 'up' }, { desc = 'Focus Up' })
hl.bind(main_mod .. ' + K', hl.dsp.focus { direction = 'up' }, { desc = 'Focus Up' })
hl.bind(main_mod .. ' + DOWN', hl.dsp.focus { direction = 'down' }, { desc = 'Focus Down' })
hl.bind(main_mod .. ' + J', hl.dsp.focus { direction = 'down' }, { desc = 'Focus Down' })
hl.bind(main_mod .. ' + TAB', hl.dsp.layout 'rollnext', { desc = 'Next Layout' })
hl.bind(main_mod .. ' + SHIFT + TAB', hl.dsp.layout 'rollprev', { desc = 'Previous Layout' })
hl.bind(main_mod .. ' + SPACE', hl.dsp.layout 'focusmaster master', { desc = 'Focus Master' })
hl.bind(main_mod .. ' + P', hl.dsp.layout 'swapwithmaster', { desc = 'Swap with Master' })
-- SWITCH WORKSPACES WITH MAIN_MOD + [0-9]
for i = 1, 10 do
    local k = i % 10
    hl.bind(main_mod .. '+' .. k, hl.dsp.focus { workspace = i }, { desc = 'Switch to Workspace ' .. i })
    hl.bind(main_mod .. '+SHIFT+' .. k, hl.dsp.window.move { workspace = i }, { desc = 'Move Window to Workspace ' .. i })
end

hl.bind(main_mod .. ' + S', hl.dsp.workspace.toggle_special 'magic')
hl.bind(main_mod .. ' + SHIFT + S', hl.dsp.window.move { workspace = 'special:magic' })

-- SCROLL THROUGH EXISTING WORKSPACES WITH MAINMOD + SCROLL
hl.bind(main_mod .. ' + mouse_down', hl.dsp.focus { workspace = 'e+1' })
hl.bind(main_mod .. ' + mouse_up', hl.dsp.focus { workspace = 'e-1' })

-- MOVE/RESIZE WINDOWS WITH MAINMOD + LMB/RMB AND DRAGGING
hl.bind(main_mod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

hl.bind(main_mod .. ' + page_up', hl.dsp.workspace.move { direction = 'up', monitor = 'e+1' })
hl.bind(main_mod .. ' + page_down', hl.dsp.workspace.move { direction = 'down', monitor = 'e+1' })


hl.bind(main_mod .. ' + XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+')
hl.bind(main_mod .. ' + XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')
hl.bind(main_mod .. ' + XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')
hl.bind(main_mod .. ' + XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle')
hl.bind(main_mod .. ' + XF86MonBrightnessUp', hl.dsp.exec_cmd 'brightnessctl s 10%+')
hl.bind(main_mod .. ' + XF86MonBrightnessDown', hl.dsp.exec_cmd 'brightnessctl s 10%-')
-- REQUIRE PLAYERCTL
hl.bind('XF86AudioNext', hl.dsp.exec_cmd 'playerctl next', { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd 'playerctl previous', { locked = true })
