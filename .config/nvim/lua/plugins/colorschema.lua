return {
    {
        "rose-pine/neovim",
        lazy = false,
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                highlight_groups = {
                    TelescopeBorder = { fg = "highlight_high", bg = "none" },
                    TelescopeNormal = { bg = "none" },
                    TelescopePromptNormal = { bg = "base" },
                    TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                    TelescopeSelection = { fg = "text", bg = "base" },
                    TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

                    StatusLine = { fg = "love", bg = "none" },
                    StatusLineNC = { fg = "subtle", bg = "none" },
                }
            })
            vim.cmd("colorscheme rose-pine")
        end,
    },
}
