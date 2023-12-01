-- programa em lua
local uv = vim.loop

local stdin = uv.new_pipe(false)
local stdout = uv.new_pipe(false)
local stderr = uv.new_pipe(false)

local handle = uv.spawn("gcc", {
  args = { '-v' },
  stdio = { stdin, stdout, stderr }
}, function() end)

uv.read_start(stdout, function(err, data)
  assert(not err, err)
  if data then
    print(vim.inspect(data))
  end
end)

uv.read_start(stderr, function() end)

uv.shutdown(stdin, function()
  uv.close(handle, function() end)
end)
