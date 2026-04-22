vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.opt.termguicolors = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'custom.plugins.lualine',
  require 'custom.plugins.catppuccin',
  require 'custom.plugins.lspconfig',
  require 'custom.plugins.whichkey',
  require 'custom.plugins.telescope',
  require 'custom.plugins.mini',
  require 'custom.plugins.gitsigns',
  require 'custom.plugins.database',
  require 'custom.plugins.eyeliner',
  require 'custom.plugins.scratch',
  -- require 'custom.plugins.leap',
  -- require 'custom.plugins.angular',
  require 'custom.plugins.visual-multi',
  -- require 'custom.plugins.sonarlint',
  require 'custom.plugins.lazygit',
  require 'custom.plugins.diffview',
  require 'custom.plugins.dap_virtual_text',
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim.lsp.config('angularls', {
--   cmd = {
--     'node',
--     '--max-old-space-size=12960',
--     os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/angular-language-server/node_modules/@angular/language-server/bin/ngserver',
--     '--stdio',
--     '--tsProbeLocations',
--     os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib',
--     '--ngProbeLocations',
--     os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/angular-language-server/node_modules/@angular/language-server',
--   },
-- })
-- Get the base data directory (cross-platform)
local data_path = vim.fn.stdpath 'data'

-- 1. Angular Configuration
local mason_pkg = vim.fs.normalize(vim.fn.stdpath 'data' .. '/mason/packages')
local project_root = vim.fn.getcwd()

vim.lsp.config('angularls', {
  cmd = {
    'node',
    '--max-old-space-size=12960',
    vim.fs.normalize(mason_pkg .. '/angular-language-server/node_modules/@angular/language-server/bin/ngserver'),
    '--stdio',
    '--tsProbeLocations',
    vim.fs.normalize(project_root .. '/node_modules'),
    '--ngProbeLocations',
    vim.fs.normalize(mason_pkg .. '/angular-language-server/node_modules/@angular/language-server/bin'),
  },
  root_dir = vim.fs.root(0, { 'angular.json', 'package.json' }),
  -- This is the "Truth" check
  on_init = function(client)
    vim.notify('AngularLS is initializing workspace: ' .. client.root_dir, vim.log.levels.INFO)
    return true
  end,
  -- Force some flags so they aren't nil
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
})

-- 2. VTSLS (The TypeScript Server)
vim.lsp.config('vtsls', {
  -- Use the .cmd wrapper for Windows stability
  cmd = { vim.fs.normalize(mason_pkg .. '/vtsls/node_modules/.bin/vtsls.cmd'), '--stdio' },
  settings = {
    typescript = {
      tsserver = {
        maxTsServerMemory = 8192,
      },
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
})

-- 3. HTML (Already in your Mason list)
vim.lsp.config('html', {
  filetypes = { 'html', 'htmlangular' },
})

-- 4. Lua (For your config files)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})

-- 5. Enable everything
vim.lsp.enable 'angularls'
vim.lsp.enable 'vtsls'
vim.lsp.enable 'html'
vim.lsp.enable 'lua_ls'

local lint = require 'lint'

lint.linters_by_ft = {
  python = { 'ruff', 'mypy' },
}

-- Trigger linting on save and enter
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
  callback = function()
    lint.try_lint()
  end,
})

local lspconfig = require 'lspconfig'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
vim.keymap.set('n', '<leader>gb', function()
  require('telescope.builtin').git_bcommits {
    theme = 'dropdown',
    attach_mappings = function(_, map)
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      -- Define the custom action
      local open_diffview = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('DiffviewOpen ' .. selection.value)
      end

      -- Map this action to both modes
      map('i', '<CR>', open_diffview)
      map('n', '<CR>', open_diffview)

      -- Return true to indicate we have handled the mapping,
      -- preventing the default 'git checkout' behavior
      return true
    end,
  }
end, { desc = 'Git diff file against commit' })

vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = 'DAP Hover' })

-- Add this at the bottom of your init.lua
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= 'angularls' then
      return
    end

    local value = ev.data.params.value
    if not value then
      return
    end

    -- AngularLS sends 'begin', 'report', and 'end'
    if value.kind == 'begin' then
      vim.api.nvim_echo({ { ' AngularLS: Indexing Workspace...', 'WarningMsg' } }, false, {})
    elseif value.kind == 'report' then
      local msg = value.message or 'Analyzing files...'
      -- Use nvim_echo to keep it on the command line without creating a history popup
      vim.api.nvim_echo({ { ' AngularLS: ' .. msg, 'WarningMsg' } }, false, {})
    elseif value.kind == 'end' then
      vim.api.nvim_echo({ { ' AngularLS: Ready', 'DiagnosticOk' } }, false, {})
      -- Clear the message after 2 seconds
      vim.defer_fn(function()
        vim.api.nvim_echo({ { '', '' } }, false, {})
      end, 2000)
    end
  end,
})
