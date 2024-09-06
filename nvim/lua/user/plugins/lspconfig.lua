require('mason').setup()
require('mason-lspconfig').setup({ automatic_installation = true })

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach_keymap = function()
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'goto definition' })
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'goto implementation' })
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'goto references' })
  vim.keymap.set('n', '<leader>HH', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'info hover' })
  vim.keymap.set('n', '<leader>HS', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'signature help' })
  vim.keymap.set('n', '<leader>ra', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'code action' })
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'refacto rename' })
  vim.keymap.set('n', '<leader>=', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { desc = 'format file' })
end

require('lspconfig').eslint.setup({
  capabilities = capabilities,
  on_attach = function()
    vim.keymap.set('n', '<leader>rf', '<cmd>EslintFixAll<CR>', { desc = 'eslint fix all' })
  end,
})

require('lspconfig').clojure_lsp.setup({
  on_attach = on_attach_keymap,
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

require('lspconfig').ts_ls.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    on_attach_keymap()
  end,
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

require('lspconfig').zls.setup({
  capabilities = capabilities,
  on_attach = on_attach_keymap,
})
