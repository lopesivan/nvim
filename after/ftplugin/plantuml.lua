-- plantuml.lua - plantuml
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/ftplugin

vim.bo.equalprg = "java -jar /opt/plantuml/plantuml.jar -tpng %"

vim.g.projectionist_heuristics = {
  ["*.puml"] = {
    ["*.puml"] = {
      ["make"] = "java -jar /opt/plantuml/plantuml.jar -tpng {file}",
      ["dispatch"] = "java -jar /opt/plantuml/plantuml.jar -tsvg {file}",
      ["start"] = "sxiv {}.png",
      ["type"] = "plantuml",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "make", "Make" }
nmap { "d<CR>", "dispatch", "Dispatch" }
nmap { "s<CR>", "start", "Display image" }

--local start_cmd = vim.fn["projectionist#query_exec"]("start")
-- echo projectionist#query('start')[0][1]
-- echo projectionist#query('stop')[0][1]
-- echo projectionist#query('toggle')[0][1]

vim.cmd [[
nmenu Plantuml.png  :exe " ".projectionist#query('make')[0][1]
nmenu Plantuml.svg  :lua require'telegraph'.telegraph({cmd='java -jar /opt/plantuml/plantuml.jar -tsvg {filepath}', how='tmux'})
nmenu Plantuml.Show  :lua require'telegraph'.telegraph({cmd='eog {file_basename}.png ', how='tmux'})
]]

vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>call Menu2Quick('Plantuml', 'n')<CR>", { noremap = true, silent = true })
-- vim: fdm=marker:sw=4:sts=4:et
