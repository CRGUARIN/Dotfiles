-----------------------------
---- VARIABLES AND ALIAS ----
-----------------------------

---- Applications ----

local mainMod       = "SUPER"
local terminal      = "kitty --class floatm"
local fileManager   = "kitty --class floats -e yazi"
local menu          = "fuzzel"

---- Scripts ----

-- Reminder --
local reminder      = "~/Documentos/Dotfiles/Scripts/hypr-reminder.sh"
local reminderList  = "~/Documentos/Dotfiles/Scripts/hypr-reminder.sh show"
local reminderClear = "~/Documentos/Dotfiles/Scripts/hypr-reminder.sh clear"


----------------------
---- KEYBINDINGS -----
---------------------

---- SYSTEM AND SESION ----

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CONTROL + C",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- hl.bind(mainMod .. " + CONTROL + P", hl.dsp.exec_cmd("kitty -e shutdown now"))
-- hl.bind(mainMod .. " + CONTROL + R", hl.dsp.exec_cmd("kitty -e reboot"))

---- WINDOWS MANAGMENT ----

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move/resize windows using mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---- Focus and navigation ----

-- Focus with arrows --
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move windows with mainMod + SHIFT + arrows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

---- General applications  ----

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT  + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT  + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT  + M", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + SHIFT  + N", hl.dsp.exec_cmd("neovide"))

---- Floating applications (TUI / Utilities) ----

hl.bind(mainMod .. " + CONTROL + B", hl.dsp.exec_cmd("kitty --class floats -e bluetui"))
hl.bind(mainMod .. " + CONTROL + W", hl.dsp.exec_cmd("kitty --class floats -e nmtui"))
hl.bind(mainMod .. " + CONTROL + A", hl.dsp.exec_cmd("kitty --class floats -e wiremix"))
hl.bind(mainMod .. " + CONTROL + T", hl.dsp.exec_cmd("kitty --class floatm -e btop"))
hl.bind(mainMod .. " + CONTROL + SHIFT   + P", hl.dsp.exec_cmd("neovide ~/Documentos/Notas/Pendientes.md"))
hl.bind(mainMod .. " + CONTROL + SHIFT   + D", hl.dsp.exec_cmd("neovide ~/Documentos/Notas/Dudas.md"))
hl.bind(mainMod .. " + CONTROL + SHIFT   + O", hl.dsp.exec_cmd("neovide ~/Documentos/Notas/Observaciones.md"))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("kitty --class floats -e qalc"))
hl.bind(mainMod .. " + CONTROL + P", hl.dsp.exec_cmd("kitty --class pkgtui fish -c 'pkgtui'"))

---- Utilities (Screenshots, Wallpaper, UI) ----

hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("~/Documentos/Dotfiles/Scripts/change-wallpaper.sh"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(reminder))
hl.bind(mainMod .. " + ALT + CONTROL + R", hl.dsp.exec_cmd(reminderList))
hl.bind(mainMod .. " + ALT + SHIFT + R", hl.dsp.exec_cmd(reminderClear))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("swaync-client -C")) -- Clear all swaync notifications

---- Workspaces ----

-- Scroll between workspaces --
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad --
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Switch workspaces and move windows --
for i = 1, 10 do
  local key = i % 10 -- El 10 mapea a la tecla 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

---- Hardware (Volume, brightness and multimedia) ----

-- Volume y Microphone --
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })

-- Brightness --
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Multimedia --
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
