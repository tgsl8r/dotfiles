return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      shell = "zsh --login",
    })
  end,
  keys = {
    { [[<C-\>]] },
    {
      "<leader>th",
      "<cmd>ToggleTerm direction=horizontal<cr>",
      desc = "Open a horizontal terminal",
    },
    {
      "<leader>tv",
      "<cmd>ToggleTerm size=40 direction=vertical<cr>",
      desc = "Open a vertical terminal",
    },
  },
}
