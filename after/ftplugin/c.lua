vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 78
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.infercase = true

vim.bo.equalprg = "astyle --pad-first-paren-out --style=linux -A1 --indent=spaces=4 --convert-tabs"
vim.opt.path = { ".", "/usr/include/", "/usr/local/bin/" }
vim.opt.wrap = false
vim.opt.smartcase = true

-- vim.b['surround_'..vim.fn.char2nr('1')]='<CMD>\r<CR>'
-- vim.b['surround_'..vim.fn.char2nr('2')]='<CMD>lua \r<CR>'
-- vim.b['surround_'..vim.fn.char2nr('3')]='print(vim.inspect(\r))'
-- vim.b['surround_'..vim.fn.char2nr('q')]='"\r"'
-- vim.b['surround_'..vim.fn.char2nr('d')]='printf("DEBUG: %s = %\1formatação:\1","\r",kkk);'
-- vim.b["surround_" .. vim.fn.char2nr("c")] = "\\\1command: \1{\r}"
-- vim.b["surround_" .. vim.fn.char2nr("e")] =
--   "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"

vim.g.VimuxPromptString = "cansi"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+GDB"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.c"] = {
    ["*.c"] = {
      ["run"] = "lua require('config.nvim_dev').app('./{}')",
      -- echo projectionist#query('CC')[0][1]
      ["CC"] = "cc -g -std=gnu99 -Wall -Wno-parentheses -c -o {}.o {file|basename}",
      -- echo projectionist#query('LD')[0][1]
      ["LD"] = "cc -lm {}.o -o {}",
      ["telescope"] = "Telescope yabs tasks",
      ["type"] = "c",
    },
  },
}

--
local nmap = require("config.dispatch").nmap
--nmap { "<leader><CR>", "telescope", "build maneger" }
nmap { "m<CR>", "make", "make" }
nmap { "d<CR>", "dispatch", "make clean" }
nmap { "r<CR>", "run", "Run" }
-- nmap {'s<CR>', 'start', 'Maple Interativo'}

-- local opts = { buffer = bufnr, noremap = true, silent = true }
-- vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<CR>", opts)

-- require("clangd_extensions.inlay_hints").setup_autocmd()
-- require("clangd_extensions.inlay_hints").set_inlay_hints()
vim.g.easy_align_delimiters = {
  -- aperto f
  ["f"] = {
    ["pattern"] = " \\ze\\S\\+\\s*[;=]",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
  },

  -- aperto ]
  ["]"] = {
    ["pattern"] = "]",
    ["left_margin"] = 0,
    ["right_margin"] = 0,
    ["stick_to_left"] = 0,
  },

  -- aperto )
  [")"] = {
    ["pattern"] = ")",
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
-- call edit_alternate#rule#add('c', {filename -> fnamemodify(filename, ':r') . '.h'})
-- vim.fn["edit_alternate#rule#add"]("c", function(filename)
--     if filename:find ".c" then
--         return (filename:gsub("%.c", ".h"))
--     else
--         return (filename:gsub("%.h", ".c"))
--     end
-- end)
-- print("This is getting sourced automatically")

-- vim: set ft=lua nowrap:
