local M = {}

local function c(command)
    return string.format("<CMD>%s<CR>", command)
end

function M.setup()
    require("harpoon").setup {
        global_settings = {
            save_on_toggle = true,
            enter_on_sendcmd = true,
            tmux_autoclose_windows = true,
        },
    }
    require("telescope").load_extension "harpoon"
    for i = 1, 5 do
        vim.keymap.set("n", string.format("<space>h%s", i), function()
            require("harpoon.ui").nav_file(i)
        end, { desc = string.format("Go to file %s", i) })
    end

    --[[
    opts = {
        defaults = {
            mode = { "n" },
            ["<leader>f"] = { name = "+File" },
            ["<leader>q"] = { name = "+Quit/Session" },
            ["<leader>qq"] = { cmd = "<cmd>q<cr>", desc = "Quit" },
            ["<leader>w"] = { cmd = "<cmd>update!<cr>", desc = "Save" },
        },
    }

    local wk = require "which-key"
    wk.setup(opts)
    wk.register(opts.defaults)
    ]]

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "a"),
        c "lua require('harpoon.mark').add_file()",
        { desc = "Add File" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "m"),
        c "lua require('harpoon.ui').toggle_quick_menu()",
        { desc = "UI Menu" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "c"),
        c "lua require('harpoon.cmd-ui').toggle_quick_menu()",
        { desc = "Command Menu" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "f1"),
        c "lua require('harpoon.ui').nav_file(1)",
        { desc = "File 1" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "f2"),
        c "lua require('harpoon.ui').nav_file(2)",
        { desc = "File 2" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "s1"),
        c "lua require('harpoon.term').sendCommand(1,1)",
        { desc = "Command 1" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "s2"),
        c "lua require('harpoon.term').sendCommand(1,2)",
        { desc = "Command 2" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>h%s", "s3"),
        c "lua require('harpoon.term').sendCommand(1,3)",
        { desc = "Command 3" }
    )

    vim.keymap.set(
        "n",
        string.format("<space>t%s", "1"),
        c "lua require('harpoon.term').gotoTerminal(1)",
        { desc = "Go Terminal 1" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>t%s", "2"),
        c "lua require('harpoon.term').gotoTerminal(2)",
        { desc = "Go Terminal 2" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>t%s", "p"),
        c "TSPlaygroundToggle",
        { desc = "Toggle Tree Sitter Playground" }
    )
    vim.keymap.set(
        "n",
        string.format("<space>t%s", "h"),
        c "TSHighlightCapturesUnderCursor",
        { desc = "Tree Sitter Captures Under Cursor" }
    )
end

return M
