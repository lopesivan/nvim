-- lua.lua

--# configure vim.opt_local
local set = vim.opt_local
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.textwidth = 78
set.expandtab = true
set.autoindent = true

-- O and o, don't continue comments:
vim.opt.formatoptions = vim.opt.formatoptions - "o"

--# Surround

-- word
-- ^^^^
-- v select + S + 1
vim.b["surround_" .. vim.fn.char2nr("1")] = "<CMD>\r<CR>"

-- word
-- ^^^^
-- v select + S + 2
vim.b["surround_" .. vim.fn.char2nr("2")] = "<CMD>lua \r<CR>"

-- word
-- ^^^^
-- v select + S + 3
vim.b["surround_" .. vim.fn.char2nr("3")] = "print(vim.inspect(\r))"

-- word
-- ^^^^
-- v select + S + p
vim.b["surround_" .. vim.fn.char2nr("p")] = 'print("\r")'
-- vim.b["surround_" .. vim.fn.char2nr "q"] = '"\r"'

--# fold
if false then
  vim.opt_local.foldcolumn = "1"
  vim.opt_local.foldenable = true
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
  vim.opt_local.foldtext = require("my.foldtext")
end

--# Setup projectionist

-- Get luaenv version and trim whitespace
local version = vim.fn.trim(vim.fn.system("luaenv version-name"))

-- Check if the version contains 'luajit' and set variable
if version:find("luajit") then
  vim.b.myluabin = "luajit"
else
  vim.b.myluabin = "lua"
end

vim.g.projectionist_heuristics = {
  ["*.lua"] = {
    ["*.lua"] = {
      ["start"] = "luap -i {file}",
      ["make"] = string.format("%s {file}", vim.b.myluabin),
      ["run"] = string.format(
        "lua require('my.neovim_dev').app('%s',{'{file}'})",
        vim.b.myluabin
      ),
      -- ["run"] = "lua require('config.neovim_dev').app('lua',{'{file}'})",
      ["load"] = "luafile {file}",
      ["type"] = "lua",
    },
  },
}

local bufnr = vim.api.nvim_get_current_buf()
local dispatch_nmap = require("my.dispatch").nmap

dispatch_nmap(
  { "<leader><CR>", "run", "nvim_dev Run", "lua file" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<leader><leader><CR>", "load", ":luafile", ":luafile" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "s<CR>", "start", "Lua Interativo", "Lua Interativo" },
  { buffer = bufnr }
)

--# :'<,'>CommentBlock
local function get_line_range_of_visual_block()
  local _, first_line, _, _ = unpack(vim.fn.getpos("'<"))
  local _, last_line, _, _ = unpack(vim.fn.getpos("'>"))
  return { first_line - 1, last_line + 1 }
end

local function comment_block(opts)
  local range = get_line_range_of_visual_block()

  vim.api.nvim_buf_set_text(
    0,
    range[1],
    0,
    range[1],
    0,
    { string.format("%s-[[ %s", "-", opts.args), "" }
  )

  if range[2] >= vim.api.nvim_buf_line_count(0) then
    vim.api.nvim_buf_set_lines(0, range[2], range[2], true, { "" })
  end

  vim.api.nvim_buf_set_text(0, range[2], 0, range[2], 0, { "]]", "" })
end

vim.api.nvim_create_user_command(
  "CommentBlock",
  comment_block,
  { nargs = "?", range = true }
)

_G.my_comment_block = comment_block
vim.api.nvim_set_keymap(
  "n",
  "<leader>cb",
  "<CMD>call v:lua.my_comment_block()<CR>",
  { noremap = true }
)

--# Easy Align Delimiters                      c, f, ], ), (, "," VIRGULA, ";"
vim.g.easy_align_delimiters =
  vim.tbl_extend("force", vim.g.easy_align_delimiters or {}, {
    -- Alinha atribuições (=)
    ["="] = {
      pattern = [[[^][!<>]\zs=]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha dicionários/tabelas (:)
    [":"] = {
      pattern = ":",
      ignore_groups = { "String", "Comment" },
      left_margin = 0,
      right_margin = 1,
      delimiter_align = "l",
    },
    -- Alinha vírgulas em tabelas/listas
    [","] = {
      pattern = ",",
      ignore_groups = { "String", "Comment" },
      left_margin = 0,
      right_margin = 1,
      delimiter_align = "l",
      stick_to_left = 0,
    },
    -- Alinha comentários (--)
    ["-"] = {
      pattern = "--",
      ignore_groups = { "String" },
      left_margin = 2,
      right_margin = 0,
      delimiter_align = "l",
    },
    -- Alinha operadores de concatenação (..)
    ["."] = {
      pattern = [[\.\.]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha operadores aritméticos (+ - * /)
    ["+"] = {
      pattern = "+",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["*"] = {
      pattern = [[\*]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["/"] = {
      pattern = "/",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha operador de potência (^)
    ["^"] = {
      pattern = [[\^]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha operadores relacionais (==, ~=, <, >, <=, >=)
    ["e"] = {
      pattern = "==",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["~"] = {
      pattern = "~=",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["<"] = {
      pattern = "<",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    [">"] = {
      pattern = ">",
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha operadores lógicos (and, or, not)
    ["a"] = {
      pattern = [[\<and\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["o"] = {
      pattern = [[\<or\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    ["n"] = {
      pattern = [[\<not\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha function
    ["f"] = {
      pattern = [[\<function\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha then
    ["t"] = {
      pattern = [[\<then\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha do
    ["u"] = {
      pattern = [[\<do\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha in
    ["i"] = {
      pattern = [[\<in\>]],
      ignore_groups = { "String", "Comment" },
      left_margin = 1,
      right_margin = 1,
    },
    -- Alinha parênteses
    ["("] = {
      pattern = [=[(]=],
      left_margin = 0,
      right_margin = 0,
      stick_to_left = 0,
    },
    -- Alinha colchetes
    ["["] = {
      pattern = [=[\[]=],
      left_margin = 0,
      right_margin = 0,
      stick_to_left = 0,
    },
    -- Alinha chaves
    ["{"] = {
      pattern = [=[{]=],
      left_margin = 0,
      right_margin = 0,
      stick_to_left = 0,
    },
  })

--# Dap ................................................................ DEBUG
local dap = require("dap")

-- Lua
dap.adapters.nlua = function(callback, config)
  callback({
    type = "server",
    host = config.host or "127.0.0.1",
    port = config.port or 8086,
  })
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = "127.0.0.1",
    port = 8086,
  },
}

vim.keymap.set("n", "<leader>dl", function()
  require("osv").launch({ port = 8086 })
end, { buffer = buffer, desc = "Launch: OSV server" })

--# NULL-LS: formatting
local null_ls = require("null-ls")

local sources = {
  null_ls.builtins.formatting.stylua.with({
    extra_args = {
      "--config-path",
      vim.fn.expand("~/.config/nvim/stylua.toml"),
    },
  }),
}
null_ls.setup({
  sources = sources,
})
