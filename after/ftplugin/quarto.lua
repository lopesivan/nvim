-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = '|'

vim.g.projectionist_heuristics = {
    ["*.qmd"] = {
        ["*.qmd"] = {
            ["QuartoPreview"] = "QuartoPreview",
            ["QuartoClosePreview"] = "QuartoClosePreview",
            ["QuartoDiagnostics"] = "QuartoDiagnostics",
            ["QuartoActivate"] = "QuartoActivate",
            ["QuartoHelp"] = "QuartoHelp",
            ["QuartoHover"] = "QuartoHover",
            ["QuartoSendAbove"] = "QuartoSendAbove",
            ["QuartoSendAll"] = "QuartoSendAll",
            ["type"] = "quarto",
        },
    },
}

vim.cmd [[
nmenu Quarto.QuartoPreview  :exe " ".projectionist#query('QuartoPreview')[0][1]
nmenu Quarto.QuartoClosePreview  :exe " ".projectionist#query('QuartoClosePreview')[0][1]
nmenu Quarto.QuartoDiagnostics  :exe " ".projectionist#query('QuartoDiagnostics')[0][1]
nmenu Quarto.QuartoActivate  :exe " ".projectionist#query('QuartoActivate')[0][1]
nmenu Quarto.QuartoHelp  :exe " ".projectionist#query('QuartoHelp')[0][1]
nmenu Quarto.QuartoHover  :exe " ".projectionist#query('QuartoHover')[0][1]
nmenu Quarto.QuartoSendAbove  :exe " ".projectionist#query('QuartoSendAbove')[0][1]
nmenu Quarto.QuartoSendAll  :exe " ".projectionist#query('QuartoSendAll')[0][1]
]]

vim.api.nvim_set_keymap(
    "n",
    "<F12>",
    "<Cmd>call Menu2Quick('Quarto', 'n')<CR>",
    { noremap = true, silent = true }
)
