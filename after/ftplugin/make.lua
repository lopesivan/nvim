-- make.lua - make
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.textwidth   = 78

vim.opt.wrap        = false
vim.opt.smartcase   = true
vim.opt.infercase   = true

vim.opt.tabstop    = 4    -- Size of a hard tabstop (ts).
vim.opt.shiftwidth = 4    -- Size of an indentation (sw).
vim.opt.expandtab  = false
vim.opt.autoindent = true -- Copy indent from current line when starting a new line (ai).

vim.g.easy_align_delimiters = {
  -- aperto f
  ['#'] = {
      ['pattern'] = '#',
	  ['ignore_groups'] = {'string'},
  },

  -- aperto \
  ['\\'] = {
      ['pattern'] = '\\\\',
      ['left_margin'] = 1,
      ['right_margin'] = 1,
      ['indentation'] = 'deep',
      ['stick_to_left'] = 0,
	  ['ignore_groups'] = {'string'},
  },
  -- aperto ]
  ['|'] = {
      ['pattern'] = '|',
      ['left_margin'] = 1,
      ['right_margin'] = 1,
      ['indentation'] = 'deep',
      ['stick_to_left'] = 0,
	  ['ignore_groups'] = {'string'},
  },
}

vim.g.projectionist_heuristics = {
  ['Makefile'] = {
    ['Makefile'] = {
      ['yabs_make']   = 'make',
	  ['yabs_run']   = 'run',
	  ['yabs_clean'] = 'clean',
      ['yabs_test']  = 'test',
	  ['telescope']= 'Telescope yabs tasks',
      ['type'] = 'make'
    }
  }
}

local nmap = require("config.dispatch").nmap
--nmap {'<leader><CR>', 'telescope', 'build maneger'}
nmap { 'm<CR>', 'yabs_make', 'make'}
nmap { 'r<CR>', 'yabs_run', 'make run'}
nmap { 'c<CR>', 'yabs_clean', 'make clean'}
nmap { 't<CR>', 'yabs_test', 'make test'}

-- vim: fdm=marker:sw=4:sts=4:et
