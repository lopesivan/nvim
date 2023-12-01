if not require("config").pde.cmp then
  return {}
end

if not require("config").pde.cpp then
  -- without clang
  return {
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "lopesivan/cmp-jptemplate",
        "hrsh7th/cmp-path",
        "lopesivan/nvim-jptemplate",
        "quangnguyen30192/cmp-nvim-ultisnips",
      },
      opts = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
        local compare = require "cmp.config.compare"
        local source_names = {
          nvim_lsp = "(LSP)",
          luasnip = "(LuaSnip)",
          ultisnips = "(Ult)",
          buffer = "(Buffer)",
          path = "(Path)",
          jptemplate = "[JP]",
        }
        local duplicates = {
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
          luasnip = 1,
        }

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

        return {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          sorting = {
            priority_weight = 2,
            comparators = {
              compare.score,
              compare.recently_used,
              compare.offset,
              compare.exact,
              compare.kind,
              compare.sort_text,
              compare.length,
              compare.order,
            },
          },
          snippet = {
            expand = function(args)
              -- Verifica se Luasnip pode expandir algum snippet no momento.
              if require("luasnip").expand_or_jumpable() then
                require("luasnip").lsp_expand(args.body)
              -- Verifica se UltiSnips tem um snippet para expandir.
              elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                vim.fn["UltiSnips#Anon"](args.body)
              -- vim.fn["UltiSnips#ExpandSnippet"]()
              else
                -- Se nenhum dos dois puder expandir, use a expansão padrão do `nvim-cmp`.
                -- require("cmp").snippet.expand(args)
                require("luasnip").lsp_expand(args.body)
              end
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping {
              i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
              c = function(fallback)
                if cmp.visible() then
                  cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                else
                  fallback()
                end
              end,
            },
            ["<C-j>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.api.nvim_get_mode().mode == "s" then
                fallback()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif cmp_ultisnips_mappings.expand_or_jump_forwards(fallback) then
              -- UltiSnips handling is inside this function.
              -- It will only return true and expand/jump if UltiSnips can actually expand/jump forward.
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<C-k>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.api.nvim_get_mode().mode == "s" then
                fallback()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              elseif cmp_ultisnips_mappings.jump_backwards(fallback) then
              -- Nada a fazer aqui, a função 'jump_backwards' cuida do salto para trás do UltiSnips.
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<F2>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<F3>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s", "c" }),
          },
          sources = cmp.config.sources {
            { name = "nvim_lsp", group_index = 1, keyword_length = 3 },
            { name = "luasnip", group_index = 1, keyword_length = 2 },
            { name = "ultisnips", group_index = 1, keyword_length = 3 },
            -- { name = "emmet_ls" }, -- Adicionar isso
            {
              name = "buffer",
              group_index = 2,
              keyword_length = 3,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
            { name = "path", group_index = 2, keyword_length = 3 },
            { name = "jptemplate", keyword_length = 3 },
          },

          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, item)
              local duplicates_default = 0
              item.menu = source_names[entry.source.name]
              item.dup = duplicates[entry.source.name] or duplicates_default
              return item
            end,
          },

          experimental = {
            hl_group = "LspCodeLens",
            ghost_text = {},
          },
          window = {
            documentation = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
            },
          },
        }
      end,
    },

    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            -- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.fn.stdpath "config" .. "/snippets/" }
            local snippets_folder = vim.fn.stdpath "config" .. "/LuaSnip"
            require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder }
          end,
        },
        {
          "honza/vim-snippets",
          config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()

            -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
            -- are stored in `ls.snippets._`.
            -- We need to tell luasnip that "_" contains global snippets:
            require("luasnip").filetype_extend("all", { "_" })
          end,
        },
      },
      build = "make install_jsregexp",
      opts = {
        history = true,
        delete_check_events = "TextChanged",
      },
      config = function(_, opts)
        require("luasnip").setup(opts)
      end,
    },
  }
else
  -- with clang
  return {
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "lopesivan/cmp-jptemplate",
        "hrsh7th/cmp-path",
        "lopesivan/nvim-jptemplate",
        "quangnguyen30192/cmp-nvim-ultisnips",
      },
      opts = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
        local compare = require "cmp.config.compare"
        local source_names = {
          nvim_lsp = "(LSP)",
          luasnip = "(LuaSnip)",
          ultisnips = "(Ult)",
          buffer = "(Buffer)",
          path = "(Path)",
          jptemplate = "[JP]",
        }
        local duplicates = {
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
          luasnip = 1,
        }

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

        return {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          sorting = {
            priority_weight = 2,
            comparators = {
              compare.score,
              compare.recently_used,
              require "clangd_extensions.cmp_scores",
              compare.offset,
              compare.exact,
              compare.kind,
              compare.sort_text,
              compare.length,
              compare.order,
            },
          },
          snippet = {
            expand = function(args)
              -- Verifica se Luasnip pode expandir algum snippet no momento.
              if require("luasnip").expand_or_jumpable() then
                require("luasnip").lsp_expand(args.body)
              -- Verifica se UltiSnips tem um snippet para expandir.
              elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                vim.fn["UltiSnips#Anon"](args.body)
              -- vim.fn["UltiSnips#ExpandSnippet"]()
              else
                -- Se nenhum dos dois puder expandir, use a expansão padrão do `nvim-cmp`.
                -- require("cmp").snippet.expand(args)
                require("luasnip").lsp_expand(args.body)
              end
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping {
              i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
              c = function(fallback)
                if cmp.visible() then
                  cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                else
                  fallback()
                end
              end,
            },
            ["<C-j>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.api.nvim_get_mode().mode == "s" then
                fallback()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif cmp_ultisnips_mappings.expand_or_jump_forwards(fallback) then
              -- UltiSnips handling is inside this function.
              -- It will only return true and expand/jump if UltiSnips can actually expand/jump forward.
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<C-k>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.api.nvim_get_mode().mode == "s" then
                fallback()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              elseif cmp_ultisnips_mappings.jump_backwards(fallback) then
              -- Nada a fazer aqui, a função 'jump_backwards' cuida do salto para trás do UltiSnips.
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<F2>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s", "c" }),
            ["<F3>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s", "c" }),
          },
          sources = cmp.config.sources {
            { name = "nvim_lsp", group_index = 1, keyword_length = 3 },
            { name = "luasnip", group_index = 1, keyword_length = 2 },
            { name = "ultisnips", group_index = 1, keyword_length = 3 },
            -- { name = "emmet_ls" }, -- Adicionar isso
            {
              name = "buffer",
              group_index = 2,
              keyword_length = 3,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
            { name = "path", group_index = 2, keyword_length = 3 },
            { name = "jptemplate", keyword_length = 3 },
          },

          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, item)
              local duplicates_default = 0
              item.menu = source_names[entry.source.name]
              item.dup = duplicates[entry.source.name] or duplicates_default
              return item
            end,
          },

          experimental = {
            hl_group = "LspCodeLens",
            ghost_text = {},
          },
          window = {
            documentation = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
            },
          },
        }
      end,
    },

    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            -- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.fn.stdpath "config" .. "/snippets/" }
            local snippets_folder = vim.fn.stdpath "config" .. "/LuaSnip"
            require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder }
          end,
        },
        {
          "honza/vim-snippets",
          config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()

            -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
            -- are stored in `ls.snippets._`.
            -- We need to tell luasnip that "_" contains global snippets:
            require("luasnip").filetype_extend("all", { "_" })
          end,
        },
      },
      build = "make install_jsregexp",
      opts = {
        history = true,
        delete_check_events = "TextChanged",
      },
      config = function(_, opts)
        require("luasnip").setup(opts)
      end,
    },
  }
end
