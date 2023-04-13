vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('', '<Up>', '5<C-u>')
vim.keymap.set('', '<Down>', '5<C-d>')
vim.keymap.set('', '<Left>', '<Nop>')
vim.keymap.set('', '<Right>', '<Nop>')

vim.keymap.set('n', '<leader>k', ':nohlsearch<CR>', { desc = 'un-highlight search' })
vim.keymap.set('n', '<leader>q', ':bdelete<CR>', { desc = 'close buffer' })

-- Allow gf to open non-existent files
vim.keymap.set('', 'gf', ':edit <cfile><CR>', { desc = 'goto file' })

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

-- Easy insertion of a trailing ; or , from insert mode
-- vim.keymap.set('i', ';;', '<Esc>A;<Esc>')
-- vim.keymap.set('i', ',,', '<Esc>A,<Esc>')

-- Open the current file in the default program (on Mac this should just be just `open`)
vim.keymap.set('n', '<leader>x', ':!xdg-open %<cr><cr>', { desc = 'open file with default app' })

-- Disable annoying command line thing
vim.keymap.set('n', 'q:', ':q<CR>')

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

-- Move text up and down
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv")
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv")
