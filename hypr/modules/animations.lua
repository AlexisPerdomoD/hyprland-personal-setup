-- global
--   ↳ windows - styles: slide, popin, gnomed
--     ↳ windowsIn - window open - styles: same as windows
--     ↳ windowsOut - window close - styles: same as windows
--     ↳ windowsMove - everything in between, moving, dragging, resizing.
--   ↳ layers - styles: slide, popin, fade
--     ↳ layersIn - layer open
--     ↳ layersOut - layer close
--   ↳ fade
--     ↳ fadeIn - fade in for window open
--     ↳ fadeOut - fade out for window close
--     ↳ fadeSwitch - fade on changing activewindow and its opacity
--     ↳ fadeShadow - fade on changing activewindow for shadows
--     ↳ fadeGlow - fade on changing activewindow for glow
--     ↳ fadeDim - the easing of the dimming of inactive windows
--     ↳ fadeLayers - for controlling fade on layers
--       ↳ fadeLayersIn - fade in for layer open
--       ↳ fadeLayersOut - fade out for layer close
--     ↳ fadePopups - for controlling fade on Wayland popups
--       ↳ fadePopupsIn - fade in for Wayland popup open
--       ↳ fadePopupsOut - fade out for Wayland popup close
--     ↳ fadeDpms - for controlling fade when dpms is toggled
--   ↳ border - for animating the border's color switch speed
--   ↳ borderangle - for animating the border's gradient angle - styles: once (default), loop
--   ↳ shadowangle - for animating the shadow's gradient angle - styles: once (default), loop
--   ↳ glowangle - for animating the glow's gradient angle - styles: once (default), loop
--   ↳ workspaces - styles: slide, slidevert, fade, slidefade, slidefadevert
--     ↳ workspacesIn - styles: same as workspaces
--     ↳ workspacesOut - styles: same as workspaces
--     ↳ specialWorkspace - styles: same as workspaces
--       ↳ specialWorkspaceIn - styles: same as workspaces
--       ↳ specialWorkspaceOut - styles: same as workspaces
--   ↳ zoomFactor - animates the screen zoom
--   ↳ monitorAdded - monitor added zoom animation

hl.curve('smoothIn', { type = 'bezier', points = { { 0.25, 0.1 }, { 0.25, 1 } } })
hl.curve('smoothOut', { type = 'bezier', points = { { 0.34, 0 }, { 0.25, 1 } } })
hl.curve('quickSnap', { type = 'bezier', points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.curve('workspace', { type = 'bezier', points = { { 0.25, 0.46 }, { 0.45, 0.94 } } })
hl.curve('appleIn', { type = 'bezier', points = { { 0.2, 0.8 }, { 0.2, 1 } } })
hl.curve('appleOut', { type = 'bezier', points = { { 0.4, 0 }, { 0.6, 1 } } })
hl.curve('appleMove', { type = 'bezier', points = { { 0.25, 0.9 }, { 0.25, 1 } } })
hl.curve('borderFlow', { type = 'bezier', points = { { 0.45, 0 }, { 0.55, 1 } } })
hl.curve('resizeSmooth', { type = 'bezier', points = { { 0.16, 1 }, { 0.3, 1 } } })

hl.animation { leaf = 'windowsIn', enabled = true, speed = 2, bezier = 'appleIn' }
hl.animation { leaf = 'windowsOut', enabled = true, speed = 2, bezier = 'appleOut' }
hl.animation { leaf = 'windowsMove', enabled = true, speed = 2, bezier = 'quickSnap', style = 'slide' }
hl.animation { leaf = 'layersIn', enabled = true, speed = 2.5, bezier = 'smoothIn', style = 'slide' }
hl.animation { leaf = 'layersOut', enabled = true, speed = 2, bezier = 'smoothOut', style = 'slide' }
hl.animation { leaf = 'fadeLayers', enabled = true, speed = 2.5, bezier = 'smoothIn' }
hl.animation { leaf = 'border', enabled = true, speed = 2, bezier = 'borderFlow' }
hl.animation { leaf = 'fade', enabled = true, speed = 2.5, bezier = 'smoothIn' }
hl.animation { leaf = 'fadeDim', enabled = true, speed = 3, bezier = 'smoothIn' }
hl.animation {
    leaf = 'workspaces',
    enabled = true,
    speed = 2,
    bezier = 'workspace',
    direction = 'slidefade',
    factor = 0.25,
}
hl.animation { leaf = 'specialWorkspace', enabled = true, speed = 2, bezier = 'workspace', style = 'slidevert' }
hl.animation { leaf = 'borderangle', enabled = true, speed = 100, bezier = 'borderFlow', loop = true }
