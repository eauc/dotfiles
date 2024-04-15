require('neorg').setup({
  load = {
    ["core.defaults"] = {},         -- Loads default behaviour
    ["core.dirman"] = {             -- Manages Neorg workspaces
      config = {
        workspaces = {
          dotfiles = "~/dotfiles",
        },
      },
    },
    ["core.concealer"] = {},          -- Adds pretty icons to your documents
    ["core.completion"] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ["core.export"] = {},
    ["core.presenter"] = {
      config = {
        zen_mode = 'zen-mode',
      },
    },
  },
})
