local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

local JAVA_HOME = "/home/ivan/.config/env/jenv/versions/21"

return h.make_builtin({
  name = "ktlint",

  meta = {
    url = "https://pinterest.github.io/ktlint/",
    description = "Formats Kotlin code using ktlint and .editorconfig.",
  },

  method = FORMATTING,

  filetypes = { "kotlin" },

  generator_opts = {
    command = "/home/ivan/.local/share/nvim-pde/mason/bin/ktlint",

    args = {
      "--format",
      "--stdin",
      "--log-level=error",
    },

    to_stdin = true,

    from_stderr = false,
    ignore_stderr = true,

    env = {
      JAVA_HOME = JAVA_HOME,
      PATH = JAVA_HOME .. "/bin:" .. vim.env.PATH,
    },
  },

  factory = h.formatter_factory,
})
