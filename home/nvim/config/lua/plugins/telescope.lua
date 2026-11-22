return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then return end

      telescope.setup({
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules" },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
        },
      })

      pcall(function() telescope.load_extension("fzf") end)
      pcall(function() telescope.load_extension("ui-select") end)

      local builtin = require("telescope.builtin")
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>pf", builtin.find_files, opts)
      vim.keymap.set("n", "<leader>ps", builtin.live_grep, opts)
      vim.keymap.set("n", "<leader>pb", builtin.buffers, opts)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
      vim.keymap.set("n", "/", function() builtin.current_buffer_fuzzy_find() end, { noremap = true })
    end,
  }
}
