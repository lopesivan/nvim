-- incline.lua
return {
  "b0o/incline.nvim",
  dependencies = {
    {
      "craftzdog/solarized-osaka.nvim",
      lazy = false,
      priority = 1000,
    },
    "nvim-tree/nvim-web-devicons",
  },
  event = "BufReadPre",
  priority = 1200,
  config = function()
    local ok, osaka = pcall(require, "solarized-osaka.colors")
    if not ok then
      vim.notify(
        "solarized-osaka.colors não encontrado",
        vim.log.levels.WARN
      )
      return
    end
    local colors = osaka.setup()

    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = {
            guibg = colors.magenta500,
            guifg = colors.base04,
          },
          InclineNormalNC = {
            guifg = colors.violet500,
            guibg = colors.base03,
          },
        },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename =
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end

        local icon, color =
          require("nvim-web-devicons").get_icon_color(filename)
        return { { icon, guifg = color }, { " " }, { filename } }
      end,
    })
  end,
}
