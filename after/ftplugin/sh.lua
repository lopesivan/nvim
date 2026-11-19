local set = vim.opt_local
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.textwidth = 78

set.expandtab = true
set.wrap = false
set.smartcase = true
set.infercase = true

set.commentstring = "# %s"
set.foldtext = "getline(v:foldstart)"

--# Surround

-- word
-- ^^^^
-- v select + S + p
vim.b["surround_" .. vim.fn.char2nr("p")] = "${\r}"
vim.fn.setreg("a", "veSp")

--# Setup projectionist
vim.g.projectionist_heuristics = {
  ["*.sh"] = {
    ["*.sh"] = {
      ["dispatch"] = "bash {file}",
      ["make"] = "bash {file}",
      -- roda o arquivo salvo
      ["run"] = "lua require('my.neovim_dev').sh({'{file}'})",
      -- roda o que estiver definido em yabs.lua "sh"
      -- roda o buffer
      ["yabs"] = "run",
      ["type"] = "sh",
    },
  },
}

local nmap = require("my.dispatch").nmap
nmap({ "<leader><CR>", "run", "nvim_dev Run", "run with sh" })
nmap({ "r<CR>", "yabs", "Run", "yabs Run" })
-- nmap { "m<CR>", "make", "Make" }
nmap({ "d<CR>", "dispatch", "Dispatch", "executar/encaminhar asinc bash" })

--# NULL_LS

-- Lê o valor numérico do option 'tabstop'
local ts_num = vim.api.nvim_get_option_value("tabstop", {}) -- retorna, por exemplo, 4

-- Converte para string
local ts_str = tostring(ts_num)

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- mostra o valor da variável de ambiente, exemplo: PWD -  cursor
    -- sobre $PWD e pressiono `K'
    null_ls.builtins.hover.printenv,
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "-i", ts_str, "-ci" },
    }),
  },
})
