return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then return end

      ts.setup({
        ensure_installed = {
          "go",
          "gomod",
          "lua",
          "json",
          "bash",
          "yaml",
          "dockerfile",
          "terraform",
          "nix",
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
      })
    end,
  }
}
