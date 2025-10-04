require("lze").load({
	{
		"neogit",
		cmd = { "Neogit" },
		on_require = { "neogit" },
		after = function()
			require("neogit").setup()
		end,
	},
})
