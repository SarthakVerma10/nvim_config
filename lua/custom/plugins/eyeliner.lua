return {
  'jinh0/eyeliner.nvim',
  config = function()
    vim.api.nvim_set_hl(0, 'EyelinerPrimary', { bold = true, underline = true, fg = '#ff00f2' })
    vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true, fg = '#00ff0e' })
  end,
}
