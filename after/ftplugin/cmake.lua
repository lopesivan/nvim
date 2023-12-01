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

vim.opt.tabstop    = 4     --  Size of a hard tabstop (ts).
vim.opt.shiftwidth = 4  -- Size of an indentation (sw).
vim.opt.expandtab  = true
vim.opt.autoindent = true   -- Copy indent from current line when starting a new line (ai).

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
  ['CMakeLists.txt'] = {
    ['CMakeLists.txt'] = {
	  ['run'] = 'make run',
	  ['clean'] = 'make clean',
      ['make'] = '/usr/local/bin/cmake --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_C_COMPILER:FILEPATH=/usr/local/bin/clang -DCMAKE_CXX_COMPILER:FILEPATH=/usr/local/bin/clang++ -S/workspace/cppPonto2d -B/workspace/cppPonto2d/build -G Ninja',
      ['type'] = 'cmake'
    }
  }
}

vim.keymap.set("n", "<space><CR>", "<Cmd>Make<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<space><CR>", "<Cmd>Make<CR>", {noremap = true, silent = true})
--[[
function! UseTabs()
  set tabstop=4     " Size of a hard tabstop (ts).
  set shiftwidth=4  " Size of an indentation (sw).
  set noexpandtab   " Always uses tabs instead of space characters (noet).
  set autoindent    " Copy indent from current line when starting a new line (ai).
endfunction

function! UseSpaces()
  set tabstop=2     " Size of a hard tabstop (ts).
  set shiftwidth=2  " Size of an indentation (sw).
  set expandtab     " Always uses spaces instead of tab characters (et).
  set softtabstop=0 " Number of spaces a <Tab> counts for. When 0, featuer is off (sts).
  set autoindent    " Copy indent from current line when starting a new line.
  set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).
endfunction
]]
-- vim: fdm=marker:sw=4:sts=4:et
