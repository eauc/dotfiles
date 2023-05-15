require('nvim-tree').setup({
  git = {
    ignore = false,
  },
  renderer = {
    highlight_opened_files = '1',
    group_empty = true,
    icons = {
      show = {
        folder_arrow = false,
      },
    },
    indent_markers = {
      enable = true,
    },
  },
  view = {
    width = {
      min = 30,
      max = -1,
    },
  },
})

vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>', { desc = 'files tree' })
