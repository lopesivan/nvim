local fzf = require("fzf")
local c = vim.api.nvim_command

local a= {
  {mode = 'n',command = 'TestNearest', description = "Nearest" },
  {mode = 'n',command = 'TestFile', description = "File" },
  {mode = 'n',command = 'TestSuite', description = "Suit" },
  {mode = 'n',command = 'TestLast', description = "Last" },
  {mode = 'n',command = 'TestVisit', description = "Visit" },
}

local choice = {}
for i,_ in pairs(a) do
  table.insert(choice, a[i].description)
end

coroutine.wrap(function()
  local result = fzf.fzf(
	choice,
	"--ansi",
	{ width = 30, height = 10, border = false }
  )
  if result then
	for i,_ in pairs(a) do
	  if a[i].description == result[1] then
		print(string.format('<CMD>%s<CR>', a[i].command))
		c(string.format('%s', a[i].command))
		goto continue
	  end
	end
	::continue::
  end
end)()

