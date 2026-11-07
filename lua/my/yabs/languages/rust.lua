local function app(args)
    require("my.nvim_dev").app("cargo", args)
end

local function split_args(input)
    local result = {}
    for word in input:gmatch("%S+") do
        table.insert(result, word)
    end
    return result
end

return {
    tasks = {
        run = {
            command = function()
                local input = vim.fn.input("Args (cargo run): ")
                local args = { "run" }

                if input ~= "" then
                    table.insert(args, "--")
                    vim.list_extend(args, split_args(input))
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
        },

        build = {
            command = function()
                app({ "build" })
            end,
            type = "lua",
            output = "quickfix",
            desc = "⚪⚪⚪ Compila DEBUG",
        },

        release = {
            command = function()
                app({ "build", "--release" })
            end,
            type = "lua",
            output = "quickfix",
            desc = "🟢🟢🟢 Compila RELEASE",
        },

        clean = {
            command = function()
                app({ "clean" })
            end,
            type = "lua",
            output = "quickfix",
            desc = "♻️ Remove target/",
        },

        init = {
            command = function()
                local name = vim.fn.input("Nome do projeto (init): ")
                if name == "" then return end

                local kind = vim.fn.input("Tipo [bin/lib] (default bin): ")
                local args = { "init", name }

                if kind == "lib" then
                    table.insert(args, "--lib")
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
            desc = "💡 Inicializa projeto Rust no diretório",
        },

        new = {
            command = function()
                local name = vim.fn.input("Nome do projeto: ")
                if name == "" then return end

                local kind = vim.fn.input("Tipo [bin/lib] (default bin): ")
                local args = { "new", name }

                if kind == "lib" then
                    table.insert(args, "--lib")
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
            desc = "📦 Cria novo projeto Rust",
        },

        add = {
            command = function()
                local dep = vim.fn.input("Dependência (ex: serde): ")
                if dep == "" then return end

                local extra = vim.fn.input("Extras (ex: --features derive): ")

                local args = { "add", dep }

                if extra ~= "" then
                    vim.list_extend(args, split_args(extra))
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
            desc = "➕ Adiciona dependência",
        },

        test = {
            command = function()
                local input = vim.fn.input("Args (cargo test): ")
                local args = { "test" }

                if input ~= "" then
                    vim.list_extend(args, split_args(input))
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
        },

        doc = {
            command = function()
                local open = vim.fn.input("Abrir docs? [y/N]: ")
                local args = { "doc" }

                if open:lower() == "y" then
                    table.insert(args, "--open")
                end

                app(args)
            end,
            type = "lua",
            output = "quickfix",
            desc = "📚 Gera documentação",
        },

        install = {
            command = function()
                local crate = vim.fn.input("Crate para instalar: ")
                if crate == "" then return end

                app({ "install", crate })
            end,
            type = "lua",
            output = "quickfix",
        },

        uninstall = {
            command = function()
                local crate = vim.fn.input("Crate para remover: ")
                if crate == "" then return end

                app({ "uninstall", crate })
            end,
            type = "lua",
            output = "quickfix",
        },
    },
}
