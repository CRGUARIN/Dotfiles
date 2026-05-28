-------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

-- Float small size
hl.window_rule({
  name = "floats",
  match = {
    class = "floats",
  },
  float = true,
  size = { 900, 500 },
  center = true,
})

-- Float medium size
hl.window_rule({
  name = "floatm",
  match = {
    class = "floatm",
  },
  float = true,
  size = { 1100, 700 },
  center = true,
})

-- Float medium size - special workspace // for neovide with "Pendientes.md"
hl.window_rule({
  name = "neovidep",
  match = {
    title = "~/Documentos/Notas/Pendientes.md",
  },
  float = true,
  size = { 1000, 700 },
  center = true,
  workspace = "special:magic",
})

-- Float medium size - special workspace // for neovide with "Dudas.md"
hl.window_rule({
  name = "neovided",
  match = {
    title = "~/Documentos/Notas/Dudas.md",
  },
  float = true,
  size = { 1000, 700 },
  center = true,
  workspace = "special:magic",
})

-- Float medium size - special workspace // for neovide with "Observaciones.md"
hl.window_rule({
  name = "neovideo",
  match = {
    title = "~/Documentos/Notas/Observaciones.md",
  },
  float = true,
  size = { 1000, 700 },
  center = true,
  workspace = "special:magic",
})

hl.window_rule({
  name = "pkgtui",
  match = {
    class = "pkgtui",
  },
  float = true,
  size = { 700, 400 },
  center = true,
})

-- Hyprland-run windowrule
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})
