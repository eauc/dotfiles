require('neorg').setup({
  load = {
    ["core.defaults"] = {},       -- Loads default behaviour
    ["core.export"] = {}, -- Adds pretty icons to your documents
    ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.norg.completion"] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ["core.presenter"] = {
      config = {
        zen_mode = 'zen-mode',
      },
    },
  },
})
