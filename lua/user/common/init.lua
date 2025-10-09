vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.diagnostic.config({
	virtual_text = true,
})

vim.opt.termguicolors = true

require("mini.basics").setup({
	options = {
		basic = true,
		extra_ui = true,
		win_borders = "default",
	},
	mappings = {
		basic = true,
		option_toggle_prefix = "<leader>t",
	},
	autocommands = {
		basic = true,
		relnum_in_visual_mode = true,
	},
})

require("mini.ai").setup()
require("mini.bufremove").setup()
require("mini.completion").setup()
require("mini.diff").setup()
require("mini.extra").setup()
require("mini.git").setup()
require("mini.icons").setup()
require("mini.indentscope").setup({
	draw = {
		animation = require("mini.indentscope").gen_animation.none(),
	},
})
require("mini.jump").setup()
require("mini.keymap").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.sessions").setup()
require("mini.snippets").setup()
require("mini.starter").setup({
	query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
})
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.tabline").setup()

require("lze").register_handlers(require("lzextras").merge)
require("lze").register_handlers(require("lzextras").lsp)

require("user.common.plugin-mini-files")
require("user.common.plugin-mini-jump2d")
require("user.common.plugin-telescope")
require("user.common.plugin-lspconfig")
require("user.common.plugin-conform")
require("user.common.plugin-treesitter")
require("user.common.plugin-neogit")

-- Completion keymaps
local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "minisnippets_next", "minisnippets_expand", "pmenu_next" })
map_multistep("i", "<S-Tab>", { "minisnippets_prev", "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

-- Buffer and window keymaps
vim.keymap.set("n", "<BS><BS>", ":b#<CR>", {
	desc = "Go to previously used buffer",
})
vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete()
end, {
	desc = "Delete buffer",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function(event)
		vim.keymap.set("n", "ä", "<C-]>", { buffer = event.buf, desc = "Follow help link with ä" })
	end,
})
