return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.60,
            preview_cutoff = 100,
            prompt_position = "top",
          },
        },
        sorting_strategy = "ascending",
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("harpoon")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume the last telescope list" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope harpoon marks<cr>", { desc = "Fuzzy find harpoon marked files" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Fuzzy find todos" })

    keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Fuzzy find neovim config files" })

    keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        previewer = false,
      }))
    end, { desc = "Fuzzily search in current buffer" })

    keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "Search in Open files" })
  end,
}
