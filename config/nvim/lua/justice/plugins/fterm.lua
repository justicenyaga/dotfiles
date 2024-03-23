local api, keymap = vim.api, vim.keymap

api.nvim_create_autocmd("User", {
  pattern = "UnceptionEditRequestReceived",
  callback = function()
    -- Toggle the terminal off.
    require("FTerm").toggle()
  end,
})

return {
  "numToStr/FTerm.nvim",
  config = function()
    local fTerm = require("FTerm")

    fTerm.setup({
      border = "rounded",
      dimensions = {
        height = 0.7,
        width = 0.65,
      },
    })

    keymap.set("n", "<C-z>", function()
      fTerm.toggle()
    end, { desc = "Toggle Fterm terminal in normal mode" })

    keymap.set("t", "<C-z>", function()
      api.nvim_feedkeys(
        api.nvim_replace_termcodes("<C-\\><C-n>:lua require('FTerm').toggle()<CR>", false, true, true),
        "n",
        false
      )
    end, { desc = "Toggle Fterm terminal in terminal mode" })

    -- -- Configure FTerm settings
    -- require("FTerm").setup({
    --   border = "none",
    --   ft = "terminal",
    --   dimensions = {
    --     height = 0.5,
    --     width = 1,
    --     x = 0, -- X axis of the terminal window
    --     y = 1, -- Y axis of the terminal window
    --   },
    -- })
    -- api.nvim_create_autocmd("FileType", {
    --   pattern = "terminal",
    --   callback = function()
    --     -- Create a namespace for the current buffer's filetype
    --     local ns = api.nvim_create_namespace(vim.bo.filetype)
    --     -- Set the highlight namespace for the current window
    --     api.nvim_win_set_hl_ns(0, ns)
    --     -- Set the background color for the highlight namespace
    --     api.nvim_set_hl(ns, "Normal", { bg = "#171717" })
    --   end,
    -- })
  end,
}
