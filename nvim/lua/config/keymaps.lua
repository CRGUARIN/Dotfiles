-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Alternar lista de tareas interactiva en Markdown con Ctrl + Espacio
vim.keymap.set("n", "<C-Space>", function()
  if vim.bo.filetype == "markdown" then
    local line = vim.api.nvim_get_current_line()
    if line:match("%-%s*%[%s*%]") then
      -- Si está vacía, la marca como hecha
      vim.cmd([[s/-\s*\[\s*\]/-\ [x]/]])
      vim.cmd("noh")
    elseif line:match("%-%s*%[%x*%]") then
      -- Si está hecha, la desmarca
      vim.cmd([[s/-\s*\[x\]/-\ [\ ]/]])
      vim.cmd("noh")
    end
  end
end, { desc = "Alternar Tarea Markdown" })
