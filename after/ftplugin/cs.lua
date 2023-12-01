vim.opt.shiftwidth = 4
vim.opt.commentstring = "// %s"

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

vim.g.VimuxPromptString = "mono"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "MONO"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ["*.cs"] = {
    ["*.cs"] = {
      ["yabs_remove"] = "remove",
      ["run"] = "lua require('config.nvim_dev').app('dotnet', {open}'run'{close})",
      ["build"] = "lua require('config.nvim_dev').app('dotnet', {open}'build'{close})",
      -- ['run'] = 'lua require(\'config.nvim_dev\').app(\'{project}/{}.exe\')',
      ["make"] = "mcs {file|basename}",
      -- ['dispatch'] = 'make clean',
      -- ["telescope"] = "Telescope yabs tasks",
      ["type"] = "cs",
    },
  },
}

local nmap = require("config.dispatch").nmap
--nmap { '<leader><CR>', 'telescope', 'build maneger' }
nmap { "m<CR>", "make", "make" }
nmap { "b<CR>", "build", "Build" }
nmap { "r<CR>", "run", "Run" }
nmap { "d<CR>", "yabs_remove", "Remove" }
-- nmap { 'd<CR>', 'dispatch', 'make clean' }
-- nmap {'s<CR>', 'start', 'Maple Interativo'}

-- vim.opt.equalprg={"astyle --pad-first-paren-out --style=linux -A1 --indent=spaces=4 --convert-tabs"}

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
