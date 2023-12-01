-- xml.lua - xml
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/ftdetect

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.xml", "*.csproj" },
callback = function()
   vim.bo.filetype = "xml"
end,
})
-- vim: fdm=marker:sw=4:sts=4:et
