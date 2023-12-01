local keymap = vim.keymap.set

local function c(command)
  return string.format("<CMD>%s<CR>", command)
end

local function fileExist(path)
  local fs_stat = vim.loop.fs_stat(path)
  return fs_stat ~= nil
end

-- c1 e c2
local cmd = vim.cmd

-- keymap("n", "<leader>c1", [[:%g/^\n\{2,\}/ d<CR>:%s/\s\+$//g<CR>]], { silent = true })
-- keymap("n", "<leader>c2", [[:setlocal expandtab<CR>:retab<CR>]], { silent = true })

local function skel()
  local key = "skeleton"
  local query_result = key

  local path = "./.projections.json"
  if fileExist(path) then
    if not vim.tbl_isempty(vim.b.projectionist) then
      key = "skeleton"
      query_result = vim.fn["projectionist#query_exec"](key)[1][2]
    end
  end

  vim.api.nvim_feedkeys("i_" .. query_result, "n", true)
  local ctrlR = vim.api.nvim_replace_termcodes("<C-r>", true, false, true)
  local enter = vim.api.nvim_replace_termcodes("<C-m>", true, false, true)
  vim.api.nvim_feedkeys(ctrlR .. "=UltiSnips#ExpandSnippet()" .. enter, "n", true)
end

keymap("n", "<leader>kk", function()
  skel()
end, { expr = true, desc = "Load Skeleton" })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Paste
keymap("n", "]p", "o<Esc>p", { desc = "Paste below" })
keymap("n", "]P", "O<Esc>p", { desc = "Paste above" })

-- Better escape using jk in insert and terminal mode
-- keymap("i", "jk", "<ESC>")
-- keymap("t", "jk", "<C-\\><C-n>")
-- keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
-- keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
-- keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
-- keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
-- keymap("i", ",", ",<c-g>u")
-- keymap("i", ".", ".<c-g>u")
-- keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dp')

-- Insert blank line
-- keymap("n", "]<Space>", "o<Esc>")
-- keymap("n", "[<Space>", "O<Esc>")

-- My maps
keymap("n", "?", ":let g:session_autosave='no'<CR>:q!<CR>")
keymap("n", "\\\\", ":w!<CR>")

-- Auto indent
keymap("n", "i", function()
  if #vim.fn.getline "." == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- command: AsyncTaskList
vim.g.asyncrun_open = 6

--  Git
keymap("n", "<leader>Q", c "lclose", { desc = "L Close" })
keymap("n", "<leader>q", c "cclose", { desc = "C Close" })
-- keymap("n", "<m-a>", c "Git add %:p")
-- keymap("n", "<m-r>", c "Gread")
-- keymap("n", "<m-w>", c "Gwrite")

-- My conf
-- keymap("n", "<cr>", "ciw")

keymap(
  "n",
  "<Leader>N",
  "<CMD>luafile " .. string.format("%s/%s", vim.fn.stdpath "config", "lua/libuv") .. "/new_file_plenary_async.lua<CR>",
  { desc = "New File", noremap = false, nowait = true }
)
keymap(
  "n",
  "<Leader>nf",
  "<CMD>luafile " .. string.format("%s/%s", vim.fn.stdpath "config", "lua/libuv") .. "/new_file_plenary_async.lua<CR>",
  { desc = "New File", noremap = false, nowait = true }
)

keymap("n", "<Leader>ng", function()
  local message = vim.fn.input "[dir name] > "
  if message == "" then
    print "Mensagem de stash está vazia. Nenhuma ação foi executada."
    return
  end
  local cmd = string.format("git init %s", message)
  vim.fn.system(cmd)
end, { desc = "New repo", noremap = false, nowait = true })

keymap("n", "<Leader>gB", function()
  local message = vim.fn.input "[branch name] > "
  if message == "" then
    print "Mensagem de stash está vazia. Nenhuma ação foi executada."
    return
  end
  local cmd = string.format("git checkout -b %s", message)
  vim.fn.system(cmd)
end, { desc = "New Branch", noremap = false, nowait = true })

keymap(
  "n",
  "<Leader>T",
  "<CMD>luafile " .. string.format("%s/%s", vim.fn.stdpath "config", "lua/config") .. "/my_template.lua<CR>",
  { desc = "Telescope: template", noremap = false, nowait = true }
)

keymap("n", "<Leader>y", "<CMD>Telescope yabs tasks<CR>", { desc = "Telescope: task list", noremap = false, nowait = true })
-- Code
keymap("n", "<leader>e", c "lua require('config.repl').set_command()", { desc = "Set current cell to send" })
keymap("v", "<leader>e", ":lua require('config.repl').set_vcommand()<CR>", { desc = "Set current cell's to send" })
keymap("n", "<leader>j", c "lua require('config.repl').set_job_command()", { desc = "Define command in input" })
keymap("n", "<leader>X", c "lua require('config.repl').send_to_term()", { desc = "Send selected command to terminal" })
keymap("n", "<Leader>nns", "<CMD>NoiceLast<CR>", { desc = "Noice Show", noremap = false, nowait = true })
keymap("n", "<Leader>nnd", "<CMD>NoiceDisable<CR>", { desc = "Noice Disable", noremap = false, nowait = true })
--
local opts = {
  defaults = {
    mode = { "n" },
    --  Git
    -- ["<leader>gG"] = { name = "Gitsigns" },
    ["<leader>gS"] = { name = "Stash" },
    ["<leader>gd"] = { name = "Diff" },
    ["<leader>gc"] = { name = "checkout" },
    ["<leader>gt"] = { name = "Telescope" },
    ["<leader>gh"] = { name = "Hunk" },
    ["<leader>gr"] = { name = "Reset" },

    ["<leader>c"] = { name = "+Code" },
    ["<leader>cN"] = {
      cmd = ":split term://$SHELL<cr>",
      desc = "new terminal",
    },
    -- alt+a -> æ
    ["æ"] = {
      cmd = ":lua require('utils.cht').cht()<CR>",
      desc = "Cheat Local",
    },
    -- alt+\ -> º
    ["º"] = {
      cmd = ":lua require('utils.cht2').cht()<CR>",
      desc = "Cheat remote",
    },

    ["<leader>cR"] = {
      cmd = ":split term://R<cr>",
      desc = "new R terminal",
    },
    ["<leader>cJ"] = {
      cmd = ":split term://julia<cr>",
      desc = "new Julia terminal",
    },
    ["<leader>cs"] = {
      cmd = ':lua require("config.repl").set_job_id()<cr>',
      desc = "set terminal",
    },
    ["<leader>m"] = { name = "+Math" },
    ["<leader>mm"] = {
      cmd = ':lua require("libuv.my_programs").startup()<cr>',
      desc = "set terminal",
    },
    ["<leader>mj"] = {
      cmd = ':lua require("libuv.jupyter").startup()<cr>',
      desc = "Jupyter",
    },
  },
}

local wk = require "which-key"
wk.setup(opts)
wk.register(opts.defaults)
