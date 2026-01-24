vim.api.nvim_create_user_command('CopyGitRelPath', function()
  local filepath = vim.fn.expand('%:p')
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')

  if vim.v.shell_error ~= 0 then
    vim.notify('Not a Git repository', vim.log.levels.ERROR)
    return
  end

  -- Get relative path
  local escaped_git_root = git_root:gsub("([^%w])", "%%%1")
  local rel_path = filepath:gsub('^' .. escaped_git_root .. '/', '')

  -- Copy just the path to clipboard
  vim.fn.setreg('+', rel_path)

  -- Gather additional context (not copied)
  local status_output = vim.fn.system('git status --porcelain -- ' .. vim.fn.shellescape(filepath))

  -- Get uncommitted changes (+/-)
  local diff_stat = vim.fn.system('git diff --numstat -- ' .. vim.fn.shellescape(filepath)):gsub('\n', '')
  local additions, deletions = 0, 0
  if diff_stat ~= "" then
    additions, deletions = diff_stat:match("(%d+)%s+(%d+)")
    additions = tonumber(additions) or 0
    deletions = tonumber(deletions) or 0
  end

  -- Parse git status
  local status = ""
  local status_hl = "Normal"
  if status_output ~= "" then
    local status_code = status_output:sub(1, 2)
    local status_info = {
      ["M "] = { "staged", "DiagnosticOk" },
      [" M"] = { "modified", "DiagnosticWarn" },
      ["MM"] = { "staged+modified", "DiagnosticWarn" },
      ["A "] = { "added", "DiagnosticOk" },
      ["D "] = { "deleted", "DiagnosticError" },
      [" D"] = { "deleted", "DiagnosticError" },
      ["R "] = { "renamed", "DiagnosticInfo" },
      ["C "] = { "copied", "DiagnosticInfo" },
      ["??"] = { "untracked", "DiagnosticHint" },
    }
    local info = status_info[status_code]
    if info then
      status = info[1]
      status_hl = info[2]
    else
      status = status_code
    end
  else
    status = "clean"
    status_hl = "Comment"
  end

  -- Build colored output using nvim_echo
  local chunks = {
    { rel_path, "Normal" },
  }

  if status ~= "" then
    table.insert(chunks, { "  " .. status, status_hl })
  end

  if additions > 0 or deletions > 0 then
    table.insert(chunks, { "  ", "Normal" })
    if additions > 0 then
      table.insert(chunks, { "+" .. additions, "DiffAdd" })
    end
    if additions > 0 and deletions > 0 then
      table.insert(chunks, { " ", "Normal" })
    end
    if deletions > 0 then
      table.insert(chunks, { "-" .. deletions, "DiffDelete" })
    end
  end

  vim.api.nvim_echo(chunks, false, {})
end, {})
