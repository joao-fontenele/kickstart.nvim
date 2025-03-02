return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'zidhuss/neotest-minitest',
      'fredrikaverpil/neotest-golang',
    },
    config = function()
      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run()
      end, { desc = 'Test nearest function' })

      require('neotest').setup {
        adapters = {
          require 'neotest-golang',
          require 'neotest-minitest',
        },
      }
    end,
  },
}
