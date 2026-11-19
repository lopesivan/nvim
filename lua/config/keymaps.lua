local options = { noremap = true, silent = true }
local map = vim.keymap

--tab to indent
map.set("v", "<Tab>", ">", options)
map.set("v", "<S-Tab>", "<", options)

-- jk to normal mode
map.set("i", "jk", "<Esc>", options)

-- ctr + backspace delete word
vim.api.nvim_set_keymap(
  "i",
  "<C-H>",
  "<C-W>",
  { noremap = true, silent = true }
)
-- vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })
--ctrl + A select all
-- vim.api.nvim_set_keymap("n", "<C-a>", "ggVG<CR>", options)

-- alt + z and x to <>
vim.api.nvim_set_keymap("i", "<A-z>", "<", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-x>", ">", { noremap = true, silent = true })

-- navigate buffers
map.set("n", "<C-Left>", "<C-w><Left>", options)
map.set("n", "<C-Right>", "<C-w><Right>", options)
map.set("n", "<C-Up>", "<C-w><Up>", options)
map.set("n", "<C-Down>", "<C-w><Down>", options)

-- Resize vertically
vim.keymap.set("n", "<C-w><Left>", ":vertical resize -5<CR>", options)
vim.keymap.set("n", "<C-w><Right>", ":vertical resize +5<CR>", options)

-- Resize horizontally
vim.keymap.set("n", "<C-w><Up>", ":resize -5<CR>", options)
vim.keymap.set("n", "<C-w><Down>", ":resize +5<CR>", options)

-- undo
-- overlaps suspend
-- map.set('n', '<C-z>', 'u', options)

-- Save with ctrl + s
-- map.set(
--   { "n", "v", "i" },
--   "<C-S>",
--   "<C-c>:wa<cr>",
--   { silent = true, desc = "Save" }
-- )

-- Mapeia a tecla ASCII 31 para fechar o Neovim: <c-/>
vim.keymap.set("n", "<C-_>", ":q!<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "?", ":let g:session_autosave='no'<CR>:q!<CR>")
vim.keymap.set("n", "\\\\", ":w!<CR>")

--map.set("n", "q", ":cclose<cr>", options)
-- LSP
map.set("n", "rn", vim.lsp.buf.rename, options)
map.set("n", "gr", vim.lsp.buf.references, options)
map.set("n", "gd", vim.lsp.buf.definition, {})
map.set("n", "gi", vim.lsp.buf.implementation, {})
map.set("n", "<C-x>", vim.lsp.buf.code_action, options)
map.set("n", "gt", vim.lsp.buf.document_symbol, options)

-- go to definition split
map.set("n", "gs", function()
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.lsp.buf.definition()
end, options)

map.set("n", "<Leader>f", vim.lsp.buf.format, options)
map.set("n", "<C-.", vim.lsp.buf.code_action, options)
map.set("n", "<gh", vim.lsp.buf.signature_help, options)
map.set("n", "<A-l>", ":BufferLineCycleNext<CR>", options)
map.set("n", "<A-h>", ":BufferLineCyclePrev<CR>", options)
map.set("n", "<C-w>", ":bdelete<CR>", options)
map.set(
  "n",
  "<A-w>",
  ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>",
  options
)
map.set("n", "E", vim.diagnostic.open_float, options)
map.set(
  "n",
  "ne",
  "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
  options
)
map.set(
  "n",
  "nw",
  "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING})<CR>",
  options
)

-- Clipboard
-- Copy
--vim.keymap.set("v", "<C-c>", '"+y')
--vim.keymap.set("n", "<C-c>", '"+yy')

-- Cut
--vim.keymap.set('v', '<C-x>', '"+d')

-- Paste
--vim.keymap.set({ "n", "v" }, "<C-v>", '"+p')
--vim.keymap.set("i", "<C-v>", "<C-r>+")

--tree
-- map.set("n", "te", ":Neotree toggle<CR>", options)
-- map.set("n", "te", function() require('mini.files').open() end, options)

--suspend
vim.keymap.set("n", "<Leader>z", "<C-z>", { noremap = true, silent = true })

--terminal insert to normal mode
--vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { silent = true })
--vim.keymap.set("n", "<Leader>cm", "<C-l>", {})

-- ----------------------------------------------------------------------------
-- to executable: chmod +x

vim.keymap.set("n", "<A-x>", function()
  local file = vim.api.nvim_buf_get_name(0)
  local stat = file ~= "" and vim.uv.fs_stat(file)
  if not stat then
    return vim.notify(
      "Arquivo não existe em disco (salve antes)",
      vim.log.levels.WARN
    )
  end

  local mode = stat.mode % 4096 -- só bits de permissão
  local is_exec = bit.band(mode, 0x49) ~= 0 -- 0111

  local new, msg
  if is_exec then
    new = bit.band(mode, bit.bnot(0x49)) -- remove x (chmod -x)
    msg = "chmod -x: "
  else
    new = bit.bor(mode, bit.rshift(bit.band(mode, 0x124), 2)) -- 0444 -> 0111
    msg = "chmod +x: "
  end

  local ok, err = vim.uv.fs_chmod(file, new)
  if ok then
    vim.notify(msg .. vim.fn.fnamemodify(file, ":~"))
  else
    vim.notify("Falha no chmod: " .. tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Alterna executável (chmod +x / -x)" })

-- ----------------------------------------------------------------------------

--[[
Uso:

<leader>cf → diretório do arquivo
<leader>cp → raiz do projeto

Se seu <leader> é espaço (vim.g.mapleader = " "):

space + c + d + f
space + c + d + p

Esses comandos usam lcd, então o diretório muda só para a janela atual.
]]
-- Vai para o diretório do arquivo atual
vim.keymap.set("n", "<leader>cdf", function()
  vim.cmd("lcd %:p:h")
  print("Diretório do arquivo atual")
end, { desc = "CD para pasta do arquivo" })

-- Vai para a raiz do projeto
vim.keymap.set("n", "<leader>cdr", function()
  local root = vim.fs.root(0, {
    ".git",
    "package.json",
    "pyproject.toml",
    "Cargo.toml",
    "go.mod",
  })

  if root then
    vim.cmd("lcd " .. root)
    print("Projeto: " .. root)
  else
    print("Raiz do projeto não encontrada")
  end
end, { desc = "CD para raiz do projeto" })

local filein = require("my.filein")

vim.keymap.set("n", "]f", function()
  filein.jump(vim.v.count1)
end, { silent = true, desc = "Próximo arquivo do diretório" })

vim.keymap.set("n", "[f", function()
  filein.jump(-vim.v.count1)
end, { silent = true, desc = "Arquivo anterior do diretório" })
