-- tex.lua - tex
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 78

vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.infercase = true
-- vim.opt.spell       = true
vim.opt.spelllang = "pt_br"

-- vimtex
-- vim.g.loaded_targets = true
-- vim.g.vimtex_compiler_enabled = true
-- vim.g.vimtex_doc_enabled = true
-- vim.g.vimtex_imaps_enabled = true
-- vim.g.vimtex_mappings_disable = true
-- vim.g.vimtex_mappings_enabled = true
-- vim.g.vimtex_mappings_override_existing = true
-- vim.g.vimtex_motion_enabled = true
-- vim.g.vimtex_text_obj_enabled = true
-- vim.g.vimtex_text_obj_variant = true
-- vim.g.vimtex_toc_enabled = true

vim.b["surround_" .. vim.fn.char2nr "c"] = "\\\1command\1{\r}"
vim.b["surround_" .. vim.fn.char2nr "1"] = "<CMD>\r<CR>"
vim.b["surround_" .. vim.fn.char2nr "q"] = "\\enquote{\r}"
-- vim.b['surround_'..vim.fn.char2nr('2')]='<CMD>lua \r<CR>'
-- vim.b['surround_'..vim.fn.char2nr('3')]='print(vim.inspect(\r))'

vim.g.projectionist_heuristics = {
    ["*.tex"] = {
        ["*.tex"] = {
            ["build"] = "VimtexCompile",
            ["show"] = "!zathura {}.pdf",
            ["type"] = "tex",
        },
    },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "build", "build manager" }
nmap { "s<CR>", "show", "Show file" }

local function get_line_range_of_visual_block()
    local _, first_line, _, _ = unpack(vim.fn.getpos "'<")
    local _, last_line, _, _ = unpack(vim.fn.getpos "'>")
    return { first_line - 1, last_line + 1 }
end

local function code_block(opts)
    local range = get_line_range_of_visual_block()

    vim.api.nvim_buf_set_text(
        0,
        range[1],
        0,
        range[1],
        0,
        { "\\begin{flushleft}", "" }
    )

    if range[2] >= vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_buf_set_lines(0, range[2], range[2], true, { "" })
    end

    vim.api.nvim_buf_set_text(
        0,
        range[2],
        0,
        range[2],
        0,
        { "\\end{flushleft}", "" }
    )
end
vim.api.nvim_create_user_command("CodeBlock", code_block, { nargs = '?', range = true })

_G.my_code_block = code_block
vim.api.nvim_set_keymap(
    "n",
    "<leader>cb",
    "<CMD>call v:lua.my_code_block()<CR>",
    { noremap = true }
)
-- vim: fdm=marker:sw=4:sts=4:et
