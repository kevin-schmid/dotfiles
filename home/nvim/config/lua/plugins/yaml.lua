return {
  {
    "cenk1cenk2/schema-companion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local schema_companion = require("schema-companion")
      schema_companion.setup({})

      vim.keymap.set("n", "<leader>ys", schema_companion.select_schema, { desc = "Select YAML schema" })
      vim.keymap.set("n", "<leader>ym", schema_companion.select_matching_schema, { desc = "Select from matching schemas" })
      vim.keymap.set("n", "<leader>yd", schema_companion.match, { desc = "Detect schema again" })
    end,
  },
}
