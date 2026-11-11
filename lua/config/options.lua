local opt = vim.opt
-- vim.opt.background = "light"
-- search is slow when true
opt.hlsearch = true
opt.expandtab = true
opt.shiftwidth = 2

opt.cursorline = true
opt.cursorcolumn = true
opt.cursorlineopt = "both" -- line + number: "both" | "line" | "number"

opt.wrap = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.textwidth = 78
opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

--opt.autocomplete = true

opt.pumheight = 10
vim.wo.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
-- vim.o.winborder = 'rounded'
-- opt.cursorline = true
-- opt.colorcolumn=90

opt.colorcolumn = "79"

opt.fillchars = { fold = " " }
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel = 99

-- Enable diagnostics
vim.diagnostic.config({
  virtual_text = true, -- Show inline diagnostics
  signs = true, -- Show signs in the gutter
  underline = true, -- Underline errors
  update_in_insert = true, -- Don't update diagnostics in insert mode
  severity_sort = true, -- Sort diagnostics by severity
})

-- vim.api.nvim_create_user_command("Dotnet", function()
--   vim.cmd("compiler dotnet")
--   vim.cmd("make")
--   vim.cmd("copen")
-- end, {})

local utils = require("my.utils")

if utils.im_on_windows() then
  --netcoredbg issue
  --https://github.com/mfussenegger/nvim-dap/discussions/1156
  vim.opt.shellslash = false
  vim.defer_fn(function()
    vim.opt.shellslash = false
  end, 5000)
end

vim.opt.shortmess:append({ I = true, c = false, F = false })

-- Ignore compiled files
opt.wildignore = "__pycache__"
opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*" })
opt.wildignore:append("Cargo.lock")
opt.wildignore:append("**/node_modules/*")
opt.wildignore:append("**/.git/*")

opt.path:remove("/usr/include")
opt.path:append("**")
opt.whichwrap:append("<>[]hl")
opt.shortmess:append("sI")

-- NOTE: tenho a opção com e sem brew
local shell =
  string.format("bash --rcfile %s/bashrc", vim.fn.stdpath("config"))
opt.shell = shell

-- local ui2 = require("vim._core.ui2")
-- ui2.enable({
--   enable = true
-- })

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

local config = vim.fn.stdpath("config")
ensure_dir(config .. "/backup")
ensure_dir(config .. "/tmp")
ensure_dir(config .. "/undo")

vim.g.loaded_matchparen = 1
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.python2_host_prog = "/home/ivan/.pyenv/versions/2.7.18/bin/python"
vim.g.python3_host_prog = "/home/ivan/.pyenv/versions/3.10.15/bin/python"
vim.g.python_host_prog = "/home/ivan/.pyenv/versions/3.10.15/bin/python"
vim.g.perl_host_prog = "/home/linuxbrew/.linuxbrew/bin/perl"
-- NOTE: aparentimente a linha de baixo deve se manter ativa conforme
-- checkhealth
vim.g.loaded_perl_provider = 0

vim.g.ruby_host_prog = "/home/ivan/.rbenv/versions/3.3.5/bin/neovim-ruby-host"
vim.env.PYENV_VERSION = vim.fn.system("pyenv version"):match("(%S+)%s+%(.-%)")

vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})

-- vim.opt.autoread = true

-- Disable some builtin vim plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  "matchit",
  "matchparen",
  "tar",
  "tarPlugin",
  "rrhelper",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- ---------------------------------------------------------------------------
-- copy and paste
-- ---------------------------------------------------------------------------

vim.opt.clipboard:append("unnamedplus")

vim.g.clipboard = {
  name = "xclip",

  copy = {
    ["+"] = { "xclip", "-in", "-selection", "clipboard" },
    ["*"] = { "xclip", "-in", "-selection", "primary" },
  },

  paste = {
    ["+"] = { "xclip", "-out", "-selection", "clipboard" },
    ["*"] = { "xclip", "-out", "-selection", "primary" },
  },

  cache_enabled = 1,
}
-- -----------------------------------------------------------------------------
-- Comandos personalizados
-- -----------------------------------------------------------------------------

-- require("config.command.a_listurls")
-- require("config.command.a_checklinks")
-- require("config.command.a_coderunner")
require("config.command.a_cursor")
require("config.command.a_compilers")
require("config.command.a_qclose")
require("config.command.a_spell")
-- require("config.command.a_macros")
-- require("config.command.a_preview")
-- require("config.command.a_scratch")
-- require("config.command.a_skell")
-- require("config.command.a_yankhilight")
-- require("config.command.a_last_location")
-- require("config.command.a_create_dir")
-- require("config.command.a_trim")
-- require("config.command.a_markdown")
-- require("config.command.a_filesearch")
-- require("config.command.a_ripgrep")
