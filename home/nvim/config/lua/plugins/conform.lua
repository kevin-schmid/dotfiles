return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>f",
        function() require("conform").format({ async = true }) end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "gofmt" },
        lua = { "stylua" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
