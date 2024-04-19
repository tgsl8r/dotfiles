return {
  -- add nvim-colorizer
  { "norcalli/nvim-colorizer.lua" },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
