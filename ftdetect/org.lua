vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.org_archive" ,"*.org" },
callback = function()
   vim.bo.filetype = "org"
end,
})
