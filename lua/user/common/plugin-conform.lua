require("lze").load({
	"conform.nvim",
	merge = true,
	event = { "BufWritePre" },
	keys = {
		{
			"<leader>cf",
			function()
				return require("conform").format()
			end,
			desc = "format file",
		},
	},
	formatters = {},
	formatters_by_ft = {},
	after = function(plugin)
		require("conform").setup({
			formatters = plugin.formatters,
			formatters_by_ft = plugin.formatters_by_ft,
			default_format_opts = {
				lsp_format = "fallback",
				timeout_ms = 1000,
			},
			format_on_save = {},
			notify_on_error = true,
		})
	end,
})
