return {
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
    },
    -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = 'npm install -g mcp-hub@latest', -- Installs required mcp-hub npm module
    config = function()
      require('mcphub').setup {
        -- Required options
        port = 4000, -- Port for MCP Hub server
        config = vim.fn.expand '~/.config/mcp/servers.json', -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          -- Called on ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = 'MCPHub',
        },
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = 'gemini',
      -- provider = 'copilot',
      providers = {
        gemini = {
          model = 'gemini-2.5-pro-preview-06-05',
        },
        copilot = {
          model = 'claude-sonnet-4',
        },
        claude = {},
      },
      -- add any opts here
      -- for example
      -- provider = 'gemini', -- 'copilot',
      -- gemini = {
      --   -- model = 'gemini-2.5-pro-preview-05-06',
      --   -- model = 'gemini-2.5-pro-exp-03-25',
      --   model = 'gemini-2.5-pro-preview-03-25',
      -- },
      system_prompt = function()
        -- A helper function to read file content safely.
        local function read_file(path)
          local expanded_path = vim.fn.expand(path)
          local file = io.open(expanded_path, 'r')
          if not file then
            vim.notify('Custom prompt file not found at: ' .. expanded_path, vim.log.levels.WARN)
            return ''
          end
          local content = file:read '*a'
          file:close()
          return content
        end

        -- Read the custom prompt and the MCP Hub prompt.
        local file_prompt = read_file '~/workspace/personal/dotfiles/llm/LLM-CONVENTIONS.md'
        local hub = require('mcphub').get_hub_instance()
        local mcp_prompt = ''
        if hub then
          mcp_prompt = hub:get_active_servers_prompt()
        end

        -- Combine the prompts.
        local final_prompt = file_prompt .. '\n' .. mcp_prompt
        return final_prompt
      end,
      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      -- 'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      -- 'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      'ravitemer/mcphub.nvim',
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
