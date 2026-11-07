return {
    tasks = {
        run = {
            command = "julia %",
            output = "terminal",
            opts = { open_on_run = "never" },
        },

        test = {
            command = "julia -e 'using Pkg; Pkg.test()'",
            output = "terminal",
            opts = { open_on_run = "auto" },
        },
    },
}
