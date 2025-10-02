require("lze").load({
	{
		"codecompanion.nvim",
		after = function()
			require("codecompanion").setup()
		end,
	},
})
