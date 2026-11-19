local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

return h.make_builtin({
  name = "astyle",

  meta = {
    url = "https://astyle.sourceforge.net/",
    description = "Artistic Style formatter",
  },

  method = methods.internal.FORMATTING,

  filetypes = {
    "arduino",
    "c",
    "cpp",
    "cs",
    "java",
  },

  condition = function(params)
    local dir = vim.fn.fnamemodify(params.bufname, ":h")

    return vim.uv.fs_stat(dir .. "/.astylerc")
      or vim.uv.fs_stat(dir .. "/astyle.cfg")
  end,

  generator_opts = {
    command = "astyle",

    args = function(params)
      local dir = vim.fn.fnamemodify(params.bufname, ":h")

      if vim.uv.fs_stat(dir .. "/.astylerc") then
        return {
          "--quiet",
          "--options=" .. dir .. "/.astylerc",
        }
      end

      if vim.uv.fs_stat(dir .. "/astyle.cfg") then
        return {
          "--quiet",
          "--options=" .. dir .. "/astyle.cfg",
        }
      end

      return { "--quiet" }
    end,

    to_stdin = true,
    ignore_stderr = true,
  },

  factory = h.formatter_factory,
})
