return {

	{
		"andrewradev/switch.vim",
		lazy = false,
		-- event = "VeryLazy",
		keys = {
			{ "-", "<Cmd>Switch<CR>", desc = "Switch word under cursor" },
		},
		init = function()
			-- Disable default mapping.
			vim.g.switch_mapping = ""
			vim.g.switch_custom_definitions = {
				{ ".", "->" },
				{ "==", "!=" },
				{ "top", "bottom" },
				{ "left", "right" },
				{ "width", "height" },
				{ "always", "auto", "never" },
				{ "before", "after" },
				{ "back", "front" },
				{ "start", "stop" },
				{ "yes", "no" },
				{ "on", "off" },
				{ "TOP", "BOTTOM" },
				{ "LEFT", "RIGHT" },
				{ "WIDTH", "HEIGHT" },
				{ "ALWAYS", "AUTO", "NEVER" },
				{ "BEFORE", "AFTER" },
				{ "BACK", "FRONT" },
				{ "START", "STOP" },
				{ "YES", "NO" },
				{ "ON", "OFF" },
				{
					"PERF",
					"HACK",
					"TODO",
					"DONE",
					"NOTE",
					"WARNING",
					"FIX",
					"DEBUG",
					"TEST",
				},
				{ "error", "warn", "info", "debug" },
				{ "TODO", "FIXME" },
				{ "dark", "light" },
				{ "production", "development", "test" },
				{ "soft", "medium", "hard" },
				{ "low", "high" },
				{ "row", "column" },
				{ "enabled", "disabled" },
				{ "'", '"' },
				{ "-", "_" },
				{
					["\\<[a-z0-9]\\+_\\k\\+\\>"] = {
						["_\\(.\\)"] = "\\U\\1",
					},
				},
				{
					["\\<[a-z0-9]\\+[A-Z]\\k\\+\\>"] = {
						["\\([A-Z]\\)"] = "_\\l\\1",
					},
				},
				--[[
        - [ ] dsdsdsdsdsds.
        - [x] dsdsdsdsdsds.
        ]]
				{ ["\\v^( *- *)\\[x\\](.*)$"] = "\\1[ ]\\2" },
				{ ["\\v^( *- *)\\[ \\](.*)$"] = "\\1[x]\\2" },
				--
				{ ["\\v'([^']*)'"] = '"\\1"' },
				{ ['\\v"([^"]*)"'] = "'\\1'" },
			}
		end,
	},
}
