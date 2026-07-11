local colores = {
  primary           = "rgb({{colors.primary.default.hex_stripped}})",
  secondary         = "rgb({{colors.secondary.default.hex_stripped}})",
  tertiary          = "rgb({{colors.tertiary.default.hex_stripped}})",
  primary_container = "rgb({{colors.primary_container.default.hex_stripped}})",
  inverse_primary   = "rgb({{colors.inverse_primary.default.hex_stripped}})",

  -- Los nuevos para bordes inactivos:
  surface_variant   = "rgb({{colors.surface_variant.default.hex_stripped}})",
  outline_variant   = "rgb({{colors.outline_variant.default.hex_stripped}})",

  background        = "rgb({{colors.background.default.hex_stripped}})",
  surface           = "rgb({{colors.surface.default.hex_stripped}})",
  foreground        = "rgb({{colors.on_background.default.hex_stripped}})",
}

return colores
