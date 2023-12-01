local M = {}

local function c(command)
    return string.format("<CMD>%s<CR>", command)
end

function M.setup()
    require("refactoring").setup {
        prompt_func_return_type = {
            go = true,
            cpp = true,
            c = true,
            java = true,
        },
        prompt_func_param_type = {
            go = true,
            cpp = true,
            c = true,
            java = true,
        },
    }
    require("telescope").load_extension "refactoring"

    vim.keymap.set(
        "n",
        string.format("<space>r%s", "i"),
        c "lua require('refactoring').refactor('Inline Variable')",
        { desc = "Inline Variable" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "p"),
        c "lua require('refactoring').debug.printf({below = false})",
        { desc = "Debug Print" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "c"),
        c "lua require('refactoring').debug.cleanup({below = false})",
        { desc = "Debug Cleanup" }
    )
    --
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "e"),
        c "lua require('refactoring').refactor('Extract Function')",
        { desc = "Extract Function" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "f"),
        c "lua require('refactoring').refactor('Extract Function to File')",
        { desc = "Extract Function to File" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "v"),
        c "lua require('refactoring').refactor('Extract Variable')",
        { desc = "Extract Variable" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "I"),
        c "lua require('refactoring').refactor('Inline Variable')",
        { desc = "Inline Variable" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "r"),
        c "lua require('telescope').extensions.refactoring.refactors()",
        { desc = "Refactor" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>r%s", "V"),
        c "lua require('refactoring').debug.print_var({})",
        { desc = "Debug print var" }
    )
end

return M
