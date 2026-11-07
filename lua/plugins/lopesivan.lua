-- lopesivan.lua
return {
  "lopesivan/template.vim",
  { "lopesivan/hp50g.vim", ft = "hp50g" },
  "lopesivan/uppercase.nvim",
  -- "lopesivan/contextmenu.nvim",
  {
    "lopesivan/yabs.nvim",
    event = "VeryLazy",
    config = function()
      local ok, mod = pcall(require, "my.yabs")
      if ok then
        mod.setup()
      else
        vim.notify("config.yabs not found", vim.log.levels.WARN)
      end
    end,
  },

  {
    "lopesivan/neotemplate.nvim",
    event = "BufEnter",
    build = function()
      vim.cmd([[UpdateRemotePlugins]])
    end,
  },

  {
    "lopesivan/nvim-cheetah",
    event = "BufEnter",
    build = function()
      vim.cmd.UpdateRemotePlugins()
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

  {"lopesivan/colorbuddy.nvim"},
}
