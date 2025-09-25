require("lze").load({
  "telescope.nvim",
  cmd = { "Telescope" },
  om_require = { "telescope" },
  keys = {
    {
      "<leader>ff",
      function() return require("telescope.builtin").find_files() end,
      desc = "find files",
    },
    {
      "<leader>fg",
      function() return require("telescope.builtin").live_grep() end,
      desc = "find in files",
    },
    {
      "<leader>fh",
      function() return require("telescope.builtin").help_tags() end,
      desc = "find helptags",
    },
    {
      "<leader>fk",
      function() return require("telescope.builtin").keymaps() end,
      desc = "find keymaps",
    },
    {
      "<leader>fm",
      function() return require("telescope.builtin").marks() end,
      desc = "find marks",
    },
    {
      "<leader>fr",
      function() return require("telescope.builtin").resume() end,
      desc = "resume last picker",
    },
    {
      "<leader>fb",
      function() return require("telescope.builtin").buffers({
        sort_lastused = true,
        sort_mru = true,
      }) end,
      desc = "find most recently used buffers",
    },
    {
      "+",
      function() return require("telescope.builtin").buffers({
        ignore_current_buffer = true,
        sort_lastused = true,
        sort_mru = true,
      }) end,
      desc = "find most recently used buffers",
    },
  },
  load = function (name)
    vim.cmd.packadd(name)
    vim.cmd.packadd("telescope-fzf-native.nvim")
  end,
  after = function (plugin)
    local telescope = require("telescope")
    
    telescope.setup({
      defaults = {
        layout_config = {
          flex = {
            prompt_position = "top",
          },
          horizontal = {
            prompt_position = "top",
          },
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
      },
    })

    telescope.load_extension("fzf")
  end,
})
