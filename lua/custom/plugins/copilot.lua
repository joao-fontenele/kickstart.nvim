return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    version = 'v3.4.0',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' }, -- Use telescope for help actions
      { 'nvim-lua/plenary.nvim' },
      { 'zbirenbaum/copilot.lua' },
    },
    build = 'make tiktoken',
    config = function()
      local chat = require 'CopilotChat'
      -- local actions = require 'CopilotChat.actions'
      local select = require 'CopilotChat.select'
      -- local integration = require 'CopilotChat.integrations.fzflua'

      chat.setup {
        model = 'claude-3.7-sonnet',
        question_header = '## User ',
        answer_header = '## Bot ',
        error_header = '## Error',
        selection = select.visual,
        mappings = {
          reset = {
            normal = '',
            insert = '',
          },
        },
        prompts = {
          Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
          },
          Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
          },
          Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
          },
          Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
          },
          Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
          },
          Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
          },
          Commit = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
          },
        },
      }

      -- vim.api.nvim_create_autocmd('BufEnter', {
      --   pattern = 'copilot-*',
      --   function()
      --     vim.opt_local.relativenumber = false
      --     vim.opt_local.number = false
      --   end,
      --   group = group,
      -- })

      vim.keymap.set('n', '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
      vim.keymap.set('v', '<leader>aa', chat.open, { desc = 'AI Open' })
      vim.keymap.set('n', '<leader>ax', chat.reset, { desc = 'AI Reset' })
      vim.keymap.set('n', '<leader>as', chat.stop, { desc = 'AI Stop' })
      -- vim.keymap.set('n', '<leader>am', chat.select_model, { desc = 'AI Model' })
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ap', function()
      --   integration.pick(actions.prompt_actions(), {
      --     fzf_tmux_opts = {
      --       ['-d'] = '45%',
      --     },
      --   })
      -- end, { desc = 'AI Prompts' })
      vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
        vim.ui.input({
          prompt = 'AI Question> ',
        }, function(input)
          if input and input ~= '' then
            chat.ask(input)
          end
        end)
      end, { desc = 'AI Question' })
    end,
  },
}
