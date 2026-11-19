-- none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
  event = { "BufReadPre", "BufNewFile" },
}
