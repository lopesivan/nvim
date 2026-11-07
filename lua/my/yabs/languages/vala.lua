local util = require("my.yabs.util")
local deploy_main = util.deploy_main

return {
    tasks = {
        c = {
            command = "valac -C " .. vim.fn.expand("%"),
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        bin = {
            command = "valac " .. vim.fn.expand("%"),
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        remove = {
            command = function()
                local bin = "./" .. vim.fn.expand("%<")
                deploy_main("cmd", ("rm %s"):format(bin))
            end,
            type = "lua",
        },

        run = {
            command = vim.fn.expand("%:p:r"),
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        build = {
            command = function()
                local src = vim.fn.expand("%")
                local bin = vim.fn.expand("%<")
                deploy_main("cmd", ("valac -c %s, ./%s"):format(src, bin))
            end,
            type = "lua",
            desc = "Compile com gcc",
        },

        compile_source = {
            command = function()
                local src = vim.fn.expand("%")
                local name = vim.fn.expand("%<")
                local run = "./" .. name
                local includes = "-I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include"
                local libs = "-lgobject-2.0 -lglib-2.0"
                local gen = ("valac --ccode %s"):format(src)
                local compile = ("gcc -o %s %s.c %s %s"):format(name, name, includes, libs)
                deploy_main("cmd", table.concat({ gen, compile, run }, ","))
            end,
            type = "lua",
        },
    },
}
