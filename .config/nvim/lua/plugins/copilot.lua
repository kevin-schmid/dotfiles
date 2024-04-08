return {
    "zbirenbaum/copilot.lua",
    config = function()
        require("copilot").setup({
            panel = {
                enabled = false
            },
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-j>",
                }
            },
            filetypes = {
                yaml = true
            }
        })
    end,
}

