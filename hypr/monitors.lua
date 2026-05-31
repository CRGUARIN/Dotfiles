------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
	mirror = "eDP-1",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")

---- Nvidia ----

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

---- Cursor ----

hl.env("XCURSOR_THEME,Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE,24")
hl.env("XCURSOR_PATH,/run/current-system/sw/share/icons:/etc/profiles/per-user/crguarin/share/icons")
