return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>g",  group = "Git" },
        { "<leader>gs", desc = "Git status" },
        { "<leader>gb", desc = "Toggle inline blame" },
        { "<leader>y",  group = "YAML" },
        { "<leader>x",  group = "Trouble" },
        { "<leader>e",  desc = "Line diagnostics" },
      },
    },
  },
}
