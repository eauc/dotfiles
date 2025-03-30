local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require("telescope-live-grep-args.actions")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

telescope.setup({
  defaults = {
    path_display = { truncate = 1 },
    prompt_prefix = ' > ',
    selection_caret = '  ',
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<C-Down>'] = actions.cycle_history_next,
        ['<C-Up>'] = actions.cycle_history_prev,
        ['<C-h>'] = 'which_key',
        ["<C-k>"] = lga_actions.quote_prompt(),
        ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }),
        -- freeze the current list and start a fuzzy search in the frozen list
        ["<C-space>"] = actions.to_fuzzy_refine,
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

vim.keymap.set('n', '<leader>gg', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]],
  { desc = 'grep in files' })
vim.keymap.set('n', '<leader>gw', live_grep_args_shortcuts.grep_word_under_cursor, { desc = 'grep word under cursor' })
vim.keymap.set('v', '<leader>gv', live_grep_args_shortcuts.grep_visual_selection, { desc = 'grep selection' })

vim.keymap.set('n', '<leader>hf', [[<cmd>lua require('telescope.builtin').command_history()<CR>]],
  { desc = 'repeat recent command' })
vim.keymap.set('n', '<leader>hs', [[<cmd>lua require('telescope.builtin').search_history()<CR>]],
  { desc = 'repeat recent search' })

vim.keymap.set('n', '<leader>lr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]],
  { desc = 'find references' })
vim.keymap.set('n', '<leader>ld', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
  { desc = 'show document symbols' })

vim.keymap.set('n', '<leader>bb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { desc = 'find buffer' })
vim.keymap.set('n', '<leader>dd', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]],
  { desc = 'list all diagnostics' })
vim.keymap.set('n', '<leader>pp', [[<cmd>lua require('telescope.builtin').registers()<CR>]],
  { desc = 'paste from register' })
vim.keymap.set('n', '<leader>ss', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]],
  { desc = 'spell suggest' })
vim.keymap.set('n', '<leader>tt', [[<cmd>lua require('telescope.builtin').treesitter()<CR>]],
  { desc = 'show treesitter symbols' })
