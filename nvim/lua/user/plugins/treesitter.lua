require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
    disable = { 'NvimTree' },
    additional_vim_regex_highlighting = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>v=",
      node_incremental = "=",
      -- scope_incremental = "+",
      node_decremental = "-",
    },
  },
})
