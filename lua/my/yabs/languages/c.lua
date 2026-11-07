local util = require("my.yabs.util")
local console = util.console
local process_env = util.process_environment_commands

local cc_desc = nil
if util.get_env_command then
    cc_desc = util.get_env_command("CC")
end

return {
    tasks = {
        run = {
            command = function()
                local name = vim.fn.expand("%<")
                console.exec(("./%s"):format(name))
            end,
            desc = "./" .. vim.fn.expand("%<"),
            type = "lua",
        },

        build = {
            command = function()
                process_env({ "CC" })
            end,

            desc = cc_desc
                or ("gcc -c -o %s %s"):format(
                    vim.fn.expand("%<"),
                    vim.fn.expand("%")
                ),
            type = "lua",
        },

        deploy = {
            command = function()
                process_env({ "CC", "LD", "BIN" })
            end,
            desc = "Build and Run",
            type = "lua",
        },
    },
}
