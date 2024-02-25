local M = {
  "LunarVim/darkplus.nvim",
  lazy = false,
  priority = 1000, -- Load first
}

function M.config()
  vim.cmd.colorscheme "darkplus"
end

return M
