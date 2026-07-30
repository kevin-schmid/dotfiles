vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.laststatus = 2
vim.o.clipboard = "unnamedplus"
vim.o.timeoutlen = 500
vim.o.updatetime = 300
vim.o.completeopt = "menu,menuone,noselect"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.mouse = "a"

vim.wo.signcolumn = "yes"
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>pv", "<cmd>Ex<cr>", opts)
keymap("n", "<leader>b", "<c-^>", opts)
keymap("n", "<leader>cd", "<cmd>let @+ = 'cd ' .. expand('%:p:h')<cr>", opts)

keymap("v", "J", ":m '>+1<cr>gv=gv", opts)
keymap("v", "K", ":m '>-2<cr>gv=gv", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
keymap("n", "<leader>qf", vim.diagnostic.setloclist, opts)
