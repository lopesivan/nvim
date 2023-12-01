-- generic.lua - generic
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

 -- ----------------------------------------------------------------------------
 -- <F5>
 -- set makeprg=haml\ -f\ html5\ %\ >\ %<.html
 -- <F9>
 -- let b:start = 'haml -f html5 '.expand('%').' '.expand('%:r').'.html'
 -- <F10>
 -- let b:dispatch = 'faml render '.expand('%')

--[[
" ----------------------------------------------------------------------------
" <F5>
" set makeprg=haml\ -f\ html5\ %\ >\ %<.html
" <F9>
" let b:start = 'haml -f html5 '.expand('%').' '.expand('%:r').'.html'
" <F10>
" let b:dispatch = 'faml render '.expand('%')
" ----------------------------------------------------------------------------
]]

--local start_cmd = vim.fn["projectionist#query_exec"]("start")
-- echo projectionist#query('start')[0][1]
-- echo projectionist#query('stop')[0][1]
-- echo projectionist#query('toggle')[0][1]

-- vim.cmd([[
-- nmenu Markdown.Start  :exe " ".projectionist#query('start')[0][1]
-- nmenu Markdown.Stop   :exe " ".projectionist#query('stop')[0][1]
-- nmenu Markdown.Toggle :exe " ".projectionist#query('toggle')[0][1]
-- nmenu Markdown.toHTML :lua require'libuv.markdown'.convertFile()
-- nmenu Markdown.Slide  :lua require'telegraph'.telegraph({cmd='lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})
-- ]])

-- vim.api.nvim_set_keymap("n", "<space>0", "<Cmd>call projectionist#activate()<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>call Menu2Quick('Markdown', 'n')<CR>", {noremap = true, silent = true})

vim.g.projectionist_heuristics = {
  ['*.generic'] = {
    ['*.generic'] = {
      ['start'] = 'echo "start: {file}" >>{}.out',
      ['make'] = 'echo "make: {file}" >>{}.out',
      ['dispatch'] = 'echo "dispatch: {file}" >>{}.out',
      ['type'] = 'generic'
    }
  }
}

vim.keymap.set(
    "n",
    "<leader><CR>",
    "<CMD>lua require('yabs'):run_default_task()<CR>",
    {noremap = true, silent = true})

-- vim: fdm=marker:sw=4:sts=4:et
