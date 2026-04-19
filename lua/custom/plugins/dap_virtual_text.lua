return {
  'theHamsta/nvim-dap-virtual-text',
  opts = {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    show_stop_reason = true,
    -- Keeps your screen clean by truncating huge variable outputs
    commented = false,
    only_first_definition = true,
  },
}
