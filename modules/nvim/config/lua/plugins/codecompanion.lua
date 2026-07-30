return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        acp = {
          cursor_cli = function()
            return require("codecompanion.adapters").extend("cursor_cli", {})
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "cursor_cli",
        },
        inline = {},
      },
      rules = {
        caveman = {
          description = "Caveman ultra-compressed communication skill",
          files = {
            "~/.agents/skills/caveman/SKILL.md",
          },
        },
        opts = {
          chat = {
            autoload = { "caveman" },
          },
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "AI chat" })
  end,
  keys = {
    { "<leader>a",  group = "AI" },
    { "<leader>ac", desc = "AI chat", mode = { "n", "v" } },
  },
}
