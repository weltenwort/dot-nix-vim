require("lze").load({
	{
		"nixd",
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "nixfmt" },
					},
					diagnostic = {
						suppress = { "sema-extra-with" },
					},
				},
			},
		},
	},
	{
		"conform.nvim",
		merge = true,
		formatters_by_ft = {
			nixd = { "nixd" },
		},
	},
})
