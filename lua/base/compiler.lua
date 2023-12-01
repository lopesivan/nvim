return {

  { -- This plugin
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
  { -- The task runner we use
    "stevearc/overseer.nvim",
    -- commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
    -- cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    -- opts = {
    --   task_list = {
    --     direction = "bottom",
    --     min_height = 25,
    --     max_height = 25,
    --     default_detail = 1,
    --   },
    -- },
    keys = {
      { "<leader>tt0", "<cmd>CompilerOpen<cr>", desc = "Compiler Open" },
      { "<leader>tt1", "<cmd>CompilerToggleResults<cr>", desc = "Compiler Toggle Results" },
      { "<leader>ttR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
      { "<leader>tta", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>ttb", "<cmd>OverseerBuild<cr>", desc = "Build" },
      { "<leader>ttc", "<cmd>OverseerClose<cr>", desc = "Close" },
      { "<leader>ttd", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>ttl", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
      { "<leader>tto", "<cmd>OverseerOpen<cr>", desc = "Open" },
      { "<leader>ttq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>ttr", "<cmd>OverseerRun<cr>", desc = "Run" },
      { "<leader>tts", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
      { "<leader>ttt", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
    },
    opts = {},
    config = function()
      require("config.overseer").setup()
    end,
  },
}
