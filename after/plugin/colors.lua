-- colors.lua
vim.opt.termguicolors = true
local Color = require("colorbuddy.init").Color
local colors = require("colorbuddy.init").colors
local Group = require("colorbuddy.init").Group
local groups = require("colorbuddy.init").groups
local styles = require("colorbuddy.init").styles

Color.new("red", "#cc6666")
Color.new("green", "#99cc99")
Color.new("yellow", "#FFFF00")
Color.new("black",  "#000000")
Color.new("background", "#1d1f21")
Color.new("yellow_match_paren", "#d7ff00")
Color.new("folded_bg", "#3b4261")

-- Group.new("Function", colors.yellow, colors.background, styles.bold)
-- Group.new("mFunction", groups.Function, groups.Function, groups.Function)
-- -- original:
-- -- Folded        xxx guifg=#7aa2f7 guibg=#3b4261
-- Group.new("Folded", colors.yellow, colors.folded_bg, nil)
-- Group.new("FoldColumn", colors.yellow, colors.folded_bg, nil)
-- -- Group.new(
-- --   "Comment",
-- --   colors.yellow,
-- --   colors.folded_bg,
-- --   styles.bold + styles.italic
-- -- )
--
-- -- Group.new("Comment", colors.yellow, colors.background, nil)
-- -- Group.new("Comment", colors.yellow_match_paren, colors.background, nil)
-- -- Group.new("Visual", colors.background, colors.yellow_match_paren, styles.bold)
--
-- -- If you want multiple styles, just add them!
-- Group.new(
--   "italicBoldFunction",
--   groups.Function,
--   colors.background,
--   styles.bold + styles.italic
-- )
--
-- -- If you want the same style as a different group, but without a style
-- -- just subtract it!
-- Group.new(
--   "boldFunction",
--   colors.yellow,
--   colors.yellow,
--   groups.italicBoldFunction - styles.italic
-- )
--
Group.new("ColorColumn", nil, colors.DarkRed, nil)
Group.new("Visual", colors.black, colors.yellow, styles.bold)
-- Group.new("LineNr", nil, colors.background, nil)
