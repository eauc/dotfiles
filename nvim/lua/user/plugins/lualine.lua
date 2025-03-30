local separator = { '"▏"' }

require('lualine').setup({
  options = {
    section_separators = '',
    component_separators = '',
    globalstatus = true,
    theme = 'ayu_light',
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {
      'branch',
      'diff',
      separator,
      '"🖧  " .. tostring(#vim.tbl_keys(vim.lsp.get_clients({ bufnr = 0 })))',
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
      '"󱃖 " .. vim.fn["codeium#GetStatusString"]()',
    },
    lualine_c = {
      'filename'
    },
    lualine_x = {
      'filetype',
      'encoding',
      'fileformat',
    },
    lualine_y = {
      '(vim.bo.expandtab and "SPC" or "TAB") .. " " .. vim.bo.shiftwidth',
    },
    lualine_z = {
      'location',
      'progress',
    },
  },
})
