local fzf = require("fzf")
local c = vim.api.nvim_command

local a= {
  {mode = 'n',command = 'Git add %:p', description = "Add" },
  {mode = 'n',command = 'Gread', description = "Read" },
  {mode = 'n',command = 'Gwrite', description = "Write" },

  {mode = 'n',command = 'Gdiff', description = "diff split" },
  -- {mode = 'n',command = 'Git', description = "Status" },
  {mode = 'n',command = 'Git blame', description = "Blame" },
  {mode = 'n',command = 'Git commit', description = "Commit" },
  {mode = 'n',command = 'Git init', description = "Init" },

  -- Para navegar pelo log uso ]q, [q
  {mode = 'n',command = '0GcLog', description = "Log" },

  {mode = 'n',command = 'GRemove', description = "Remove current" },
  {mode = 'n',command = '!git rm-ignored', description = "Remove ignored" },
  {mode = 'n',command = '!git rm-untracked', description = "Remove untracked" },

  {mode = 'n',command = '!git undo', description = "Undo" },
  {mode = 'n',command = '!git dry-all', description = "Dry All" },
  {mode = 'n',command = '!git dry-run', description = "Dry Run" },
  {mode = 'n',command = '!git dry', description = "Dry" },

  -- USAGE: git ignore [-s|-L|list] language
  {mode = 'n',command = 'exe "!git ignore ".input("args: ", "-s")', description = "Ignore" },
  {mode = 'n',command = 'exe "!git cd ".input("args: ", "-r")', description = "<cd> checkout" },

  {mode = 'n',command = 'exe "GMove ".input("Novo nome: ")', description = "Rename" },
}

local choice = {}
for i,_ in pairs(a) do
  table.insert(choice, a[i].description)
end

coroutine.wrap(function()
  local result = fzf.fzf(
	choice,
	"--ansi",
	{ width = 30, height = 20, border = false }
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

