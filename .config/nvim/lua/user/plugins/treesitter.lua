local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

local localPath = ...

function M.config()
  require("nvim-treesitter.configs").setup { 
    ensure_installed = require(localPath .. "-langs"),
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
