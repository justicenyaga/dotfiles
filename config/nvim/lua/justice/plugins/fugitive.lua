local util = require("justice.functions.util")

local api = vim.api

vim.api.nvim_create_user_command("Browse", function(opts)
  vim.fn.system({ "xdg-open", opts.fargs[1] })
end, { nargs = 1 })

local function jump_next()
  api.nvim_feedkeys(":silent! /^[?,M,A,D,U] ", "n", false)
  util.press_enter()
  api.nvim_feedkeys(":noh", "n", false)
  util.press_enter()
end

local function jump_prev()
  api.nvim_feedkeys(":silent! ?^[?,M,A,D,U] ", "n", false)
  util.press_enter()
  api.nvim_feedkeys(":noh", "n", false)
  util.press_enter()
end

local toggle_status = function()
  local ft = vim.bo.filetype
  if ft == "fugitive" then
    api.nvim_command("bd")
  else
    local fugitive_tab = util.get_tab_by_buf_name("fugitive", true)
    if fugitive_tab ~= -1 then
      api.nvim_set_current_tabpage(fugitive_tab)
    end
    api.nvim_command("silent! :Git")
    api.nvim_feedkeys(api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
    jump_next()
  end
end

return {
  "tpope/vim-fugitive",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "tpope/vim-rhubarb",
  },
  config = function()
    local function map(mode, l, r, desc)
      local opts = { noremap = true, desc = desc }
      vim.keymap.set(mode, l, r, opts)
    end

    local function notify_cmd(km, cmd, title, msg)
      map("n", km, function()
        vim.notify(msg, "info", { title = title, timeout = 500 })

        vim.defer_fn(function()
          vim.cmd(cmd)
        end, 500)
      end, cmd)
    end

    -- Status
    map("n", "<leader>gs", toggle_status, "Toggle open/close of git status tab")

    -- Remote
    notify_cmd("<leader>gps", "Git push", "Git Push", "Pushing...")
    notify_cmd("<leader>gPs", "Git push --force", "Git Push", "Force Pushing...")
    notify_cmd("<leader>gpl", "Git pull", "Git Pull", "Pulling...")
    notify_cmd("<leader>gPl", "Git push --force", "Git Pull", "Force Pulling...")
    notify_cmd("<leader>gpo", "Git push -u origin main", "Git Push", "Pushing to origin (main)...")
    map("n", "<leader>gpu", ":Git push -u<Space>", "Populate git push set upstream")
    map("n", "<leader>gra", ":Git remote add<Space>", "Populate git remote add")
    map("n", "<leader>grd", ":Git remote remove<Space>", "Populate git remote remove")
    map("n", "<leader>grl", ":Git remote -v<CR>", "List git remotes verbosely")
    map("n", "<leader>gor", ":Git remote<Space>", "Populate git remote")

    -- Work Tree (WT) & Staging
    map("n", "<leader>gab", ":Git add %:p<CR>", "Stage current buffer")
    map("n", "<leader>gub", ":Git restore --staged %:p<CR>", "Unstage current buffer")
    map("n", "<leader>gw", ":Gwrite<CR>", "Save and stage current buffer")
    map("n", "<leader>gm", ":GMove<Space>", "Rename and stage current buffer")
    map("n", "<leader>gx", ":Git restore %:p<CR>", "Reset current buffer")

    -- Objects (file, blob, tree, commit, tag, etc)
    map("n", "<leader>gou", ":GBrowse<CR>", "Open git object in browser at upstream hosting provider")

    -- Commit
    map("n", "<leader>gcc", ':Git commit -m ""<Left>', "Populate git commit -m")
    map("n", "<leader>gca", ":Git commit --amend<CR>", "Ammed the last commit")
    map("n", "<leader>gcm", ":Git commit<Space>", "Populate git commit")

    -- Branch
    map("n", "<leader>gbo", ":Git branch<Space>", "Populate git branch")
    map("n", "<leader>gbl", ":Git branch<CR>", "List git branches")
    map("n", "<leader>gbv", ":Git branch -vv<CR>", "List git branch & their remote tracking branches")
    map("n", "<leader>gba", ":Git checkout -b<Space>", "Populate git checkout -b")
    map("n", "<leader>gbr", ":Git branch -M<Space>", "Populate rename git branch")
    map("n", "<leader>gbd", ":Git branch -d<Space>", "Populate delete git branch")
    map("n", "<leader>gbD", ":Git branch -D<Space>", "Populate force delete git branch")

    -- Checkout
    map("n", "<leader>gco", ":Git checkout<Space>", "Populate git checkout")

    -- Stash
    map("n", "<leader>gzz", ":Git stash -u<CR>", "Push stash in both WT and index (including untracked files)")
    map("n", "<leader>gzw", ":Git stash -u --keep-index<CR>", "Push stash on WT only (including untracked files)")
    map("n", "<leader>gza", ":Git stash apply<CR>", "Apply the top most stash")
    map("n", "<leader>gzA", ":Git stash apply<Space>", "Populate apply stash")
    map("n", "<leader>gzp", ":Git stash pop<CR>", "Pop the top most stash")
    map("n", "<leader>gzP", ":Git stash pop<Space>", "Populate pop stash")
    map("n", "<leader>gzd", ":Git stash drop<CR>", "Drop the top most stash")
    map("n", "<leader>gzD", ":Git stash drop<Space>", "Populate drop stash")
    map("n", "<leader>gzl", ":Git stash list<CR>", "List all the stashes")
    map("n", "<leader>gzo", ":Git stash<Space>", "Populate git stash")

    -- Rebase
    map("n", "<leader>gri", ":Git rebase -i<Space>", "Populate interactive rebase")
    map("n", "<leader>grn", ":Git rebase -i HEAD~<Space>", "Populate interactive rebase with count from HEAD")
    map("n", "<leader>grr", ":Git rebase --continue<CR>", "Continue with current rebase")
    map("n", "<leader>grx", ":Git rebase --abort<CR>", "Abort the current rebase")
    map("n", "<leader>gre", ":Git rebase --edit-todo<CR>", "Edit todo list of current rebase")
    map("n", "<leader>gro", ":Git rebase<Space>", "Populate git rebase")

    -- Merge
    map("n", "<leader>gmo", ":Git merge<Space>", "Populate git merge")
    map("n", "<leader>gmt", ":Git mergetool<CR>", "Open merge tool") -- I prefer to use diffview to easily fix merge conficts
    map("n", "<leader>gmr", ":Git merge --continue<CR>", "Continue with the merge")
    map("n", "<leader>gmx", ":Git merge --abort", "Abort merge")

    -- Cherry Pick
    map("n", "<leader>gyi", ":Git cherry-pick<Space>", "Populate git cherry-pick")
    map("n", "<leader>gyr", ":Git cherry-pick --continue<CR>", "Continue with the cherry-pick")
    map("n", "<leader>gyx", ":Git cherry-pick --abort<CR>", "Abort cherry-pick")

    -- Reset
    map("n", "<leader>grh", ":Git reset HEAD^<CR>", "Reset the last commit")
    map("n", "<leader>gRh", ":Git reset --hard HEAD^<CR>", "Hard reset the last commit")
    map("n", "<leader>grk", ":Git reset HEAD~<Space>", "Populate reset from a given commit count from HEAD")
    map("n", "<leader>gRk", ":Git reset --hard HEAD~<Space>", "Populate hard reset from a given commit count from HEAD")
    map("n", "<leader>grO", ":Git reset<Space>", "Populate git reset")

    -- Initialize a repo
    map("n", "<leader>gi", ":Git init<CR>", "Create a repo")
  end,
  jump_next = jump_next,
  jump_prev = jump_prev,
}
