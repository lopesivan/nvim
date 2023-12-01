return {
        {
            "folke/todo-comments.nvim",
            event = "VeryLazy",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                }
            end,
        }
}
    -- PERF: fully optimised
    -- HACK: hmmm, this looks a bit funky
    -- TODO: What else?
    -- NOTE: adding a note
    -- FIX: this needs fixing
    -- WARNING: ???
    -- FIX: ddddd
    -- todo: fooo
    -- @TODO foobar
    -- @hack foobar
