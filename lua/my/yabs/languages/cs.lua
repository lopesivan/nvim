return {
    tasks = {
        ["dotnet build"] = {
            command = "dotnet build",
            output = "quickfix",
            condition = require("yabs.conditions").file_exists("*.csproj"),
            opts = { open_on_run = "always" },
        },

        ["dotnet run"] = {
            command = "dotnet run",
            output = "quickfix",
            condition = require("yabs.conditions").file_exists("*.csproj"),
            opts = { open_on_run = "always" },
        },

        mono_mcs = {
            command = "mcs %",
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        mono_csc = {
            command = "csc %",
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        mono_run = {
            command = "mono " .. vim.fn.expand("%:p:r") .. ".exe",
            output = "quickfix",
            opts = { open_on_run = "always" },
        },

        remove = {
            command = "rm " .. vim.fn.expand("%:p:r") .. ".exe",
            output = "quickfix",
            opts = { open_on_run = "always" },
        },
    },
}
