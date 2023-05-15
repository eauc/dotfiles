require("trouble").setup({})

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  { desc = 'toggle trouble', silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { desc = 'toggle workspace diagnostics', silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = 'toggle file diagnostics', silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  { desc = 'toggle location list', silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  { desc = 'toggle quickfix list', silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>",
  { desc = 'toggle references list', silent = true, noremap = true }
)

-- diagnostic
vim.diagnostic.config({
  virtual_text = false,
  float = {
    source = true,
  },
})

vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'open diagnostics' })
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'previous diagnostic' })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'next diagnostic' })

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
