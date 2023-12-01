vim.opt.commentstring = "-- %s"

vim.g.haskell_indent_if = 3

vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

vim.g.projectionist_heuristics = {
  ['*.hs'] = {
    ['*.hs'] = {
      -- ['run'] = '!./{}',
      ['run'] = 'lua require(\'config.nvim_dev\').app(\'./{}\')',
      ['make'] = 'ghc -o {} {file|basename}',
      ['type'] = 'haskell'
    }
  }
}

local nmap = require("config.dispatch").nmap
nmap {'<leader><CR>', 'make', 'make'}
-- nmap {'m<CR>', 'make', 'make'}
-- nmap {'d<CR>', 'dispatch', 'make clean'}
nmap {'r<CR>', 'run', 'Run'}
-- nmap {'s<CR>', 'start', 'Maple Interativo'}
