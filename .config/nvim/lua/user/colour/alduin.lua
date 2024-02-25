local M = {
    "AlessandroYorba/Alduin",
    name = "alduin",
    lazy = false,
    priority = 1000 -- load first
}

function M.config()
    vim.cmd.colorscheme "alduin"
end

return M
