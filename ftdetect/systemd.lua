vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.service" },
callback = function()
   vim.bo.filetype = "systemd"
end,
})
