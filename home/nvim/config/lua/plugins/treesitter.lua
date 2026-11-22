return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter")
      if not ok then return end

      ts.install({
        "go",
        "gomod",
        "lua",
        "json",
        "bash",
        "yaml",
        "dockerfile",
        "terraform",
        "nix",
        "c",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then return end
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  }
}
