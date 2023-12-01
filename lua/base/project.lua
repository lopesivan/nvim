return {
  {
    "ahmedkhalf/project.nvim",
    event = "BufEnter",
    config = function()
      require("config.project").setup()
    end,
    keys = {
      {
        "<leader>fpp",
        [[<CMD>lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>]],
        desc = "Projects List",
      },
      -- { "<leader>fps", [[<cmd>lua require('config.telescope').project_search()<cr>]], desc = "Project search" },
      {
        "<leader>fsr",
        [[<CMD>lua require'telescope'.extensions.repo.list{search_dirs = {"~/git"}}<CR>]],
        desc = "Search list repo",
      },
    },
  },
}
