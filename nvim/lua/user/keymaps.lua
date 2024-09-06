vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.keymap.set('', '<Up>', '5<C-u>')
-- vim.keymap.set('', '<Down>', '5<C-d>')
-- vim.keymap.set('', '<Left>', '<Nop>')
-- vim.keymap.set('', '<Right>', '<Nop>')

vim.keymap.set('n', '<leader>k', ':nohlsearch<CR>', { desc = 'clear search' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'close buffer' })
vim.keymap.set('', '<C-PageUp>', ':bprevious<CR>', { desc = 'previous buffer' })
vim.keymap.set('', '<C-PageDown>', ':bnext<CR>', { desc = 'next buffer' })

-- Allow gf to open non-existent files
-- vim.keymap.set('', 'gf', ':edit <cfile><CR>', { desc = 'goto file' })

-- Reselect visual selection after indenting
vim.keymap.set('v', '<', '<gv', { desc = 'indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'indent right' })

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', 'myy`y')
vim.keymap.set('v', 'Y', 'myY`y')

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Paste replace visual selection without copying it
vim.keymap.set('v', 'p', '"_dP')

-- Open the current file in the default program (on Mac this should just be just `open`)
-- vim.keymap.set('n', '<leader>fx', ':!xdg-open %<cr><cr>', { desc = 'open file with default app' })

-- Disable annoying command line thing
vim.keymap.set('n', 'q:', ':q<CR>')

-- Move text up and down
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv")
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv")
