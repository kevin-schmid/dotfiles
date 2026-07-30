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
      },
    },
  },
}
