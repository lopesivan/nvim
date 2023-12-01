-- Status line

return {
  "lopesivan/template.vim",
  { "lopesivan/hp50g.vim", ft = "hp50g" },
  "lopesivan/uppercase.nvim",
  "lopesivan/contextmenu.nvim",

  -- { "lopesivan/nvim-jptemplate", event = "BufEnter" },

  {
    "lopesivan/neotemplate.nvim",
    event = "BufEnter",
    build = function()
      vim.cmd [[UpdateRemotePlugins]]
    end,
  },

  {
    "lopesivan/nvim-cheetah",
    event = "BufEnter",
    build = function()
      vim.cmd [[UpdateRemotePlugins]]
    end,
  },

  {
    "lopesivan/typecast.vim",
    branch = "main",
    event = "BufEnter",
    -- keys = {
    --     { "T", [[<CMD>call <Plug>typecast<CR>]], mode = "x" },
    -- },
  },
}
