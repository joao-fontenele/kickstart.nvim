return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      -- local sign = vim.fn.sign_define
      --
      -- sign('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      -- sign('DapBreakpointCondition', { text = '🔴', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
      -- sign('DapLogPoint', { text = '🔴', texthl = 'DapLogPoint', linehl = '', numhl = '' })
      -- sign('DapStopped', { text = '🔴', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      ui.setup()

      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })

      -- in case of exceptions this might be helpful
      vim.keymap.set('n', '<F7>', ui.toggle, { desc = 'Debug: See last session result.' })

      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })

      dap.listeners.after.event_initialized['dapui_config'] = ui.open
      dap.listeners.before.event_terminated['dapui_config'] = ui.close
      dap.listeners.before.event_exited['dapui_config'] = ui.close
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function(_, opts)
      local dapgo = require 'dap-go'

      dapgo.setup(opts)
      vim.keymap.set('n', '<leader>dgt', dapgo.debug_test, { desc = '[D]ebug nearest [G]o [T]est' })
      vim.keymap.set('n', '<leader>dgl', dapgo.debug_last_test, { desc = '[D]ebug [G]o [L]ast test' })
    end,
  },
}
