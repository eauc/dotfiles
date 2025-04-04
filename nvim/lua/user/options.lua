vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.spell = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.breakindent = true -- maintain indent when wrapping indented lines
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars:append({ eob = ' ' }) -- remove the ~ from end of buffer
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.clipboard = 'unnamedplus' -- Use Linux system clipboard
vim.opt.confirm = true -- ask for confirmation instead of erroring      
vim.opt.undofile = true -- persistent undo
vim.opt.backup = true -- automatically save a backup file
vim.opt.backupdir:remove('.') -- keep backups out of the current directory
vim.opt.shortmess:append({ I = true }) -- disable the splash screen
vim.opt.wildmode = 'longest:full,full' -- complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.signcolumn = 'yes:2'
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.wo.cursorline = true
vim.diagnostic.config({
  float = {
    source = true,
  },
  jump = {
    float = true,
  },
  virtual_text = false,
})
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#F00000', bold = true })
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#00C0F0', bold = true })
vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#8A6240', bold = true })
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#00F0C0', bold = true })
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#F000F0', bold = true })
