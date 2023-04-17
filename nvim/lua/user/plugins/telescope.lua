local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    path_display = { truncate = 1 },
    prompt_prefix = '   ',
    selection_caret = '  ',
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<C-Down>'] = actions.cycle_history_next,
        ['<C-Up>'] = actions.cycle_history_prev,
      },
    },
    file_ignore_patterns = { '.git/' },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      previewer = false,
      layout_config = {
        width = 80,
      },
    },
    oldfiles = {
      prompt_title = 'History',
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')

vim.keymap.set('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { desc = 'find file' })
vim.keymap.set('n', '<leader>fF',
[[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]],
{ desc = 'find file (include ignored)' })
vim.keymap.set('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { desc = 'find recent file' })

vim.keymap.set('n', '<leader>bb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { desc = 'find buffer' })

vim.keymap.set('n', '<leader>gg', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]],
{ desc = 'grep in files' })
vim.keymap.set('n', '<leader>gr', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
{ desc = 'find references' })
