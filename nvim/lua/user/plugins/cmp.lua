local cmp = require('cmp')
local lspkind = require('lspkind')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,longest,preview'

cmp.setup({
  experimental = {
    ghost_text = false,
  },
  formatting = {
    format = lspkind.cmp_format(),
  },
  mapping = {
    ['<A-CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<A-right>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<A-left>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'buffer' },
    -- { name = 'codeium' },
    { name = 'cmdline' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'neorg' },
    { name = 'path' },
    { name = 'conjure' },
  },
})
