return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { noremap = true, silent = true, desc = "Git status" })
    end,
  }
}
