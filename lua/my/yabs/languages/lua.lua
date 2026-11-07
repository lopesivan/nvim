return {
    tasks = {
        run = {
            command = "luafile %",
            type = "vim",
            output = "quickfix",
            opts = { open_on_run = "always" },
            desc = "roda arquivo lua usando o luafile do NVIM",
        },
    },
}
