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
