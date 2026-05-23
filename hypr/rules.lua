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
  size = { 800, 600 },
  center = true,
})

-- Float medium size
hl.window_rule({
  name = "floatm",
  match = {
    class = "floatm",
  },
  float = true,
  size = { 1000, 700 },
  center = true,
})

-- Float medium size - special workspace
hl.window_rule({
  name = "floatms",
  match = {
    class = "floatms",
  },
  float = true,
  size = { 1000, 700 },
  center = true,
  workspace = "special:magic",
})

--
-- Hyprland-run windowrule
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})
