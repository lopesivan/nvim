local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "kotlin_allman",

    meta = {
        description = "Kotlin formatter using Allman-style braces",
    },

    method = FORMATTING,

    filetypes = {
        "kotlin",
    },

    generator_opts = {
        command = vim.fn.expand("~/.local/bin/kotlin-allman"),

        args = {},

        to_stdin = true,
    },

    factory = h.formatter_factory,
})
