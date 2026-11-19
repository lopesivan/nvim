-- hope.lua
return {
  -- Added this plugin
  -- Jumps
  {
    "lopesivan/hop.nvim",
    cmd = { "HopWord", "HopChar1" },
    config = function()
      require("hop").setup({})
    end,
    keys = {
      {
        "<space>/",
        "<CMD>HopWord<CR>",
        desc = "HopWord",
      },
    },
  },
}
