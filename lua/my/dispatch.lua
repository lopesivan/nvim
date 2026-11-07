-- /home/ivan/.config/nvim-ide/neovim-pde/lua/config/dispatch.lua
local M = {}
local nmap = require("my.kmap").nmap

function M.nmap(tbl, opts)
  opts = opts or {}
  nmap({
    tbl[1],
    function()
      local key = tbl[2]
      local query_result = vim.fn["projectionist#query_exec"](key)[1]

      print("DEBUG tbl[1]: " .. tbl[1])
      print("DEBUG tbl[2]: " .. tbl[2])
      if query_result ~= nil then
        local projectionist_heuristics = {
          ["start"] = "Start",
          ["make"] = "Make",
          ["dispatch"] = "Dispatch",
        }
        local cmd = projectionist_heuristics[tbl[2]]
        if not cmd then
          cmd = query_result[2]
        end
        if tbl[2]:find("^yabs") ~= nil then
          vim.api.nvim_command("write")
          require("yabs"):run_task(cmd)
        else
          vim.cmd(([[%s]]):format(cmd))
        end
      else
        print("No *" .. tbl[3] .. "* command found")
      end
    end,
    vim.tbl_extend("force", { desc = tbl[4] }, opts),
  })
end

return M
