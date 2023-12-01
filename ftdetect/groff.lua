vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.ms" ,"*.groff" },
callback = function()
   vim.bo.filetype = "groff"
   vim.bo.syntax="nroff"
end,
})
