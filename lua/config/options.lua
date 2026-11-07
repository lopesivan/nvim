local opt = vim.opt
-- vim.opt.background = "light"
-- search is slow when true
opt.hlsearch = false
opt.expandtab = true
opt.shiftwidth = 2

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

vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})

-- vim.opt.autoread = true

-- -----------------------------------------------------------------------------
-- Comandos personalizados
-- -----------------------------------------------------------------------------

-- require("config.command.a_listurls")
-- require("config.command.a_checklinks")
-- require("config.command.a_coderunner")
-- require("config.command.a_cursor")
-- require("config.command.a_macros")
-- require("config.command.a_preview")
-- require("config.command.a_qclose")
-- require("config.command.a_scratch")
-- require("config.command.a_skell")
require("config.command.a_spell")
-- require("config.command.a_yankhilight")
-- require("config.command.a_last_location")
-- require("config.command.a_create_dir")
-- require("config.command.a_trim")
-- require("config.command.a_markdown")
-- require("config.command.a_compilers")
-- require("config.command.a_filesearch")
-- require("config.command.a_ripgrep")
