return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "enter",
        ["<C-a>"] = { "show", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          buffer = { min_keyword_length = 3 },
        },
      },
    },
  },
}
