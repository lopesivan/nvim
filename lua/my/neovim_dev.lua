-- neovim_dev.lua

local JobRunner = require("my.job_runner")

local M = {}

M.sh = function(args)
  JobRunner:new("bash", args):start()
end

M.make = function(args)
  JobRunner:new("make", args):start()
end

M.run = function(command, args)
  local parsed = require("my.dotenv").parse_plugin_env()
  if not parsed.ANTHROPIC_TOKEN then
    print("nao tem")
  else
    print("temmmm")
  end

  JobRunner:new("./" .. command, args):start()
end

M.app = function(command, args)
  local parsed = require("my.dotenv").parse_plugin_env()
  --[[ TEST:
# arquivo: exemplo.py
import sys

def main():
    print("Número de argumentos:", len(sys.argv))

    print("Lista completa (argv):")
    for i, arg in enumerate(sys.argv):
        print(f"argv[{i}] = {arg}")

    print("\nArgumentos (ignorando o nome do script):")
    for arg in sys.argv[1:]:
        print(arg)

if __name__ == "__main__":
    main()

###################################################################

#include <stdio.h>

int main(int argc, char *argv[]) {
  printf("Numero de argumentos: %d\n\n", argc);

  for (int i = 0; i < argc; i++) {
    printf("argv[%d] = %s\n", i, argv[i]);
  }

  return 0;
}
]]
  args = args or {}
  -- Como usar ?
  -- basta definir a variável APP_ARGS no arquivo .env com os argunebros do
  -- seu programa.
  if parsed.APP_ARGS and parsed.APP_ARGS ~= "" then
    local extra_args = vim.split(vim.trim(parsed.APP_ARGS), "%s+")

    vim.list_extend(args, extra_args)
  else
    print("APP_ARGS não foi definido em .env")
  end

  -- dotnet new console -o myapp
  -- dotnet  build
  -- ls bin/Debug/net8.0/
  -- cs.lua -> ./dotnet.lua
  if command == "dotnet_run_debug" then
    local cwd = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(cwd, ":t") -- pega o nome da pasta atual
    local binary_path = string.format("bin/Debug/net10.0/%s", project_name)
    command = binary_path
    args = {}
  end

  JobRunner:new(command, args):start()
end

M.applog = function(command, args, logfile)
  JobRunner:new(command, args, logfile):start()
end

return M
