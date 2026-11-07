-- tpope.lua
return {
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
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
