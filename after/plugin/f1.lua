-- f1.lua

vim.keymap.set("n", "<F1>", function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.opt.list = not vim.opt.list:get()
    vim.opt.linebreak = not vim.opt.linebreak:get()

    if vim.opt.virtualedit["_value"] == "block" then
        vim.opt.virtualedit = "all"
    else
        vim.opt.virtualedit = "block"
    end
    print("vim.opt.wrap:", vim.opt.wrap["_value"])
    print("vim.opt.list:", vim.opt.list["_value"])
    print("vim.opt.linebreak:", vim.opt.linebreak["_value"])
    print("opt.virtualedit:", vim.opt.virtualedit["_value"])
end, { desc = "toggle modo de desenho" })
