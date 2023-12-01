local fzf = require("fzf")
local c = vim.api.nvim_command

local a= {
	{mode = 'n',command = 'git clone gitolite:gitolite-admin', description = "🧑🧑 admin 🧑🧑" },
	-- projetos
	{mode = 'n',command = 'git gitolite android',          description ='gitolite android'},
	{mode = 'n',command = 'git gitolite arduino',          description ='gitolite arduino'},
	{mode = 'n',command = 'git gitolite bash',             description ='gitolite bash'},
	{mode = 'n',command = 'git gitolite cansi',            description ='gitolite cansi'},
	{mode = 'n',command = 'git gitolite circuito',         description ='gitolite circuito'},
	{mode = 'n',command = 'git gitolite clion',            description ='gitolite clion'},
	{mode = 'n',command = 'git gitolite cpp',              description ='gitolite cpp'},
	{mode = 'n',command = 'git gitolite datagrip',         description ='gitolite datagrip'},
	{mode = 'n',command = 'git gitolite dev',              description ='gitolite dev'},
	{mode = 'n',command = 'git gitolite docker',           description ='gitolite docker'},
	{mode = 'n',command = 'git gitolite eng',              description ='gitolite eng'},
	{mode = 'n',command = 'git gitolite go',               description ='gitolite go'},
	{mode = 'n',command = 'git gitolite goland',           description ='gitolite goland'},
	{mode = 'n',command = 'git gitolite gradle',           description ='gitolite gradle'},
	{mode = 'n',command = 'git gitolite gtk',              description ='gitolite gtk'},
	{mode = 'n',command = 'git gitolite idea',             description ='gitolite idea'},
	{mode = 'n',command = 'git gitolite java',             description ='gitolite java'},
	{mode = 'n',command = 'git gitolite latex',            description ='gitolite latex'},
	{mode = 'n',command = 'git gitolite lua',              description ='gitolite lua'},
	{mode = 'n',command = 'git gitolite maven',            description ='gitolite maven'},
	{mode = 'n',command = 'git gitolite perl',             description ='gitolite perl'},
	{mode = 'n',command = 'git gitolite pycharm',          description ='gitolite pycharm'},
	{mode = 'n',command = 'git gitolite python',           description ='gitolite python'},
	{mode = 'n',command = 'git gitolite qt',               description ='gitolite qt'},
	{mode = 'n',command = 'git gitolite rider',            description ='gitolite rider'},
	{mode = 'n',command = 'git gitolite ruby',             description ='gitolite ruby'},
	{mode = 'n',command = 'git gitolite rubymine',         description ='gitolite rubymine'},
	{mode = 'n',command = 'git gitolite uff',              description ='gitolite uff'},
	{mode = 'n',command = 'git gitolite webstorm',         description ='gitolite webstorm'},
	{mode = 'n',command = 'git gitolite wx',               description ='gitolite wx'},
	-- ssh
	{mode = 'n',command = 'ssh gitolite.android info -p',  description ='ssh info android'},
	{mode = 'n',command = 'ssh gitolite.arduino info -p',  description ='ssh info arduino'},
	{mode = 'n',command = 'ssh gitolite.bash info -p',     description ='ssh info bash'},
	{mode = 'n',command = 'ssh gitolite.cansi info -p',    description ='ssh info cansi'},
	{mode = 'n',command = 'ssh gitolite.circuito info -p', description ='ssh info circuito'},
	{mode = 'n',command = 'ssh gitolite.clion info -p',    description ='ssh info clion'},
	{mode = 'n',command = 'ssh gitolite.cpp info -p',      description ='ssh info cpp'},
	{mode = 'n',command = 'ssh gitolite.datagrip info -p', description ='ssh info datagrip'},
	{mode = 'n',command = 'ssh gitolite.dev info -p',      description ='ssh info dev'},
	{mode = 'n',command = 'ssh gitolite.docker info -p',   description ='ssh info docker'},
	{mode = 'n',command = 'ssh gitolite.eng info -p',      description ='ssh info eng'},
	{mode = 'n',command = 'ssh gitolite.go info -p',       description ='ssh info go'},
	{mode = 'n',command = 'ssh gitolite.goland info -p',   description ='ssh info goland'},
	{mode = 'n',command = 'ssh gitolite.gradle info -p',   description ='ssh info gradle'},
	{mode = 'n',command = 'ssh gitolite.gtk info -p',      description ='ssh info gtk'},
	{mode = 'n',command = 'ssh gitolite.idea info -p',     description ='ssh info idea'},
	{mode = 'n',command = 'ssh gitolite.java info -p',     description ='ssh info java'},
	{mode = 'n',command = 'ssh gitolite.latex info -p',    description ='ssh info latex'},
	{mode = 'n',command = 'ssh gitolite.lua info -p',      description ='ssh info lua'},
	{mode = 'n',command = 'ssh gitolite.maven info -p',    description ='ssh info maven'},
	{mode = 'n',command = 'ssh gitolite.perl info -p',     description ='ssh info perl'},
	{mode = 'n',command = 'ssh gitolite.pycharm info -p',  description ='ssh info pycharm'},
	{mode = 'n',command = 'ssh gitolite.python info -p',   description ='ssh info python'},
	{mode = 'n',command = 'ssh gitolite.qt info -p',       description ='ssh info qt'},
	{mode = 'n',command = 'ssh gitolite.rider info -p',    description ='ssh info rider'},
	{mode = 'n',command = 'ssh gitolite.ruby info -p',     description ='ssh info ruby'},
	{mode = 'n',command = 'ssh gitolite.rubymine info -p', description ='ssh info rubymine'},
	{mode = 'n',command = 'ssh gitolite.uff info -p',      description ='ssh info uff'},
	{mode = 'n',command = 'ssh gitolite.webstorm info -p', description ='ssh info webstorm'},
	{mode = 'n',command = 'ssh gitolite.wx info -p',       description ='ssh info wx'},
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
		print(string.format('%s', a[i].command))
		c(string.format('!%s', a[i].command))
		goto continue
	  end
	end
	::continue::
  end
end)()

