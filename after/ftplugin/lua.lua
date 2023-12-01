vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 78
vim.bo.expandtab = true
vim.bo.autoindent = true

vim.opt.formatoptions = vim.opt.formatoptions - "o" -- O and o, don't continue comments

-- Uso: vmap <leader>1 S1
vim.b["surround_" .. vim.fn.char2nr "1"] = "<CMD>\r<CR>"
vim.b["surround_" .. vim.fn.char2nr "2"] = "<CMD>lua \r<CR>"
vim.b["surround_" .. vim.fn.char2nr "3"] = "print(vim.inspect(\r))"
vim.b["surround_" .. vim.fn.char2nr "q"] = '"\r"'

vim.g.projectionist_heuristics = {
  ["*.lua"] = {
    ["*.lua"] = {
      ["start"] = "luap -i {file}",
      ["make"] = "lua {file}",
      ["dispatch"] = "lua {file}",
      ["load"] = "luafile {file}",
      ["type"] = "lua",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "load", ":luafile" }
nmap { "s<CR>", "start", "Lua Interativo" }
nmap { "m<CR>", "make", "Make" }
nmap { "d<CR>", "dispatch", "Dispatch" }

vim.g.easy_align_delimiters = {
  -- aperto -
  ["c"] = {
    ["pattern"] = "--",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
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
--[[  ================= Exemplo de criação de comando =================
vim.api.nvim_create_user_command(
    'Upper',
    function(opts)
        print(string.upper(opts.args))
    end,
    { nargs = 1 }
)

vim.api.nvim_create_user_command('Upper', function() end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
        -- return completion candidates as a list-like table
        return { 'foo', 'bar', 'baz' }
    end,
})
]]

-- let b:surround_{char2nr("1")} = "<CMD>\r<CR>"
-- vmap <leader>1 S1
--
-- let b:surround_{char2nr("2")} = "<CMD>lua \r<CR>"
-- vmap <leader>2 S2
--
-- let b:surround_{char2nr('q')} = "\"\r\""
-- vmap <leader>q Sq
