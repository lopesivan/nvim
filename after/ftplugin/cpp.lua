-- 1. CONFIGURAÇÕES LOCAIS DO BUFFER (vim.opt_local)
local set = vim.opt_local

set.shiftwidth = 4 -- Definição de recuo padrão de 4 espaços
set.commentstring = "// %s" -- Comentários de linha única nativos do C++

-- 2. Vim-Surround: Seleção Visual + S + p (Injeta std::cout tipado de C++)
vim.b["surround_" .. vim.fn.char2nr("p")] = "std::cout << \"\r\" << '\\n';"

-- 3. PROJECTIONIST (Heurísticas de Compilação e Build para C++)
vim.g.projectionist_heuristics = {
  ["*.cpp"] = {
    ["*.cpp"] = {
      ["start"] = "cling",
      ["make"] = "make {}",
      ["run"] = "lua require('my.neovim_dev').app('./{}')",
      ["dispatch"] = "rm {}",
      ["yabs_run"] = "run",
      ["yabs_build"] = "build",
      -- Compilador moderno com flags estritas de Debug e checagem de escopo (Shadowing)
      ["CC"] = "g++-14 -std=c++17 -g -O0 -Wall -Werror -Wextra -Wshadow -Wpedantic -Wno-parentheses -c -o {}.o {}.cpp",
      ["LD"] = "g++-17 -lm {}.o -o {}",
      ["BIN"] = "./{}",
      ["clean"] = "!rm {project}/{} {project}/{}.o",
      ["type"] = "cpp",
    },
  },
}

-- 4. MAPEAMENTOS E COMANDOS LOCAIS (PROTEÇÃO POR BUFNR)
local bufnr = vim.api.nvim_get_current_buf()

-- Atalhos do Dispatcher injetados de forma segura e buffer-local
local dispatch_nmap = require("my.dispatch").nmap

dispatch_nmap({ "s<CR>", "start", "cling" }, { buffer = bufnr })
dispatch_nmap({ "<space><CR>", "run", "run", "run" }, { buffer = bufnr })
dispatch_nmap(
  { "<space><space>r", "yabs_run", "run", "run" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>b", "yabs_build", "build", "g++ build" },
  { buffer = bufnr }
)
dispatch_nmap({ "<c-l>", "clean", "Remove" }, { buffer = bufnr })

-- 5. Menu de comandos
vim.cmd([[
nnoremenu Gen.makefile  :!echo % <Bar> sed.g_mk-m > Makefile<CR>
]])

vim.keymap.set("n", "<F12>", function()
  vim.fn.Menu2Quick("Gen", "n")
end, { buffer = true, silent = true })
