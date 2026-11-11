-- noice.lua
return {
  "folke/noice.nvim",
  enabled = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  event = "VeryLazy",
  -- enabled = true,
  lazy = false,

  -- config = function()
  --     vim.keymap.set("i", "<M-c>", function()
  --         local nldocs = require("noice.lsp.docs")
  --         local message = nldocs.get("signature")
  --         nldocs.hide(message)
  --     end)
  -- end,

  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },

    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      },
    },
    -- routes = {
    --     {
    --         filter = {
    --             event = "msg_show",
    --             find = "%d+L, %d+B",
    --         },
    --         view = "mini",
    --     },
    -- },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
    },
  },
  keys = {
    {
      "<c-q>",
      "<cmd>Noice dismiss<CR>",
      desc = "Fechar mensagens do Noice",
    },
  },
  --[[
        config = function(_, opts)
            require("noice").setup(opts)

            -- Integra o signature_help com o noice
            vim.lsp.handlers["textDocument/signatureHelp"] = require("noice.lsp").signature
        end,
]]
}
