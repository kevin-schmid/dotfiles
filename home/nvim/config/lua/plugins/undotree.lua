return {
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { noremap = true, silent = true, desc = "Toggle Undotree" })
    end,
  }
}
