require('mini.files').setup({
  windows = {
    preview = true,
  },
})

vim.keymap.set('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
