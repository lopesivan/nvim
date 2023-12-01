local M = {}

function M.setup()
  local function get_task_callback(i)
    return function()
      local tasks = require("overseer").list_tasks { recent_first = true }
      local task = tasks[i]
      if task then
        require("overseer").run_action(task)
      end
    end
  end

  -- lua for _,v in pairs(require("overseer").list_tasks({ recent_first = true })) do print(vim.inspect(#v['cmd'])) end
  for i = 1, 4 do
    vim.keymap.set("n", "<leader>ttm" .. i, get_task_callback(i), { desc = string.format("Run an action on task #%d", i) })
  end
end

return M
