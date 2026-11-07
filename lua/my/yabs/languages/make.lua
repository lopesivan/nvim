local app = require("my.neovim_dev").app

return {
    tasks = {
        bear = {
            command = function()
                app("/bin/bear", { "--", "make" })
            end,
            type = "lua",
            desc = "bear -- make",
            opts = { open_on_run = "always" },
        },
    },
}
