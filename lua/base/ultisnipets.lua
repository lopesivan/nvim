return {
  {
    "SirVer/ultisnips",
    lazy = false,
    init = function()
      -- vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
      -- vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
      -- vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
      -- vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
      -- vim.g["UltiSnipsExpandTrigger"] = "<S-Tab>"
      vim.g.UltiSnipsExpandTrigger = "<c-a>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-.>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-,>"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
      vim.g.UltiSnipsEditSplit = "vertical"
    end,
    dependencies = {
      -- "honza/vim-snippets",
      -- CMP
      {
        "lopesivan/vim-pythonx",
        build = function()
          vim.cmd [[UpdateRemotePlugins]]
        end,
      },
      -- {
      --   "quangnguyen30192/cmp-nvim-ultisnips",
      --   opts = {
      --     filetype_source = "treesitter",
      --     show_snippets = "all",
      --     documentation = function(snippet)
      --       return snippet.description
      --     end,
      --   },
      -- },
    },
  },
}
