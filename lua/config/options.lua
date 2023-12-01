local options = {
  wildmode = "longest:full",
  wildoptions = "pum",
  wildignorecase = true,
  showmode = true,
  showcmd = true,
  completeopt = "menuone,noselect",
  conceallevel = 0,
  fileformats = { "unix", "dos", "mac" },
  backspace = { "indent", "eol", "start" },
  cmdheight = 0, -- Height of the command bar
  incsearch = true, -- Makes search act like search in modern browsers
  showmatch = true, -- show matching brackets when text indicator is over them
  number = true, -- But show the actual number for the line we're on
  ignorecase = true, -- Ignore case when searching...
  smartcase = true, -- ... unless there is a capital letter in the query
  hidden = true, -- I like having buffers stay around
  cursorcolumn = true,
  cursorline = true, -- Highlight the current line
  equalalways = false, -- I don't like my windows changing all the time
  splitright = true, -- Prefer windows splitting to the right
  splitbelow = true, -- Prefer windows splitting to the bottom
  updatetime = 1000, -- Make updates happen faster
  hlsearch = true, -- I wouldn't use this without my DoNoHL function
  tags = { "./tags" },
  autoindent = true,
  cindent = true,
  wrap = true,
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  textwidth = 78,
  breakindent = true,
  showbreak = string.rep(" ", 3), -- Make it so that long lines wrap smartly
  linebreak = true,
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  -- fillchars = { eob = "~" },
  foldcolumn = "1", -- '0' is not bad
  foldenable = true,
  foldlevel = 99, -- Using ufo provider need a large value, feel free to decrease the value
  foldlevelstart = 99,
  formatoptions = "jqlnt", -- tcqj
  -- modelines = 1,
  clipboard = "unnamedplus",
  -- inccommand = "split",
  inccommand = "nosplit",
  swapfile = false, -- Living on the edge
  shada = { "!", "'1000", "<50", "s10", "h" },
  bomb = true,
  binary = true,
  ttyfast = true,
  mouse = "a", --Enable mouse mode
  laststatus = 3, -- Global statusline
  termguicolors = true,
  visualbell = true,
  virtualedit = "block",
  encoding = "utf-8",
  fileencoding = "utf-8",
  fileencodings = "utf-8",
  colorcolumn = "79",
  sm = true,
  backup = true,
  backupcopy = "yes",
  backupdir = string.format("%s/%s", vim.fn.stdpath "config", "backup"),
  directory = string.format("%s/%s", vim.fn.stdpath "config", "tmp"),
  undodir = string.format("%s/%s", vim.fn.stdpath "config", "undo"),
  autochdir = false,
  undofile = true,
  startofline = true,
  joinspaces = false, -- Two spaces and grade school, we're done
  list = true,
  pumblend = 10,
  pumheight = 10,
  relativenumber = true,
  scrollback = 100000,
  scrolloff = 8,
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
  shiftround = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local opt = vim.opt
-- Ignore compiled files
opt.wildignore = "__pycache__"
opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*" }
opt.wildignore:append "Cargo.lock"
opt.wildignore:append "**/node_modules/*"
opt.wildignore:append "**/.git/*"

opt.path:remove "/usr/include"
opt.path:append "**"
opt.whichwrap:append "<>[]hl"
opt.shortmess:append "sI"

local shell = string.format("bash --rcfile %s/bashrc", vim.fn.stdpath "config")
opt.shell = shell

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.g.markdown_recommended_style = 0

vim.g.loaded_matchparen = 1
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.python_host_prog = "/home/ivan/.pyenv/versions/neovim2/bin/python"
vim.g.python2_host_prog = "/home/ivan/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "/home/ivan/.pyenv/versions/neovim3/bin/python"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.echodoc_enable_at_startup = 1
vim.g.skip_ts_context_commentstring_module = true

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

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
