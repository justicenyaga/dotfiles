return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Desktop", "~/Documents", "~/Downloads", "~/projects" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", ":SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", ":SessionSave<CR>", { desc = "Save session for auto session root dir" })
  end,
}
