require("lze").load({
  {
    "lua_ls",
    lsp = {},
  },
  {
    "conform.nvim",
    merge = true,
    formatters_by_ft = {
      lua = { "stylua" },
    },
  },
})
