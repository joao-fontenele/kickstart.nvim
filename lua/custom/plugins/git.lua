-- yank current buffer's relative path
vim.keymap.set('n', '<leader>gp', function()
  local filepath = vim.fn.expand '%'
  vim.fn.setreg('+', filepath)
  print 'copied relative path'
end, { desc = 'Yank relative [P]ath of current buffer', noremap = true, silent = true })

return {
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = '[Y]ank [G]it link' },
      { '<leader>gY', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open [G]it link' },
    },
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        numhl = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { desc = 'next change hunk', expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { desc = 'prev change hunk', expr = true })

          map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
          map('v', '<leader>hs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = '[H]unk [S]tage (Visual)' })
          map('v', '<leader>hr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = '[H]unk [R]eset (Visual)' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo stage' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
          map('n', '<leader>hb', function()
            gs.blame_line { full = true }
          end, { desc = '[H]unk [B]lame line (full)' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle current line [B]lame' })
          map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff this' })
          map('n', '<leader>hD', function()
            gs.diffthis '~'
          end, { desc = '[H]unk [D]iff this (~)' })
          map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle [D]eleted' })
        end,
      }
    end,
  },
}
