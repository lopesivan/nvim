-- programa em lua

vim.filetype.add {
  extension = {
    puml = "plantuml",
  },
}

vim.filetype.add {
  extension = {
    qmd = "quarto",
  },
}

vim.filetype.add {
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
}

vim.filetype.add {
  extension = {
    h = function(path, bufnr)
      if vim.fn.search("\\C^#include <[^>.]\\+>$", "nw") ~= 0 then
        return "cpp"
      end
      return "c"
    end,
  },
}

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd.set "filetype=term"
  end,
})

vim.filetype.add {
  extension = {
    -- fnl = "fennel",
    wiki = "markdown",
  },
  filename = {
    ["go.sum"] = "gosum",
    ["go.mod"] = "gomod",
  },
}
