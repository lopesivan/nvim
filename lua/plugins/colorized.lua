return {
  "NvChad/nvim-colorizer.lua",
  enabled = true,
  config = function()
    vim.opt.termguicolors = true
    require("colorizer").setup()
  end,
}
