-- vim-easy-align.lua
return {
  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    keys = {
      { "<CR>", "<Plug>(EasyAlign)", mode = "x", desc = "Easy Align" },
    },
  },
}
