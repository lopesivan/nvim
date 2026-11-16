return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local conform = require("conform")

    local indent = 4       -- largura da tabulação
    local use_tabs = false -- true = usa TAB real

    -- mantém o editor igual ao formatador
    vim.opt.shiftwidth = indent
    vim.opt.tabstop = indent
    vim.opt.softtabstop = indent
    vim.opt.expandtab = not use_tabs

    local n = tostring(indent)

 conform.setup({
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        graphql = { "prettier" },
        markdown = { "prettier" },

        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        glsl = { "clang-format" },
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        cmake = { "cmake_format" },
        xml = { "xmlformat" },
        toml = { "taplo" },
        ["_"] = { "trim_whitespace" },
      },

      formatters = {
        prettier = {
          prepend_args = use_tabs
              and { "--use-tabs", "--tab-width", n }
              or { "--tab-width", n },
        },
        stylua = {
          prepend_args = {
            "--indent-type", use_tabs and "Tabs" or "Spaces",
            "--indent-width", n,
          },
        },
        ["clang-format"] = {
          prepend_args = {
            string.format(
              "--style={BasedOnStyle: LLVM, IndentWidth: %d, TabWidth: %d, UseTab: %s}",
              indent, indent, use_tabs and "Always" or "Never"
            ),
          },
        },
        shfmt = {
          prepend_args = { "-i", use_tabs and "0" or n },
        },
        rustfmt = {
          prepend_args = {
            "--config", string.format("tab_spaces=%d,hard_tabs=%s", indent, tostring(use_tabs)),
          },
        },
        ruff_format = {
          prepend_args = {
            "--config", string.format("indent-width = %d", indent),
          },
        },
        cmake_format = {
          prepend_args = { "--tab-size", n },
        },
        xmlformat = {
          prepend_args = { "--indent", n },
        },
        taplo = {
          prepend_args = {
            "--option", string.format('indent_string=%s', use_tabs and "\t" or string.rep(" ", indent)),
          },
        },
        ["google-java-format"] = {
          -- fixo em 2 espaços; "--aosp" = 4 espaços
          prepend_args = indent == 4 and { "--aosp" } or {},
        },
      },

      default_format_opts = { lsp_format = "fallback" },
      format_on_save = false,
    })

    vim.keymap.set({ "n", "v" }, "ff", function()
      conform.format({ async = true, timeout_ms = 3000 })
    end, { desc = "Format" })
  end,
}
