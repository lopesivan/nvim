vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { ".tasks" },
callback = function()
   vim.bo.filetype = "tasks"
end,
})
