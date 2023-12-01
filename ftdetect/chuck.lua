-- chuck.lua - chuck
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/ftdetect

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.ck" },
callback = function()
   vim.bo.filetype = "chuck"
end,
})
-- vim: fdm=marker:sw=4:sts=4:et
