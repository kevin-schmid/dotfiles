return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, desc = "Buffer diagnostics" })
    end,
  }
}
