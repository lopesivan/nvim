local sh = require("my.neovim_dev").sh
local file_exists = require("yabs.conditions").file_exists

return {
    ["bash ./autogen.sh"] = {
        command = function()
            sh({ "./autogen.sh" })
        end,
        opts = { open_on_run = "always" },
        condition = file_exists("autogen.sh"),
        type = "lua",
    },
}
