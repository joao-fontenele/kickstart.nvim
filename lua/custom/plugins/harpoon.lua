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

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():next()
      end)
    end,
  },
}
