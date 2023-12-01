local fzf = require("fzf")
local c = vim.api.nvim_command

local a= {
	{mode = 'n',command = 'diffoff',                  description = "⚫[OFF] disable diff mode" },
	{mode = 'n',command = 'Gdiff|diffput|quit',       description = "🔁<Stage> ➯ ➱ ➯ ➱ ➩🚧<Workdir>" },
	{mode = 'n',command = 'Gdiff|diffget|write|quit', description = "🚧<Workdir> ➯ ➱ ➯ ➱🔁<Stage>" },
	{mode = 'n',command = 'Gdiff HEAD|diffput|quit',  description = "🏠<Repository> ➯ ➱ 🚧<Workdir>" },
	{mode = 'n',command = 'Gdiff|diffoff',            description = "🚧<Workdir>        🔁<Stage> ✍ " },
	{mode = 'n',command = 'Gdiff',                    description = "🔁<Stage>          🚧<Workdir>" },
	{mode = 'n',command = 'Gdiff HEAD',               description = "🚧<Workdir>        🏠<Repository>" },
	{mode = 'n',command = 'Git! diff',                description = "🔁<Stage>        → 🚧<Workdir>" },
	{mode = 'n',command = 'Git! diff HEAD',           description = "🏠<Repository>   → 🚧<Workdir>" },
	{mode = 'n',command = 'Git! diff HEAD^',          description = "🏠<Repository^>  → 🚧<Workdir>" },
	{mode = 'n',command = 'Git! diff --cached',       description = "🏠<Repository>   → 🔁<Stage>" },
	{mode = 'n',command = 'Git! diff --cached HEAD^', description = "🏠<Repository^>  → 🔁<Stage>" },
}

local choice = {}
for i,_ in pairs(a) do
  table.insert(choice, a[i].description)
end

coroutine.wrap(function()
  local result = fzf.fzf(
	choice,
	"--ansi",
	{ width = 40, height = 15, border = false }
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

