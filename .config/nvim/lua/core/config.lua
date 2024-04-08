vim.wo.number = true
vim.wo.relativenumber = true
vim.api.nvim_set_option("clipboard","unnamed")

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

vim.filetype.add({
    extension = {
        templ = "templ",
        json = "geojson"
    },
})

---------------------------- WSL SPECIFICS -----------------------------------

local output = vim.fn.systemlist("uname -r")
if output[1]:find("microsoft") then
    vim.opt.background = "light"
end

------------------------------ STATUSLINE ------------------------------------
local fn, cmd = vim.fn, vim.cmd

function StatusLine()
  local branch = fn.FugitiveHead()

  if branch and #branch > 0 then
    branch = " "..branch
  end

  if vim.bo.modified then
    return " %f  %= %l:%c "..branch
  end

  return " %f %= %l:%c "..branch
end

cmd[[ set statusline=%!luaeval('StatusLine()') ]]
