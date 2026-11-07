--=============================================================================
-- 1. CONFIGURAÇÕES LOCAIS DO BUFFER (vim.opt_local)
--=============================================================================
local set = vim.opt_local

set.shiftwidth = 4 -- Definição de recuo padrão de 4 espaços
set.commentstring = "// %s" -- Comentários de linha única nativos do C++

-- Vim-Surround: Seleção Visual + S + p (Injeta std::cout tipado de C++)
vim.b["surround_" .. vim.fn.char2nr("p")] = "std::cout << \"\r\" << '\\n';"

--=============================================================================
-- 4. PROJECTIONIST (Heurísticas de Compilação e Build para C++)
--=============================================================================
vim.g.projectionist_heuristics = {
  ["*.cpp"] = {
    ["*.cpp"] = {
      ["start"] = "cling",
      ["make"] = "make {}",
      ["makelog"] = "lua require('my.neovim_dev').applog('make', {'{}'}, '{file}.log')",
      ["run"] = "lua require('my.neovim_dev').app('./{}')",
      ["dispatch"] = "rm {}",
      ["yabs_run"] = "run",
      ["yabs_make"] = "make",
      ["yabs_make_run"] = "make run",
      ["yabs_clean"] = "make clean",
      ["yabs_test"] = "make test",
      ["yabs_autogen"] = "bash ./autogen.sh",
      ["yabs_install"] = "make install",
      ["yabs_uninstall"] = "make uninstall",
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

--=============================================================================
-- 5. MAPEAMENTOS E COMANDOS LOCAIS (PROTEÇÃO POR BUFNR)
--=============================================================================
local bufnr = vim.api.nvim_get_current_buf()

-- Atalhos do Dispatcher injetados de forma segura e buffer-local
local dispatch_nmap = require("my.dispatch").nmap

dispatch_nmap(
  { "<space><space>a", "yabs_autogen", "autogen", "autogen" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>m", "yabs_make", "make", "make" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>c", "yabs_clean", "clean", "clean" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>i", "yabs_install", "install", "install" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>u", "yabs_uninstall", "uninstall", "uninstall" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>t", "yabs_test", "make test", "make test" },
  { buffer = bufnr }
)

dispatch_nmap({ "s<CR>", "start", "cling" }, { buffer = bufnr })
dispatch_nmap({ "<space><CR>", "run", "run", "run" }, { buffer = bufnr })
dispatch_nmap(
  { "<space><space>r", "yabs_make_run", "make run", "make run" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>l", "makelog", "makelog", "make and save log" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<space><space>b", "yabs_build", "build", "g++ build" },
  { buffer = bufnr }
)
dispatch_nmap({ "<c-l>", "clean", "Remove" }, { buffer = bufnr })

vim.cmd([[
nmenu Gen.makefile  :!echo % \| sed.g_mk-m > Makefile
]])

vim.api.nvim_set_keymap(
  "n",
  "<F12>",
  "<Cmd>call Menu2Quick('Gen', 'n')<CR>",
  { noremap = true, silent = true }
)

--=============================================================================
-- 6. MODELINE (Instruções embutidas para o Neovim ler o próprio arquivo)
--=============================================================================
-- vim:set ft=lua nowrap foldtext=getline(v\:foldstart) foldmethod=expr foldexpr=getline(v\:lnum)=~'^--#'?'>1'\:'=':
