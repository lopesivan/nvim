vim.opt.shiftwidth = 4
vim.opt.commentstring = "// %s"

-- vim.opt.foldmethod="expr"
-- vim.opt.foldexpr="GetCppFoldExpr()"
-- vim.opt.foldcolumn="1"
-- vim.opt.foldlevel=999
-- vim.opt.foldminlines=1
-- vim.opt.foldtext="CppFoldText()"

vim.g.easy_align_delimiters = {
  -- aperto d
  ["d"] = {
    ["pattern"] = "\\(const\\|constexpr\\|static\\)\\@<! ",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
  },

  -- aperto c
  ["c"] = {
    ["pattern"] = "\\/\\/",
    ["ignore_groups"] = { "String" },
    ["ignore_unmatched"] = 0,
  },

  -- aperto <
  ["<"] = {
    ["pattern"] = "<<",
    ["ignore_groups"] = { "String" },
    ["ignore_unmatched"] = 0,
  },

  -- aperto f
  ["f"] = {
    ["pattern"] = " \\ze\\S\\+\\s*[;=]",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
  },

  -- aperto ]
  ["]"] = {
    ["pattern"] = "[[\\]]",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto )
  [")"] = {
    ["pattern"] = "[()]",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto (
  ["("] = {
    ["pattern"] = "(",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto w
  ["w"] = {
    ["pattern"] = "\\w",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto _
  ["_"] = {
    ["pattern"] = "_\\w",
    ["left_margin"] = 1,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },
  -- aperto ,
  [","] = {
    ["pattern"] = "\\w\\+,",
    ["delimiter_align"] = "l",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto ;
  [";"] = {
    ["pattern"] = "\\w\\+;",
    ["delimiter_align"] = "l",
    ["left_margin"] = 1,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },
}

vim.g.VimuxPromptString = "cansi"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+GDB"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ["*.cpp"] = {
    ["*.cpp"] = {
      ["run"] = "lua require('config.nvim_dev').app('./{}')",
      ["CC"] = "g++ -g -std=c++17 -Wall -Werror -Wpedantic -Wno-parentheses  -c -o {}.o {file|basename}",
      ["LD"] = "g++ -lm {}.o -o {}",
      ["telescope"] = "Telescope yabs tasks",
      ["type"] = "cpp",
    },
  },
}

local nmap = require("config.dispatch").nmap
--nmap { "<leader><CR>", "telescope", "build maneger" }
nmap { "m<CR>", "make", "make" }
nmap { "d<CR>", "dispatch", "make clean" }
nmap { "r<CR>", "run", "Run" }
-- nmap {'s<CR>', 'start', 'Maple Interativo'}

-- require("overseer").setup {
--   templates = { "builtin", "cpp" },
-- }

-- vim.opt.equalprg={"astyle --pad-first-paren-out --style=linux -A1 --indent=spaces=4 --convert-tabs"}

require("overseer").setup {
  strategy = {
    "toggleterm",
    -- load your default shell before starting the task
    use_shell = true,
    -- overwrite the default toggleterm "direction" parameter
    direction = "horizontal",
    close_on_exit = false,
    -- open the toggleterm window when a task starts
    open_on_start = true,
    -- mirrors the toggleterm "hidden" parameter, and keeps the task from
    -- being rendered in the toggleable window
    hidden = false,
  },
  dap = true,
  auto_scroll = true,
  close_on_exit = false,
  open_on_start = true,
  templates = { "builtin", vim.bo.filetype },
}
-- clang
-- vim.opt.makeprg="clang++-12 -Wall -Werror -Wpedantic -fstandalone-debug -std=c++17 -D_GLIBCXX_DEBUG -g -o build/%< %"

-- CMake
-- vim.opt.makeprg = "cd build/debug && make -j 16"
-- note 16 is hardware concurrency for build
-- make does an "out of tree build," thats why we cd into a diff directory
-- this assumes you've run cmake ../.. inside build/debug ahead of time to generate the makefile

-- gcc
-- vim.opt.makeprg="g++ -Wall -Werror -Wpedantic -std=c++17 -g -o build/%< %"

-- vim: set ft=lua nowrap:
