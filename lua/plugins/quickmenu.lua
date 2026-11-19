-- ~/.config/nvim/lua/plugins/quickmenu.lua
return {
  "skywind3000/quickmenu.vim",
  lazy = false,
  init = function()
    vim.g.quickmenu_options = "HL" -- H: horizontal, L: mostra a linha de status
  end,
}
