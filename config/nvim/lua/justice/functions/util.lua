local api = vim.api

local function press_enter()
  api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
end

local function string_starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

local function basename(str)
  return string.match(str, "^.+/(.+)$")
end

local function get_branch_name()
  local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
  if is_git_branch == "true\n" then
    for line in io.popen("git branch 2>/dev/null"):lines() do
      local current_branch = line:match("%* (.+)$")
      if current_branch then
        return current_branch
      end
    end
  end
end

local function branch_exists(branch)
  local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
  if is_git_branch == "true\n" then
    for line in io.popen("git branch 2>/dev/null"):lines() do
      line = line:gsub("%s+", "")
      if line == branch then
        return true
      end
    end
  end
  return false
end

local function get_tab_by_buf_name(name, starts_with)
  for _, tab in ipairs(api.nvim_list_tabpages()) do
    local win = api.nvim_tabpage_get_win(tab)
    local buf = api.nvim_win_get_buf(win)
    local buf_name = api.nvim_buf_get_name(buf)
    if starts_with then
      if string_starts(buf_name, name) then
        return tab
      end
    else
      local base_name = basename(buf_name)
      if base_name == name then
        return tab
      end
    end
  end
  return -1
end

return {
  basename = basename,
  branch_exists = branch_exists,
  get_branch_name = get_branch_name,
  get_tab_by_buf_name = get_tab_by_buf_name,
  press_enter = press_enter,
  string_starts = string_starts,
}
