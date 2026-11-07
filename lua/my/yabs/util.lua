-- ~/.config/nvim/lua/config/yabs/util.lua
local M = {}

local function require_module(name, level)
    local ok, mod = pcall(require, name)
    if not ok then
        vim.notify(("module not found: %s"):format(name), level or vim.log.levels.ERROR)
        return nil
    end
    return mod
end

local console = require_module("my.console", vim.log.levels.WARN)
    or {
        exec = function(cmd)
            vim.fn.jobstart(cmd, { detach = true })
        end,
    }

local List = require_module("harpoon.list")
local Config = require_module("harpoon.config")

-- merge de config do Harpoon (igual ao seu arquivo)
local harpoon_cfg = Config
    and Config.merge_config({
        cmd = {
            decode = function(item)
                local parts = vim.split(vim.trim(item:gsub("%s+", " ")), ",")
                return { value = parts, context = nil }
            end,
            display = function(item)
                return table.concat(item.value, " && ")
            end,
        },
        cmd_build = {
            decode = function(item)
                local parts = vim.split(vim.trim(item:gsub("%s+", " ")), ",")
                return { value = parts, context = nil }
            end,
            display = function(item)
                return table.concat(item.value, "\r")
            end,
        },
    })
    or {}

-- console:run para cada comando decodificado
function M.deploy_main(model, commands)
    if not (Config and List) then
        vim.notify("Harpoon (config/list) não disponível", vim.log.levels.ERROR)
        return
    end
    local list_cfg = Config.get_config(harpoon_cfg, model)
    local list = List.decode(list_cfg, "build", { commands })
    for _, cmd in ipairs(list:display()) do
        console.exec(cmd)
    end
end

-- helpers gerais -------------------------------------------------------------

function M.capture_command_output(command)
    local out = vim.fn.system(command)
    if vim.v.shell_error ~= 0 then
        print("Erro ao executar:", out)
        return nil
    end
    return out:gsub("\n", "")
end

function M.is_git_repo()
    return vim.fs.find(".git", { upward = true })[1] ~= nil
end

-- Projectionist --------------------------------------------------------------

local function projectionist_query(key)
    local ok, res = pcall(function()
        return vim.fn["projectionist#query_exec"](key)
    end)
    if not ok or not res or not res[1] then
        vim.notify("Projectionist: sem resultado para " .. key, vim.log.levels.ERROR)
        return nil
    end
    return res[1][2]
end

function M.execute_commands_from_projectionist(keys)
    local cmd = ""
    for _, k in ipairs(keys) do
        local r = projectionist_query(k)
        if r then
            cmd = (cmd ~= "" and (cmd .. ", " .. r) or r)
        end
    end
    if cmd ~= "" then
        M.deploy_main("cmd", cmd)
    end
end

-- Dotenv / .env --------------------------------------------------------------

function M.get_env_command(name)
    local ok, dot = pcall(require, "my.dotenv")

    if not ok or not dot.parse_plugin_env then
        return nil
    end

    local parsed = dot.parse_plugin_env()

    local value = parsed[name]

    if not value or value == "" then
        return nil
    end

    value = value:gsub("{file}", vim.fn.expand("%"))
    value = value:gsub("%{}", vim.fn.expand("%<"))

    return value
end

local function ensure_dotenv_loaded()
    local dotenv = require_module("dotenv", vim.log.levels.INFO)
    if dotenv and vim.env then
        dotenv.autocmd()
    end
end

-- Lê VAR do ambiente (carrega .env se existir) e extrai conteúdo entre { ... }
function M.load_commands_from_env(model, name)
    local files = vim.fs.find(".env", { upward = true, type = "file" })
    if #files == 0 then
        vim.notify(".env não encontrado", vim.log.levels.WARN)
        return
    end

    local var = string.upper(name)
    if not vim.env[var] then
        ensure_dotenv_loaded()
    end
    local value = vim.env[var]
    if not value or value == "" then
        vim.notify(var .. ": não definido no .env", vim.log.levels.INFO)
        return
    end

    -- CORREÇÃO: parsing seguro de { ... }
    local s = value:find("{")
    local e = value:find("}")
    local inner = (s and e and s < e) and value:sub(s + 1, e - 1) or value

    M.deploy_main(model, inner)
end

-- Usa config.dotenv.parse_plugin_env() para CC/LD/BIN etc.
function M.process_env_variables(keys)
    local ok, dot = pcall(require, "my.dotenv")
    if not ok or not dot.parse_plugin_env then
        -- fallback: chama projectionist se não houver parse
        return M.execute_commands_from_projectionist(keys)
    end

    local parsed = dot.parse_plugin_env()
    local command = ""
    if parsed.CC then
        command = parsed.CC
    end
    if parsed.LD then
        command = command ~= "" and (command .. ", " .. parsed.LD) or parsed.LD
    end

    command = command:gsub("{file}", vim.fn.expand("%"))
    command = command:gsub("%{}", vim.fn.expand("%<"))

    if command ~= "" then
        M.deploy_main("cmd", command)
    end
end

function M.process_environment_commands(keys)
    vim.cmd("write")
    local files = vim.fs.find(".env", { upward = true, type = "file" })
    if #files == 0 then
        M.execute_commands_from_projectionist(keys)
    else
        M.process_env_variables(keys)
    end
end

-- exporta também o console se você precisar em languages
M.console = console

return M
