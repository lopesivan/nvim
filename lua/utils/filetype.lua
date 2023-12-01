-- programa em lua

vim.filetype.add({
    extension = {
        qmd = "quarto",
    },
})

vim.filetype.add({
    extension = {
        foo = "fooscript",
    },
    filename = {
        ["Foofile"] = "fooscript",
    },
    pattern = {
        ["~/%.config/foo/.*"] = "fooscript",
    },
    filename = {
        ["configure.ac"] = "config",
    },
})


vim.filetype.add({
    extension = {
        h = function(path, bufnr)
            if vim.fn.search("\\C^#include <[^>.]\\+>$", "nw") ~= 0 then
                return "cpp"
            end
            return "c"
        end,
    },
})
