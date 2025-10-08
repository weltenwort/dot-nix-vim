require("mini.jump2d").setup()

vim.keymap.set("n", "<leader>jj", function()
	require("mini.jump2d").start(require("mini.jump2d").builtin_opts.single_character)
end, {
	desc = "jump to character",
})
