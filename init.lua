require "config.globals"
require "config.options"
require "config.lazy"
require "config.neovide"
require "config.luarocks"
require "config.filetype"
-- require "config.nvim_dev"

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("NeovimPDE", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require "config.autocmds"
      require "config.keymaps"
    end,
  })
else
  require "config.autocmds"
  require "config.keymaps"
end
