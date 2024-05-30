return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Import harpoon plugin.
    local harpoon = require("harpoon")

    local keymap = vim.keymap -- for conciseness.

    -- Required:
    harpoon:setup()

    -- Keymaps:
    keymap.set("n", "<leader>a", function()
      harpoon:list():append()
    end, { desc = "Add current file to harpoon list" })

    keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        border = "rounded",
        title_pos = "center",
        ui_width_ratio = 0.5,
      })
    end, { desc = "Toggle open/close of harpoon list" })

    keymap.set("n", "<C-n>", function()
      harpoon:list():next()
    end, { desc = "Go the next marked file in the harpoon list" })

    keymap.set("n", "<C-p>", function()
      harpoon:list():prev()
    end, { desc = "Go the previous marked file in the harpoon list" })

    keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Open the first file in the harpoon list" })

    keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Open the second file in the harpoon list" })

    keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Open the third file in the harpoon list" })

    keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Open the fourth file in the harpoon list" })

    keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Open the fifth file in the harpoon list" })
  end,
}
