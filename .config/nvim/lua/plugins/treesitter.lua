return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                "bash",
                "c",
                "c_sharp",
                "css",
                "dockerfile",
                "go",
                "gomod",
                "gitignore",
                "hcl",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "python",
                "query",
                "regex",
                "rust",
                "templ",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
        })
    end,
}
