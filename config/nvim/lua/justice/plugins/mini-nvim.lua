return {
  "echasnovski/mini.nvim",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.surround").setup()
  end,
}
