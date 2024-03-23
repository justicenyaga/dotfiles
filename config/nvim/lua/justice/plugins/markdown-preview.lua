return {
  {
    "iamcco/markdown-preview.nvim",
    event = "BufRead",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      local opts = { noremap = true, silent = true }

      opts.desc = "Toggle markdown preview"
      vim.keymap.set("n", "<leader>mdp", ":MarkdownPreview<CR>", opts) -- Start the preview

      opts.desc = "Stop markdown preview"
      vim.keymap.set("n", "<leader>mdx", ":MarkdownPreviewStop<CR>", opts) -- Stop the preview
    end,
  },
}
