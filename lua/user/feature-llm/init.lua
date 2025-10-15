require("lze").load({
	{
		"codecompanion.nvim",
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCmd",
		},
		after = function()
			require("codecompanion").setup()
		end,
	},
	{
		"copilot.lua",
		cmd = {
			"Copilot",
		},
		after = function()
			require("copilot").setup({
				should_attach = function(_, bufname)
					if string.match(bufname, "env") then
						return false
					end

					return true
				end,
			})
		end,
	},
})
