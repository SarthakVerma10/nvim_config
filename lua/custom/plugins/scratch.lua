return {
  'LintaoAmons/scratch.nvim',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', '<leader>sn', '<cmd>Scratch<cr>')
  end,
}
