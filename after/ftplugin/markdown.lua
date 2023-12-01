vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 64

vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.infercase = true

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ""
-- vim.g.mkdp_browser = "google-chrome-stable"
vim.g.mkdp_browser = "chrome"
vim.g.mkdp_echo_preview_url = 0
vim.g.mkdp_browserfunc = ""
vim.g.mkdp_markdown_css = ""
vim.g.mkdp_highlight_css = ""
vim.g.mkdp_port = ""
vim.g.mkdp_theme = "dark"
vim.g.mkdp_page_title = "${name}"
vim.g.table_mode_corner = "|"
vim.g.table_mode_corner_corner = "|"

vim.cmd [[highlight! link Headline TSConstructor]]

-- vim.b["surround_" .. vim.fn.char2nr "c"] = "\\\1command\1{\r}"
-- vim.b["surround_" .. vim.fn.char2nr "q"] = "\"\r\""
-- vim.b["surround_" .. vim.fn.char2nr "1"] = "\"\r\""
-- vim.b["surround_" .. vim.fn.char2nr "q"] = "\\enquote{\r}"
-- enable cursorline (L) and cmdline help (H)
vim.g.quickmenu_options = "HL"

vim.opt.formatoptions = "2jtcqln"

-- vim.opt.formatprg = string.format("fmt -w %s", vim.bo.textwidth)
vim.bo.equalprg = string.format("fmt -w %s", vim.bo.textwidth)

--[[
vim.g.projectionist_heuristics = {
  ['*.md'] = {
    ['*.md'] = {
      ['make'] = 'pandoc {file} --to=html5 -o %<.html -s --highlight-style tango -c css=pandoc.css',
      ['dispatch'] = 'pandoc {file} -o %<.tex',
      ['start'] = 'pandoc {file} --pdf-engine=xelatex -o %<.pdf',
      ['type'] = 'md'
    }
  }
}
--]]
vim.g.projectionist_heuristics = {
    ["*.md"] = {
        ["*.md"] = {
            ["make"] = "pandoc {file} --to=html5 -o %<.html -s --highlight-style tango -c css=pandoc.css",
            ["dispatch"] = "MarkdownPreviewStop",
            ["start"] = "MarkdownPreview",
            ["toggle"] = "MarkdownPreviewToggle",
            ["stop"] = "MarkdownPreviewStop",
            ["type"] = "markdown",
        },
    },
}

--local start_cmd = vim.fn["projectionist#query_exec"]("start")
-- echo projectionist#query('start')[0][1]
-- echo projectionist#query('stop')[0][1]
-- echo projectionist#query('toggle')[0][1]

vim.cmd [[
nmenu Markdown.Start  :exe " ".projectionist#query('start')[0][1]
nmenu Markdown.Stop   :exe " ".projectionist#query('stop')[0][1]
nmenu Markdown.Toggle :exe " ".projectionist#query('toggle')[0][1]
nmenu Markdown.toHTML :lua require'libuv.markdown'.convertFile()
nmenu Markdown.Slide  :lua require'telegraph'.telegraph({cmd='lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})
]]

-- vim.api.nvim_set_keymap("n", "<space>0", "<Cmd>call projectionist#activate()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap(
    "n",
    "<F12>",
    "<Cmd>call Menu2Quick('Markdown', 'n')<CR>",
    { noremap = true, silent = true }
)

local function get_line_range_of_visual_block()
    local _, first_line, _, _ = unpack(vim.fn.getpos "'<")
    local _, last_line, _, _ = unpack(vim.fn.getpos "'>")
    return { first_line - 1, last_line + 1 }
end

local function code_block(opts)
    local range = get_line_range_of_visual_block()

    vim.api.nvim_buf_set_text(0, range[1], 0, range[1], 0, { string.format("```{%s}", opts.args), "" })

    if range[2] >= vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_buf_set_lines(0, range[2], range[2], true, { "" })
    end

    vim.api.nvim_buf_set_text(0, range[2], 0, range[2], 0, { "```", "" })
end

vim.api.nvim_create_user_command("CodeBlock", code_block, { nargs = '?', range = true })

_G.my_code_block = code_block
vim.api.nvim_set_keymap(
    "n",
    "<leader>cb",
    "<CMD>call v:lua.my_code_block()<CR>",
    { noremap = true }
)
