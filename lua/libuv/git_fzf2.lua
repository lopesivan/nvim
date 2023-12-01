local fzf = require("fzf")

-- ['n <M-Space>U'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
local a= {
  {mode = 'n',command = 'stage_hunk()',                                     description = "Hunk Stage" },
  -- {mode = 'v',command = 'stage_hunk({vim.fn.line("."), vim.fn.line("v")})', description = "Stage Hunk Inline" },
  {mode = 'n',command = 'undo_stage_hunk()',                                description = "Hunk Stage [Undo]" },
  {mode = 'n',command = 'reset_hunk()',                                     description = "Hunk Reset " },
  -- {mode = 'v',command = 'reset_hunk({vim.fn.line("."), vim.fn.line("v")})', description = "Reset Hunk Inline" },
  {mode = 'n',command = 'reset_buffer()',                                   description = "Buffer Reset" },
  -- {mode = 'n',command = 'preview_hunk()',                                   description = "Preview Hunk" },
  -- {mode = 'n',command = 'blame_line(true)',                                 description = "Blame Line" },
  {mode = 'n',command = 'stage_buffer()',                                   description = "Buffer Stage" },
  -- {mode = 'n',command = 'reset_buffer_index()',                             description = "Reset Buffer Index" },
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

		local func, err = load(string.format('require"gitsigns".%s', a[i].command))
		if func then
		  local ok, f = pcall(func)
		  if ok then
			f()
		  end
		end
		goto continue

	  end
	end
	::continue::
  end
end)()

