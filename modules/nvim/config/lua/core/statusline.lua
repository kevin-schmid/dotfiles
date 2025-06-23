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
