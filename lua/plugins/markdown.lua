return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-mini/mini.nvim",
    },
    opts = {
      code = {
        style = "full",
        width = "full", -- pinta a linha inteira, não só o texto
        highlight = "RenderMarkdownCode",
      },
    },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
