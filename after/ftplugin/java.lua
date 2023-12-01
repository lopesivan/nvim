vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.commentstring = "// %s"

-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
vim.g.easy_align_delimiters = {
    -- aperto d
    ["d"] = {
        ["pattern"] = "\\(const\\|constexpr\\|static\\)\\@<! ",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
    },

    -- aperto c
    ["c"] = {
        ["pattern"] = "\\/\\/",
        ["ignore_groups"] = { "String" },
        ["ignore_unmatched"] = 0,
    },

    -- aperto <
    ["<"] = {
        ["pattern"] = "<<",
        ["ignore_groups"] = { "String" },
        ["ignore_unmatched"] = 0,
    },

    -- aperto f
    ["f"] = {
        ["pattern"] = " \\ze\\S\\+\\s*[;=]",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
    },

    -- aperto ]
    ["]"] = {
        ["pattern"] = "[[\\]]",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },

    -- aperto )
    [")"] = {
        ["pattern"] = "[()]",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },

    -- aperto (
    ["("] = {
        ["pattern"] = "(",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },

    -- aperto w
    ["w"] = {
        ["pattern"] = "\\w",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },

    -- aperto _
    ["_"] = {
        ["pattern"] = "_\\w",
        ["left_margin"] = 1,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },
    -- aperto ,
    [","] = {
        ["pattern"] = "\\w\\+,",
        ["delimiter_align"] = "l",
        ["left_margin"] = 0,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },

    -- aperto ;
    [";"] = {
        ["pattern"] = "\\w\\+;",
        ["delimiter_align"] = "l",
        ["left_margin"] = 1,
        ["right_margin"] = 0,
        ["stick_to_left"] = 0,
    },
}
-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
vim.g.projectionist_heuristics = {
    ["*.java"] = {
        ["*.java"] = {
            ["make"] = "javac {file|basename}",
            ["dispatch"] = "java {}",
            ["telescope"] = "Telescope yabs tasks",
            ["type"] = "java",
        },
    },
}

local nmap = require("config.dispatch").nmap
--nmap { "<leader><CR>", "telescope", "build maneger" }
nmap { "m<CR>", "make", "Make" }
nmap { "d<CR>", "dispatch", "Dispatch" }
