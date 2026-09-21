-- local suppressMaximizeRule = hl.window_rule({
--     -- Ignore maximize requests from all apps. You'll probably like this.
--     name  = "suppress-maximize-events",
--     match = { class = ".*" },
--
--     suppress_event = "maximize",
-- })
-- -- suppressMaximizeRule:set_enabled(false)

-- FLOATING RULES -------------------------------------------------------------
hl.window_rule {
    name = 'center-on',
    match = { float = true, xwayland = false },
    center = true,
}

hl.window_rule {
    name = 'float-on-settings',
    match = { title = '^Settings' },
    float = true,
}

hl.window_rule {
    name = 'float-on-blueman-manager',
    match = { class = 'blueman-manager' },
    float = true,
}

hl.window_rule {
    name = 'float-on-com.github.GradienceTeam.Gradience',
    match = { class = 'com.github.GradienceTeam.Gradience' },
    float = true,
}

hl.window_rule {
    name = 'float-on-feh',
    match = { class = 'feh' },
    float = true,
}

hl.window_rule {
    name = 'float-on-imv',
    match = { class = 'imv' },
    float = true,
}

hl.window_rule {
    name = 'float-on-system-config-printer',
    match = { class = 'system-config-printer' },
    float = true,
}

hl.window_rule {
    name = 'float-on-org.quickshell',
    match = { class = 'org.quickshell' },
    float = true,
}

-- FLOATING AND RESIZABLE RULES -----------------------------------------------

hl.window_rule {
    name = 'float-and-resize-on-mtui',
    match = { title = 'mtui' },
    float = true,
    size = '60% 70%',
}

hl.window_rule {
    name = 'float-and-resize-on-foot',
    match = { class = 'foot', title = 'mtui' },
    float = true,
    size = '60% 70%',
}

hl.window_rule {
    name = 'float-and-resize-on-org.gnome.Settings',
    match = { class = 'org.gnome.Settings' },
    float = true,
    size = '70% 80%',
}

hl.window_rule {
    name = 'float-and-resize-on-org.pulseaudio.pavucontrol|yad-icon-browser',
    match = { class = 'org.pulseaudio.pavucontrol|yad-icon-browser' },
    float = true,
    size = '60% 70%',
}

hl.window_rule {
    name = 'float-and-resize-on-nwg-look',
    match = { class = 'nwg-look' },
    float = true,
    size = '50% 60%',
}

hl.window_rule {
    name = 'float-and-resize-on-foot-match:title-nemo',
    match = { class = 'foot', title = 'nemo' },
    float = true,
    size = '65% 65%',
}

hl.window_rule {
    name = 'float-and-resize-on-vlc',
    match = { class = 'vlc' },
    float = true,
    size = '80% 80%',
}

hl.window_rule {
    name = 'float-and-resize-on-mvp',
    match = { class = 'mvp' },
    float = true,
    size = '80% 80%',
}

hl.window_rule {
    name = 'float-and-resize-on-pavucontrol-qt',
    match = { class = 'pavucontrol-qt' },
    float = true,
    size = '40% 40%',
}

hl.window_rule {
    name = 'float-and-resize-on-blueman-manager',
    match = { class = 'blueman-manager' },
    float = true,
    size = '25% 40%',
}

hl.window_rule {
    name = 'float-and-resize-on-blueman-manager-wrapped',
    match = { class = 'blueman-manager-wrapped' },
    float = true,
    size = '25% 40%',
}

hl.window_rule {
    name = 'float-and-resize-on-org.gnome.Nautilus',
    match = { class = 'org.gnome.Nautilus' },
    float = true,
    size = '65% 65%',
}

hl.window_rule {
    name = 'float-and-resize-on-evince',
    match = { class = 'evince' },
    float = true,
    size = '80% 80%',
}

hl.window_rule {
    name = 'float-and-resize-on-xviewer',
    match = { class = 'xviewer' },
    float = true,
    size = '65% 65%',
}

hl.window_rule {
    name = 'float-and-resize-on-nwg-look',
    match = { class = 'nwg-look' },
    float = true,
    size = '65% 65%',
}

hl.window_rule {
    name = 'float-and-resize-on-Save-File',
    match = { title = 'Save File' },
    float = true,
    size = '40% 40%',
    center = true,
}

hl.window_rule {
    name = 'float-and-resize-on-pic-in-picture',
    match = { title = '^[Pp]icture[- ]in[- ][Pp]icture$' },
    float = true,
    move = { '(monitor_w - window_w - 12)', '12' },
    pin = true,
    keep_aspect_ratio = true,
    no_focus = false,
}

hl.window_rule {
    name = 'float-and-resize-on-elige-archivos',
    match = { title = 'Elige archivos' },
    float = true,
}

hl.window_rule {
    name = 'float-and-resize-on-xdg-desktop-portal-gtk',
    match = { class = 'xdg-desktop-portal-gtk' },
    keep_aspect_ratio = true,
    float = true,
}

hl.window_rule {
    name = 'float-and-resize-on-Sign-In-match:title-Screenshot',
    match = { title = 'Screenshot' },
    float = true,
    size = '50% 40%',
}

hl.window_rule {
    name = 'float-and-resize-on-xwaylandvideobridge',
    match = { class = 'xwaylandvideobridge' },
    float = true,
    opacity = 0.0,
    no_anim = true,
}
