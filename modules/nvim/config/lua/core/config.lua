vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.laststatus = 2
vim.opt.hidden = false

vim.g.netrw_banner = 0
vim.g.netrw_browser_split = 0
vim.g.netrw_winsize = 25
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
