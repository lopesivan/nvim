local util = require("my.yabs.util")
local from_proj = util.execute_commands_from_projectionist

return {
    tasks = {
        build = {
            command = function()
                from_proj({ "kotlinc", "java" })
            end,
            type = "lua",
        },
    },
}
