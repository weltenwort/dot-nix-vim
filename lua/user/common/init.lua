vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('mini.basics').setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = 'default',
  },
  mappings = {
    basic = true,
    option_toggle_prefix = '<leader>t',
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = true,
  },
})
require('mini.extra').setup()
require('mini.icons').setup()
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none(),
  },
})
require('mini.notify').setup()
require('mini.pairs').setup()
require('mini.pick').setup()
require('mini.sessions').setup()
require('mini.starter').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()

require('user.common.plugin-mini-files')
require('user.common.plugin-telescope')

require('lze').register_handlers(require('lzextras').lsp)
