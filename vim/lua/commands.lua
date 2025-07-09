vim.api.nvim_create_user_command('CopyGitRelPath', function()
  local filepath = vim.fn.expand('%:p')
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')

  if git_root == '' then
    vim.notify('Not a Git repository', vim.log.levels.ERROR)
    return
  end

  -- Escape Lua pattern characters in git_root
  local escaped_git_root = git_root:gsub("([^%w])", "%%%1")
  local rel_path = filepath:gsub('^' .. escaped_git_root .. '/', '')

  vim.fn.setreg('+', rel_path)
  vim.notify('Copied: ' .. rel_path)
end, {})
