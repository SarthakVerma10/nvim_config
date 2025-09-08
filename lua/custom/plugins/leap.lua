return {
  'ggandor/leap.nvim',
  name = 'leap',
  config = function()
    require('leap').setup {}
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward)')
    vim.keymap.set('n', 'gf', '<Plug>(leap-from-window)')
  end,
}
