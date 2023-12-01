-- if_new_file_is.lua - if_new_file_is
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

local group = vim.api.nvim_create_augroup("IfNewFileIs", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
  group = group,
  pattern = "*",
  callback = function()
    local file_name = vim.fn.expand "%"

    local f = string.format

    -- stylua: ignore
    local choice_tbl = {
        ["bootstrap"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "autotools",
            file_name),
        ["autogen.sh"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "autotools",
            file_name),
        [".solution.toml"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "config",
            "solution.toml"),
        [".clangd"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "cpp",
            "clangd"),
        [".clang-format"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "cpp",
            "clang-format"),
        [".csharpierrc.json"] = f(
            "%s/templates/%s/%s",
            vim.fn.stdpath "config",
            "cs",
            "csharpierrc.json"),

        -- sh
        ["monitor_tex.sh"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "sh", file_name),
        ["monitor_files.sh"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "sh", file_name),
        -- makefile
        ["Makefile.gnu99"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "make", file_name),
        ["Makefile.latex"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "make", file_name),
        ["Makefile.cansi"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "make", file_name),
        ["Makefile.cpp"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "make", file_name),
        ["Makefile.java"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "make", file_name),

        -- meus dados
        ["eu.uerj"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "eu", file_name),

        ["astyle.cfg"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "c", file_name),
        -- android
        ["local.properties"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "android", file_name),
        ["custom_rules.xml"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "android", file_name),
        ["build.xml"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "android", file_name),
        ["build.sh"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "android", file_name),

        -- projectionist
        [".projections.json"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "json", file_name),
        ["gradle.projections.json"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "json", file_name),
        ["cansi.projections.json"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "json", file_name),
        ["cpp.projections.json"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "json", file_name),

        -- projetos
        ["prj.kotlin"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "prj", file_name),
        ["prj.go"] = f("%s/templates/%s/%s", vim.fn.stdpath "config", "prj", file_name)
    }

    local default_tbl = {
      -- ["clangd"] = ".clangd",
      ["prj.kotlin"] = ".prj",
      ["prj.go"] = ".prj",

      ["monitor_tex.sh"] = "monitor.sh",
      ["monitor_files.sh"] = "monitor.sh",
      ["Makefile.gnu99"] = "Makefile",
      ["Makefile.cansi"] = "Makefile",
      ["Makefile.cpp"] = "Makefile",
      ["Makefile.java"] = "Makefile",
      ["Makefile.latex"] = "latex.mk",
      [".projections.json"] = ".projections.json",
      ["gradle.projections.json"] = ".projections.json",
      ["cansi.projections.json"] = ".projections.json",
      ["cpp.projections.json"] = ".projections.json",
    }

    local template = choice_tbl[file_name]
    local name = default_tbl[file_name]

    if template then
      vim.cmd("0r " .. template)
      -- pwd => {{$pwd}}%
      vim.cmd [[ silent! %s/{{$pwd}}%/\=getcwd()/g ]]

      if name then
        vim.cmd "0f"
        print(name)
        vim.cmd("file " .. name)
      end
    end
  end,
})
-- vim: fdm=marker nowrap sw=4 sts=4 et
