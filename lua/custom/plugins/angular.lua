return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      angularls = {
        -- Override the default command to increase memory
        cmd = {
          'node',
          '--max-old-space-size=8192', -- 8GB heap
          vim.fn.stdpath 'data' .. '/mason/packages/angular-language-server/node_modules/@angular/language-server/index.js',
          '--ngProbeLocations',
          vim.fn.stdpath 'data' .. '/mason/packages/angular-language-server/node_modules',
          '--tsProbeLocations',
          vim.fn.stdpath 'data' .. '/mason/packages/angular-language-server/node_modules',
        },
        on_attach = function(client, bufnr)
          require('lazyvim.util').lsp.on_attach(client, bufnr)
        end,
      },
    },
  },
}
