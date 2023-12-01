local has_lir, lir = pcall(require, "lir")
if not has_lir then
    return
end

local has_devicons, devicons = pcall(require, "nvim-web-devicons")
if has_devicons then
	devicons.set_icon({
	  lir_folder_icon = {
		icon = "",
		color = "#7ebae4",
		name = "LirFolderNode"
	  }
	})
end

local actions = require "lir.actions"
local mark_actions = require "lir.mark.actions"
local clipboard_actions = require "lir.clipboard.actions"
local has_mmv, mmv_actions = pcall(require, "lir.mmv.actions")

lir.setup {
    show_hidden_files = true,
    devicons = {
        enable = true,
        highlight_dirname = true,
    },

    mappings = {
        ["<CR>"] = actions.edit,
        ["_"] = actions.up,

        ["q"] = actions.quit,
        ["k"] = actions.mkdir,
        ["N"] = actions.newfile,
        ["rn"] = actions.rename,
        ["yy"] = actions.yank_path,
        ["@"] = actions.cd,
        ["."] = actions.toggle_show_hidden,
        ["dd"] = actions.delete,

        ["<C-s>"] = actions.split,
        ["<C-v>"] = actions.vsplit,
        ["<C-t>"] = actions.tabedit,

        ["m"] = function()
            mark_actions.toggle_mark()
            vim.cmd "normal! j"
        end,
        ["c"] = clipboard_actions.copy,
        ["x"] = clipboard_actions.cut,
        ["p"] = clipboard_actions.paste,
    
		-- mmv
		["M"] = (has_mmv and mmv_actions.mmv) or nil,
    },
}

vim.api.nvim_set_keymap(
    "n",
    "_",
    ":if empty(expand('%:h')) | edit . | else | edit %:h | endif<CR>",
    { noremap = true }
)

-- Can do this if we want to get particular settings
-- vim.cmd [[
--   augroup LirSettings
--     au!
--     autocmd Filetype lir :lua LirSettings()
--   augroup END
-- ]]

-- Recommended actions, can play with these some more later.
-- ['l']     = actions.edit,
-- ['<C-s>'] = actions.split,
-- ['<C-v>'] = actions.vsplit,
-- ['<C-t>'] = actions.tabedit,

-- ['h']     = actions.up,
-- ['q']     = actions.quit,

-- ['K']     = actions.mkdir,
-- ['N']     = actions.newfile,
-- ['R']     = actions.rename,
-- ['@']     = actions.cd,
-- ['Y']     = actions.yank_path,
-- ['.']     = actions.toggle_show_hidden,
-- ['D']     = actions.delete,
