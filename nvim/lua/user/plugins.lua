local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').reset()
require('packer').init({
  ensure_dependencies = true,
  compile_path        = vim.fn.stdpath('data') .. '/site/plugin/packer_compiled.lua',
  display             = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

local use = require('packer').use

use('wbthomason/packer.nvim')

use({
  -- visual theme
  'EdenEast/nightfox.nvim',
  tags = "*",
  config = function()
    require('nightfox').setup({
      options = {
        inverse = {
          match_paren = true,
        },
      },
      specs = {
        git = {
          add = 'green.bright',
        },
      },
      groups = {
        dayfox = {
          CursorLine = { bg = 'bg2' },
        },
      },
    })
    vim.cmd('colorscheme dayfox')
  end
})

use({
  -- status line at bottom
  'nvim-lualine/lualine.nvim',
  tags = "*",
  requires = 'kyazdani42/nvim-web-devicons',
  after = 'nightfox.nvim',
  config = function()
    require('user.plugins.lualine')
  end,
})

use({
  -- buffer line for open buffers at top
  'akinsho/bufferline.nvim',
  tags = "*",
  requires = 'kyazdani42/nvim-web-devicons',
  after = 'nightfox.nvim',
  config = function()
    require('user.plugins.bufferline')
  end,
})

use({
  -- smooth scrolling
  'karb94/neoscroll.nvim',
  tags = "*",
  config = function()
    require('neoscroll').setup()
  end,
})
--
-- use({
  --   -- rainbow parens
--   'luochen1990/rainbow',
--   config = function()
--     vim.g.rainbow_active = 1
--   end
-- })

-- use({ 'tpope/vim-commentary', tags = "*" })           -- better comments support
use({ 'tpope/vim-eunuch', tags = "*" })               -- unix file commands like :Copy etc
use({ 'tpope/vim-surround', tags = "*" })             -- edit surrounding pairs
-- use({ 'tpope/vim-unimpaired', tags = "*" })           -- [] keybindings
use({ 'tpope/vim-sleuth', tags = "*" })               -- buffer indent settings heuristics
use({ 'tpope/vim-repeat', tags = "*" })               -- support for command repeat with .
-- use({ 'sheerun/vim-polyglot', tags = "*" })           -- adds lot of prog langs support
use({ 'farmergreg/vim-lastplace', tags = "*" })       -- open files buffers at last edit place
use({ 'bronson/vim-visual-star-search', tags = "*" }) -- search for selected text with * or #
use({ 'jessarcher/vim-heritage', tags = "*" })        -- create parent directories when creating files
use({ 'sickill/vim-pasta', tags = "*" })              -- better support for indentation on paste

use({
  'luochen1990/rainbow',
  config = function()
    vim.g.rainbow_active = 1
  end
})

use({
  'folke/which-key.nvim',
  tags = "*",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup()
  end
})

use({
  'HiPhish/rainbow-delimiters.nvim',
  tags = "*",
})

use({
  -- indentation line visual markers
  'lukas-reineke/indent-blankline.nvim',
  tags = "*",
  dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
  config = function()
    require('user.plugins.ibl-rainbow')
  end,
})

use({
  -- jump to any place in view with s and S
  'ggandor/leap.nvim',
  tags = "*",
  requires = { 'tpope/vim-repeat' },
  config = function()
    require('leap').add_default_mappings()
  end
})

use({
  'nvim-telescope/telescope.nvim',
  tags = "*",
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    -- better search perf
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    -- support passing args to rg command
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
  },
  config = function()
    require('user.plugins.telescope')
  end,
})

use({
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  config = function()
    require('user.plugins.trouble')
  end
})

use({
  -- file explorer
  'kyazdani42/nvim-tree.lua',
  tags = "*",
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.nvim-tree')
  end,
})

use({
  -- git gutter
  'lewis6991/gitsigns.nvim',
  tags = "*",
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup()
    vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<CR>', { desc = 'next git diff' })
    vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'previous git diff' })
  end,
})

use({
  -- git commands
  'emmanueltouzery/agitator.nvim',
  tags = "*",
  config = function()
    vim.keymap.set('n', '<leader>Gb', '<cmd>lua require("agitator").git_blame_toggle()<CR>', { desc = 'git blame file' })
    vim.keymap.set('n', '<leader>Gt', '<cmd>lua require("agitator").git_time_machine()<CR>', { desc = 'git time machine' })
  end
})

use({
  -- git blame line
  'f-person/git-blame.nvim',
  tags = "*",
  config = function()
    vim.g.gitblame_enabled = 0
    vim.keymap.set('n', '<leader>GB', '<cmd>GitBlameToggle<CR>', { desc = 'toggle git blame line' })
    vim.keymap.set('n', '<leader>Gc', '<cmd>GitBlameCopySHA<CR>', { desc = 'copy current line commit sha' })
  end
})

use({
  'nvim-treesitter/nvim-treesitter',
  tags = "*",
  run = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  requires = {
    'nvim-treesitter/playground',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('user.plugins.treesitter')
  end,
})

use({
  -- fold based on treesitter
  'kevinhwang91/nvim-ufo',
  tags = "*",
  requires = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('user.plugins.nvim-ufo')
  end
})

use({
  -- completion
  'hrsh7th/nvim-cmp',
  tags = "*",
  requires = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'onsails/lspkind-nvim',
    'PaterJason/cmp-conjure'
  },
  config = function()
    require('user.plugins.cmp')
  end,
})

use({
  'neovim/nvim-lspconfig',
  tags = "*",
  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
  },
  config = function()
    require('user.plugins.lspconfig')
  end,
})

use({
  "rest-nvim/rest.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.filetype.add({ extension = { http = 'http' } })
    require("rest-nvim").setup()
  end
})

-- use({
--   'github/copilot.vim',
--   config = function()
--     -- vim.g.copilot_no_tab_map = true
--     -- vim.keymap.set('i', '<A-=>', 'copilot#Accept("<CR>")', { expr = true, silent = true })
--     vim.keymap.set('i', '<A-]>', '<Plug>(copilot-next)', { noremap = false })
--     vim.keymap.set('i', '<A-[>', '<Plug>(copilot-previous)', { noremap = false })
--     vim.keymap.set('i', '<A-g>', '<Plug>(copilot-dismiss)', { noremap = false })
--   end
-- })

use({
  'Exafunction/codeium.vim',
  tags = "*",
  config = function()
    -- vim.g.codeium_manual = true
    vim.g.codeium_disable_bindings = 1
    vim.keymap.set('i', '<A-=>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    vim.keymap.set('i', '<A-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    vim.keymap.set('i', '<A-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
    vim.keymap.set('i', '<A-g>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  end
})

use({
  -- clojure interactive client
  'Olical/conjure',
  tags = "*",
  config = function()
    vim.g['conjure#mapping#prefix'] = "<localleader>c"
    vim.g['conjure#highlight#enabled'] = true
    vim.g['conjure#client_on_load'] = false
  end
})

use({
  "nvim-neorg/neorg",
  tag = "*",
  requires = {
    -- sudo apt install uuid-runtime
    "nvim-lua/plenary.nvim",
    "folke/zen-mode.nvim"
  },
  run = ":Neorg sync-parsers",
  config = function()
    require('user.plugins.neorg')
  end,
})

use({
  "dundalek/parpar.nvim",
  requires = {
    "gpanders/nvim-parinfer",
    "julienvincent/nvim-paredit"
  },
  config = function()
    require("parpar").setup()
  end
})

use({
  'Olical/conjure',
  config = function()
    -- vim.g['conjure#mapping#prefix'] = ","
    vim.g['conjure#highlight#enabled'] = true
    vim.g['conjure#client_on_load'] = false
  end
})

if packer_bootstrap then
  require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
