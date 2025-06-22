return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function(_, opts)
      local harpoon = require 'harpoon'
      harpoon.setup(opts)
      vim.keymap.set('n', '<C-a>', function()
        harpoon:list():add()
      end, { desc = 'Add Buffer to Harpoon' })

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<S-Tab>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<Tab>', function()
        harpoon:list():next()
      end)
    end,
  },
}
