return {
  name = "bash run",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"
    return {
      cmd = { "/usr/local/bin/bash" },
      args = { file },
      components = { { "on_output_quickfix", open = true }, "default" },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "sh" },
  },
}

-- cmd is the only required field
-- cmd = {'echo'},
-- additional arguments for the cmd
-- args = {"hello", "world"},
-- the name of the task (defaults to the cmd of the task)
-- name = "Greet",
-- set the working directory for the task
-- cwd = "/tmp",
-- additional environment variables
-- env = {
-- VAR = "FOO",
-- },
