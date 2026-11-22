function StatusLine()
  local branch = vim.fn.FugitiveHead()

  if branch and #branch > 0 then
    branch = " " .. branch
  end
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local icon
  if errors > 0 then
    icon = "✖"
  elseif vim.bo.modified then
    icon = ""
  else
    icon = ""
  end

  return icon .. " %f %= %l:%c " .. branch
end

vim.cmd [[ set statusline=%!luaeval('StatusLine()') ]]
