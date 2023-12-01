local M = {}

function M.setup()
    require("translate").setup {
        defalut = {
            command = "translate_shell",
            output = "floating",
        },
        preset = {
            output = {
                insert = {
                    base = "top",
                    off = -1,
                },
            },
        },
    }
end

return M
