-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- 1. Instalamos el tema monocromático clásico
  {
    "fxn/vim-monochrome",
    lazy = false,
    priority = 1000,
  },

  -- 2. Le decimos a LazyVim que lo active por defecto
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monochrome",
    },
  },
}
