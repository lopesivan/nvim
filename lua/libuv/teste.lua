-- programa em lua
local uv = vim.loop

local close_handle = function(handle)
  if handle and not handle:is_closing() then handle:close() end
end

local buf_to_stdin = function(cmd, args, handler)
  local output = ""
  local stderr_output = ""

  local handle_stdout = vim.schedule_wrap(
	function(err, chunk)
	  if err then
		  error("stdout error: " .. err)
	  end

	  if chunk then
		output = output .. chunk
	  end

	  if not chunk then
		handler(stderr_output ~= "" and stderr_output or nil, output)
	  end
	end
  )

  local handle_stderr = function(err, chunk)
	if err then
	  error("stderr error: " .. err)
	end

	if chunk then
	  stderr_output = stderr_output .. chunk
	end
  end

  local stdin = uv.new_pipe(true)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local stdio = {stdin, stdout, stderr}

  local handle = uv.spawn(
	cmd,
	{args = args, stdio = stdio},
	function()
	  stdout:read_stop()
	  stderr:read_stop()

	  close_handle(stdin)
	  close_handle(stdout)
	  close_handle(stderr)
	  close_handle(handle)
	end
  )

	uv.read_start(stdout, handle_stdout)
	uv.read_start(stderr, handle_stderr)

  -- specific implementation is probably irrelevant, since this part is
  -- working OK
  stdin:write(buffer_to_string(), function() stdin:close() end)
end
