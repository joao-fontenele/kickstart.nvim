return {
  {
    'stevearc/oil.nvim',
    opts = {
      delete_to_thrash = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
      local oil = require 'oil'
      oil.setup(opts)

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
}
