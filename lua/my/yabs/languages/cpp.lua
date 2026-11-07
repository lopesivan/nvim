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
                require("yabs").languages.c:run_task("run")
            end,
            desc = "./" .. vim.fn.expand("%<"),
            type = "lua",
        },

        build = {
            command = function()
                require("yabs").languages.c:run_task("build")
            end,
            desc = cc_desc
                or ("gcc -c -o %s %s"):format(
                    vim.fn.expand("%<"),
                    vim.fn.expand("%")
                ),
            type = "lua",
        },
    },
}
