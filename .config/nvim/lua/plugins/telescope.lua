return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    keys = {
        { "/", "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
        { "<leader>pf", "<cmd>Telescope find_files<cr>" },
        { "<leader>ps", "<cmd>Telescope live_grep<cr>" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            pickers = {
                find_files = {
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
            },
            extensions = { "fzf" }
        })
        telescope.load_extension("fzf")
    end,
}
