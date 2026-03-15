return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- Optional.
    'saghen/blink.cmp',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<leader>so',
      function()
        -- Telescope live grep scoped to frontmatter identity fields only.
        -- User types freely; input is wrapped into a regex matching only
        -- frontmatter lines (id:, title:, aliases list items).
        local pickers = require 'telescope.pickers'
        local finders = require 'telescope.finders'
        local conf = require('telescope.config').values
        local make_entry = require 'telescope.make_entry'

        local vault_dir = tostring(Obsidian.dir)
        local grep_cmd = vim.list_extend(
          { 'rg', '--no-config', '--type=md', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--pcre2' },
          {}
        )

        pickers
          .new({}, {
            prompt_title = 'Notes (tags/aliases)',
            debounce = 100,
            finder = finders.new_job(function(prompt)
              if not prompt or prompt == '' then
                return nil
              end
              -- Escape special regex chars in user input for safe PCRE2 embedding
              local escaped = prompt:gsub('([%.%+%*%?%[%]%^%$%(%)%{%}%|\\])', '\\%1')
              -- Build regex: match the user's term only on frontmatter identity lines
              local pattern = '(?:^(?:id|tags|aliases):\\s*|^\\s+-\\s+).*' .. escaped
              return vim.list_extend(vim.list_slice(grep_cmd), { '-e', pattern, vault_dir })
            end, make_entry.gen_from_vimgrep {}, nil, vault_dir),
            previewer = conf.grep_previewer {},
            sorter = require('telescope.sorters').empty(),
          })
          :find()
      end,
      desc = 'Obsidian: Search notes by tags/aliases',
    },
  },
  ---@module 'obsidian'
  ---@type obsidian.config.ClientOpts
  opts = {
    ui = { enable = false }, -- conceallevel mangles chars around the replaced symbols, had to disable this feature
    legacy_commands = false,
    workspaces = {
      {
        name = 'default',
        path = '~/workspace/personal/obsidian-default',
      },
      {
        name = 'personal',
        path = '~/workspace/personal/personal-vault',
      },
      {
        name = 'vt',
        path = '~/workspace/personal/vt-vault',
      },
    },
  },
}
