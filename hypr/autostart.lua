-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("waypaper --restore")
  hl.exec_cmd("qs -c overview")
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync")
  hl.exec_cmd("udiskie --tray")
  hl.exec_cmd("hyprpm reload -n")
end)
