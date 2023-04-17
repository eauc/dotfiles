require('mason').setup()
require('mason-lspconfig').setup({ automatic_installation = true })
require("mason-null-ls").setup({ automatic_installation = true })

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach_keymap = function()
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'goto definition' })
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'goto implementation' })
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'goto references' })
  vim.keymap.set('n', '<leader>ra', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'code action' })
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'refacto rename' })
end

require('lspconfig').eslint.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>rf', '<cmd>EslintFixAll<CR>', { desc = 'eslint fix all' })
  end,
})

require('lspconfig').jsonls.setup({
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

require('lspconfig').lua_ls.setup({
  on_attach = on_attach_keymap,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

require('lspconfig').tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach_keymap,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
})

require('lspconfig').volar.setup({
  capabilities = capabilities,
  on_attach = on_attach_keymap,
})

vim.diagnostic.config({
  virtual_text = false,
  float = {
    source = true,
  },
})

require('null-ls').setup({
  root_dir = function()
    return nil
  end,
  sources = {
    require('null-ls').builtins.formatting.prettierd,
  },
})

vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'open diagnostics' })
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'previous diagnostic' })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'next diagnostic' })
vim.keymap.set('n', '<leader>=', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'format file' })

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
