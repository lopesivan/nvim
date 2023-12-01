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

  -- aperto <
  ['<'] = {
      ['pattern'] = '<<',
      ['ignore_groups'] = {'String'},
      ['ignore_unmatched'] = 0
  },

  -- aperto f
  ['f'] = {
      ['pattern'] = ' \\ze\\S\\+\\s*[;=]',
      ['left_margin'] = 0,
      ['right_margin'] = 0
  },

  -- aperto ]
  [']'] = {
      ['pattern'] = '[[\\]]',
      ['left_margin'] = 0,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },

  -- aperto )
  [')'] = {
      ['pattern'] = '[()]',
      ['left_margin'] = 0,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },

  -- aperto (
  ['('] = {
      ['pattern'] = '(',
      ['left_margin'] = 0,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },

  -- aperto w
  ['w'] = {
      ['pattern'] = '\\w',
      ['left_margin'] = 0,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },

  -- aperto _
  ['_'] = {
      ['pattern'] = '_\\w',
      ['left_margin'] = 1,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },
  -- aperto ,
  [','] = {
      ['pattern'] = '\\w\\+,',
      ['delimiter_align'] = 'l',
      ['left_margin'] = 0,
      ['right_margin'] = 0,
      ['stick_to_left'] = 0
  },


}

vim.g.projectionist_heuristics = {
  ['*.cs'] = {
    ['*.cs'] = {
      ['run'] = 'java -jar {}.jar',
      ['clean'] = 'rm {}.jar',
      ['start'] = 'kotlinc-jvm',
      ['make'] = 'dotnet build /workspace/kiko/ProjetoNovo/ProjetoNovo.csproj /property:GenerateFullPaths=true /consoleloggerparameters:NoSummary',
      -- ['dispatch'] = 'echo "{file}"',
      ['type'] = 'cs'
    },
  }
}

-- csc
-- mono

vim.keymap.set("n", "<space><CR>", "<Cmd>Make<CR>", {noremap = true, silent = true})
-- vim: fdm=marker:sw=4:sts=4:et
