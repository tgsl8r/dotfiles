return {
  {
    "eddyekofo94/gruvbox-flat.nvim",
    priority = 1000,
    enabled = true,
    config = function()
      vim.g.gruvbox_flat_style = "dark"
      vim.g.gruvbox_italic_keywords = false
      vim.g.gruvbox_sidebars = { "neo-tree", "toggleterm", "telescope", "terminal" }
      vim.cmd([[
        highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
        highlight! link NeoTreeDirectoryName NvimTreeFolderName
        highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
        highlight! link NeoTreeRootName NvimTreeRootFolder
        highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
        highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
      ]])
      vim.cmd([[colorscheme gruvbox-flat]])
    end,
  },
}
