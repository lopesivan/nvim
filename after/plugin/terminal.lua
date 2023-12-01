-- terminal.lua - terminal
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

local function set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<m-Up>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(
        0,
        "t",
        "<m-Down>",
        [[<C-\><C-n><C-W>j]],
        opts
    )
    vim.api.nvim_buf_set_keymap(
        0,
        "t",
        "<m-Left>",
        [[<C-\><C-n><C-W>h]],
        opts
    )
    vim.api.nvim_buf_set_keymap(
        0,
        "t",
        "<m-Right>",
        [[<C-\><C-n><C-W>l]],
        opts
    )
end

local group = vim.api.nvim_create_augroup("TerminalNav", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    pattern = { "term://*" },
    callback = function()
        set_terminal_keymaps()
    end,
})
-- vim: fdm=marker:sw=4:sts=4:et
