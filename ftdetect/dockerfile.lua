vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "Dockerfile" ,"*.dockerfile" ,"*.docker" },
callback = function()
   vim.bo.filetype = "dockerfile"
end,
})
