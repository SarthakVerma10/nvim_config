-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        'debugpy',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single', -- "single", "rounded", "double" help rendering stability
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          position = 'right',
          size = 40, -- This is the total width of the left panel in columns
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          position = 'bottom',
          size = 10, -- This is the height of the bottom panel in rows
        },
      },
    }
    vim.keymap.set({ 'n', 'v' }, '<leader>de', function()
      require('dapui').eval()
    end, { desc = 'Evaluate expression' })

    vim.keymap.set({ 'n' }, '<leader>dt', function()
      dapui.toggle()
    end, { desc = 'Toggle debug UI.' })

    vim.keymap.set('n', '<leader>dr', function()
      require('dapui').close()
      require('dapui').open()
    end, { desc = 'Debug: Refresh/Reset UI Layout' })

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
    require('dap-python').setup '/home/sarthak/python_projects/buesuite-be-core/.venv_313/bin/python'
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'FastAPI Launch',
        python = '/home/sarthak/python_projects/buesuite-be-core/.venv_313/bin/python',
        module = 'uvicorn',
        args = {
          'app.main:app', -- IMPORTANT: Change 'main' to your file name if it's not main.py
          '--reload',
        },
        console = 'integratedTerminal',
        -- If you want to see the FastAPI internals while stepping, set this to false
        justMyCode = true,
      },
      {
        type = 'python',
        request = 'attach',
        name = 'Attach remote (with path mapping)',
        connect = function()
          local host = vim.fn.input 'Host [127.0.0.1]: '
          host = host ~= '' and host or '127.0.0.1'
          local port = tonumber(vim.fn.input 'Port [5678]: ') or 5678
          return { host = host, port = port }
        end,
        pathMappings = function()
          local cwd = '${workspaceFolder}'
          local local_path = vim.fn.input('Local path mapping [' .. cwd .. ']: ')
          local_path = local_path ~= '' and local_path or cwd
          local remote_path = vim.fn.input 'Remote path mapping [.]: '
          remote_path = remote_path ~= '' and remote_path or '.'
          return { { localRoot = local_path, remoteRoot = remote_path } }
        end,
      },
    }
    local function refresh_dap_ui()
      if dap.session() then
        vim.defer_fn(function()
          dapui.close()
          dapui.open()
        end, 200) -- 200ms delay to let the terminal resize settle
      end
    end

    -- TRIGGER: Listen for both FocusGained and VimResized
    vim.api.nvim_create_autocmd({ 'FocusGained', 'VimResized' }, {
      pattern = '*',
      callback = refresh_dap_ui,
    })
  end,
}
