return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
    },
    config = function(_, opts)
      local gs = require("gitsigns")
      gs.setup(opts)
      vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, {
        silent = true,
        desc = "Toggle inline git blame",
      })
    end,
  },
}
