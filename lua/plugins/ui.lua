-- ui.lua
return {
  {
    "folke/tokyonight.nvim",
    dependencies = {
      "lopesivan/colorbuddy.nvim",
      "tjdevries/gruvbuddy.nvim",
    },
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  { "catppuccin/nvim", lazy = false, name = "catppuccin" },
}
