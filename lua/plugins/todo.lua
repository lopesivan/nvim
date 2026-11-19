return {
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup {
                keywords = {
                    WARNING = { icon = "⚠️" },
                    DEBUG = { icon = "🔶", color = "warning" },
                    DONE = { icon = "✅", color = "hint" },
                    HACK = { icon = "☢️" },
                    TODO = { icon = "☑️" },
                    NOTE = { icon = "📌" },
                    FIX = { icon = "❌" },
                    PERF = { icon = "🟪" },
                    TEST = { icon = "🟦" },
                },
            }
        end,
        keys = {
            {
                "<leader>td",
                [[ <CMD>Telescope todo-comments<CR> ]],
                desc = "Telescope TODO",
            },

            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
        },
    },
}
-- PERF: fully optimised
-- HACK: hmmm, this looks a bit funky
-- TODO: What else?                          O que mais ?
-- NOTE: adding a note
-- FIX: this needs fixing
-- WARNING: ???
-- FIX: ddddd
-- DEBUG: ddddd

-- PERF: totalmente otimizado
-- HACK: hmmm, isso parece um pouco estranho
-- TODO: O que mais?
-- DONE: feito
-- NOTE: adicionando uma nota
-- WARNING: ???
-- FIX: isso precisa ser consertado
-- DEBUG: mensagems para debugar
-- TEST:  Meu teste
--
--
-- todo: fooo
-- @TODO foobar
-- @hack foobar
--
--
-- 🟥 red square
-- 🟧 orange square
-- 🟨 yellow square
-- 🟩 green square
-- 🟦 blue square
-- 🟪 purple square
-- 🟫 brown square
-- ⬛ black large square
-- ⬜ white large square
--
-- 🐞 lady beetle
-- 🐝 honeybee
--    🔶 large orange diamond
--    🔷 large blue diamond
--    🔸 small orange diamond
--    🔹 small blue diamond
--    🔺 red triangle pointed up
--    🔻 red triangle pointed down
--    🔘 radio button
--    🔳 white square button
--    🔲 black square button
--    📵 no mobile phones
--    🔞 no one under eighteen
--    🚸 children crossing
--    ⛔ no entry
--    ⚠️ warning
--    🚫 prohibited
--    ☢️ radioactive
--    ☣️ biohazard
--    ✅ check mark button
--    ☑️ check box with check
--    ✔️ check mark
--    ❌ cross mark
--    ❎ cross mark button
--    🏁 chequered flag
--    🚩 triangular flag
--    🎌 crossed flags
--    🏴 black flag
--    🏳️ white flag
