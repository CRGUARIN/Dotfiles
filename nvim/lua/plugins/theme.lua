-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- Some beautyful colorschemes
  {
    "fxn/vim-monochrome",
    -- lazy = false,
    -- priority = 1000,
  },

  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    -- lazy = false,
    -- priority = 1000,
    init = function()
      vim.g.moonfly_transparent = true
    end,
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        hide_fillchars = true,
      })
    end,
  },

  -- Active colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
