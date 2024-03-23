return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- import mason-tool-installer
    local mason_tool_installer = require("mason-tool-installer")

    -- import mason-nvim-dap
    local mason_nvim_dap = require("mason-nvim-dap")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        border = "rounded",
        height = 0.8,
        width = 0.7,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "cssls",
        "clangd",
        "emmet_ls",
        "gopls",
        "graphql",
        "html",
        "jdtls",
        "lua_ls",
        "prismals",
        "pyright",
        "svelte",
        "tailwindcss",
        "tsserver",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "black", -- python formatter
        "clang-format", -- c/cpp formatter
        "eslint_d", -- js linter
        "gofumpt", -- Go formatter
        "goimports", -- Go formatter
        "golangci-lint", -- Go linter
        "golines", -- Go formatter
        "isort", -- python formatter
        "prettier", -- prettier formatter
        "pylint", -- python linter
        "stylua", -- lua formatter
      },
    })

    mason_nvim_dap.setup({
      -- list of debuger adapters for mason to install
      ensure_installed = {
        "delve", -- Go debugger
      },
    })
  end,
}
