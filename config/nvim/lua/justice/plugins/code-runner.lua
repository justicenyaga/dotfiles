return {
  "CRAG666/code_runner.nvim",
  event = "BufRead",
  config = function()
    require("code_runner").setup({
      term = {
        position = "vert",
        size = 60,
      },
      filetype = {
        go = {
          "cd $dir &&",
          "go run $fileName",
        },
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        python = "python3 -u",
        javascript = "node",
      },
      project_path = vim.fn.expand("~/.config/nvim/projects.json"),
    })

    local function map(cmd)
      return function()
        local bufname = vim.fn.bufname("%")
        if bufname:find("crunner_") then
          vim.cmd("RunClose")
        else
          vim.cmd(cmd)
        end
      end
    end

    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>rf", map("RunCode"), { desc = "Toggle Run File" })
    keymap.set("n", "<leader>rp", map("RunProject"), { desc = "Toggle Run Project" })
  end,
}
