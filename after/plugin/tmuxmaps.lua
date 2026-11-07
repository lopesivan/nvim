local function tmux_or_split_switch(wincmd, tmuxdir)
  if vim.env.TMUX then
    local previous_winnr = vim.fn.winnr()
    vim.cmd("wincmd " .. wincmd)
    if previous_winnr == vim.fn.winnr() then
      vim.fn.system("sleep 0.01; tmux select-pane -" .. tmuxdir)
      vim.cmd("redraw!")
    end
  else
    local map = { D = "j", U = "k", R = "l", L = "h" }
    vim.cmd("normal! <C-w>" .. map[tmuxdir])
  end
end

local opts = { silent = true }
vim.keymap.set("n", "<M-down>", function()
  tmux_or_split_switch("j", "D")
end, opts)
vim.keymap.set("n", "<M-up>", function()
  tmux_or_split_switch("k", "U")
end, opts)
vim.keymap.set("n", "<M-left>", function()
  tmux_or_split_switch("l", "R")
end, opts) -- trocado
vim.keymap.set("n", "<M-right>", function()
  tmux_or_split_switch("h", "L")
end, opts) -- trocado
