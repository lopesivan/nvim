if not pcall(require, "colorbuddy") then
  return
end

vim.opt.termguicolors = true

local Color, c, Group, g, s = require("colorbuddy").setup()

Color.new("yellowMatchParen", "#d7ff00")
Color.new("yellowVisual", "#ffcd07")
--=Color.new("blueFolded", "#0478A4")
--=Color.new("cursor", "#333842")
Color.new("cursor2", "#202736")
--=Color.new("background", "#333842")
Group.new("CodeBlock", nil, c.cursor2, nil)
Color.new("black", "#000000")
--=
Group.new("Visual", c.background, c.yellowVisual, s.bold)
-- Group.new("Visual", c.black, c.yellowVisual, s.bold)
--=-- Group.new("Normal", nil, c.black, nil)
--=Group.new("Normal", nil, c.background, nil)
--=Group.new("Folded", c.wheat, c.blueFolded, nil)
-- Group.new("SignColumn", nil, nil, nil)
-- Group.new("LineNr", nil, c.black, nil)
Group.new("MatchParen", c.black, c.yellowMatchParen, s.bold)
Group.new("ColorColumn", nil, c.DarkRed, nil)
--=
--=-- hop
--=Group.new("HopNextKey", c.black, c.yellowVisual, s.bold)
--=Group.new("HopNextKey1", c.red:dark(), nil, s.bold)
--=Group.new("HopNextKey2", c.red:saturate(), nil)
--=-----
--=Group.new("@variable", c.superwhite, nil)
--=
--=Group.new("GoTestSuccess", c.green, nil, s.bold)
--=Group.new("GoTestFail", c.red, nil, s.bold)
--=
--=-- Group.new('Keyword', c.purple, nil, nil)
--=
--=Group.new("TSPunctBracket", c.orange:light():light())
--=
--=Group.new("StatuslineError1", c.red:light():light(), g.Statusline)
--=Group.new("StatuslineError2", c.red:light(), g.Statusline)
--=Group.new("StatuslineError3", c.red, g.Statusline)
--=Group.new("StatuslineError3", c.red:dark(), g.Statusline)
--=Group.new("StatuslineError3", c.red:dark():dark(), g.Statusline)
--=
--=Group.new("pythonTSType", c.red)
--=Group.new("goTSType", g.Type.fg:dark(), nil, g.Type)
--=
--=Group.new("typescriptTSConstructor", g.pythonTSType)
--=Group.new("typescriptTSProperty", c.blue)
--=
--=-- vim.cmd [[highlight WinSeparator guifg=#4e545c guibg=None]]
--=Group.new("WinSeparator", nil, nil)
--=
--=-- I don't think I like highlights for text
--=-- Group.new("LspReferenceText", nil, c.gray0:light(), s.bold)
--=-- Group.new("LspReferenceWrite", nil, c.gray0:light())
--=
--=-- Group.new("TSKeyword", c.purple, nil, s.underline, c.blue)
--=-- Group.new("LuaFunctionCall", c.green, nil, s.underline + s.nocombine, g.TSKeyword.guisp)
--=
--=Group.new("TSTitle", c.blue)
--=
--=-- TODO: It would be nice if we could only highlight
--=-- the text with characters or something like that...
--=-- but we'll have to stick to that for later.
--=Group.new("InjectedLanguage", nil, g.Normal.bg:dark())
--=
--=Group.new("LspParameter", nil, nil, s.italic)
--=Group.new("LspDeprecated", nil, nil, s.strikethrough)
--=Group.new("@function.bracket", g.Normal, g.Normal)
--=Group.new("@variable.builtin", c.purple:light():light(), g.Normal)
--=
--=-- Group.new("@function.call.lua"
--=vim.cmd.highlight "link @function.call.lua LuaFunctionCall"
