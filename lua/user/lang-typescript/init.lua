local eslint_d_config = { "eslint_d" }

require("lze").load({
	{
		"ts_ls",
		lsp = {},
	},
	{
		"conform.nvim",
		merge = true,
		formatters_by_ft = {
			javascript = eslint_d_config,
			javascriptreact = eslint_d_config,
			typescript = eslint_d_config,
			typescriptreact = eslint_d_config,
		},
	},
})
