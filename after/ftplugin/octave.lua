vim.opt.commentstring = "% %s"

vim.g.easy_align_delimiters = {
  -- aperto d
  ["d"] = {
    ["pattern"] = "\\(const\\|constexpr\\|static\\)\\@<! ",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
  },

  -- aperto c
  ["%"] = {
    ["pattern"] = "%",
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

vim.g.VimuxPromptString = "octave"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+Octave"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.oc"] = {
    ["*.oc"] = {
      ["start"] = "octave --persist {file|basename}",
      ["dispatch"] = "octave {file} >{}.out",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux octave --persist {file}",
      -- ["run"] = 'lua require("config.nvim_dev").app("octave",{file})',
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('octave',{'--persist','{file}'})",
      ["some_variable"] = "foo",
      ["type"] = "octave",
    },
  },
}
-- projectionist#query_scalar('some_variable')
-- nmenu Quarto.QuartoPreview  :exe " ".projectionist#query('QuartoPreview')[0][1]
-- echo projectionist#query_scalar('quit')[0]
-- function! projectionist#query_raw(key, ...) abort
-- function! projectionist#query_file(key, ...) abort
-- function! projectionist#query_exec(key, ...) abort
-- function! projectionist#query_scalar(key) abort
--
--
local nmap = require("config.dispatch").nmap
nmap { "s<CR>", "start", "Octave Interativo" }
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
-- nmap {'r<CR>', 'yabs', 'Run'}
-- nmap {'m<CR>', 'make', 'Make'}
nmap { "d<CR>", "dispatch", "Dispatch" }
