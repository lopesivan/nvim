return {
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-dadbod", lazy = false },
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>gs", "<CMD>Git<CR>", desc = "Status" },
      -- { "<m-a>", "<CMD>Git add %:p<CR>", desc = "Git add" },
      { "<m-r>", "<CMD>Gread<CR>", desc = "Git read" },
      { "<m-w>", "<CMD>Gwrite<CR>", desc = "Git write" },
      -- { "ß", "<CMD>Git<CR>", desc = "Status" },
      -- { "©", "<CMD>Git commit %:p<CR>", desc = "Git commit" },
    },
  },

  -- { "tpope/vim-projectionist", event = "BufEnter" },
  {
    "tpope/vim-dispatch",
    lazy = false,
    dependencies = {
      "tpope/vim-repeat",
      "tpope/vim-surround",
      "tpope/vim-unimpaired",
      {
        "tpope/vim-scriptease",
        cmd = {
          "Messages", --view messages in quickfix list
          "Verbose", -- view verbose output in preview window.
          "Time", -- measure how long it takes to run some stuff.
        },
      },
    },
  },

  {
    "tpope/vim-projectionist",
    lazy = false,
  },
}
