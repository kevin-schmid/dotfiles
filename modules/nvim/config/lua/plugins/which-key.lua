return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a",  group = "AI" },
        { "<leader>ai", desc = "AI inline edit",    mode = { "n", "x" } },
        { "<leader>ac", desc = "AI chat",           mode = { "n", "v" } },
        { "<leader>aa", desc = "AI accept changes", mode = "n" },
        { "<leader>ar", desc = "AI reject changes", mode = "n" },
        { "<leader>g",  group = "Git" },
        { "<leader>gs", desc = "Git status" },
        { "<leader>gb", desc = "Toggle inline blame" },
        { "<leader>y",  group = "YAML" },
        { "<leader>ys", desc = "Select YAML/K8s schema" },
        { "<leader>yd", desc = "Detect K8s schema (apiVersion/kind)" },
        { "<leader>rn", desc = "Rename symbol" },
        { "<leader>ca", desc = "Code action", mode = { "n", "v" } },
        { "<leader>e",  desc = "Line diagnostics" },
      },
    },
  },
}
