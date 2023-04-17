local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').reset()
require('packer').init({
  ensure_dependencies   = true,
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

local use = require('packer').use

use('wbthomason/packer.nvim')

use({
  'EdenEast/nightfox.nvim',
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
  'nvim-lualine/lualine.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.lualine')
  end,
})

use({
  'akinsho/bufferline.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  after = 'nightfox.nvim',
  config = function()
    require('user.plugins.bufferline')
  end,
})

use('tpope/vim-commentary')
use('tpope/vim-eunuch')
use('tpope/vim-surround')
use('tpope/vim-unimpaired')
use('tpope/vim-sleuth')
use('tpope/vim-repeat')
use('sheerun/vim-polyglot')
use('farmergreg/vim-lastplace')
use('nelstrom/vim-visual-star-search')
use('jessarcher/vim-heritage')
use('sickill/vim-pasta')

use({
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup() 
  end
})

use({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('user.plugins.indent-blankline')
  end,
})

use({
  'phaazon/hop.nvim',
  branch = 'v2',
  config = function()
    require('hop').setup()
    vim.keymap.set('n', 'gw', '<cmd>HopWord<CR>', { desc = 'jump to word' })
    vim.keymap.set('n', 'g/', '<cmd>HopPattern<CR>', { desc = 'jump to pattern' })
  end
})

-- use({
--   'whatyouhide/vim-textobj-xmlattr',
--   requires = 'kana/vim-textobj-user',
-- })

use({
  'airblade/vim-rooter',
  setup = function()
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

-- use({
--   'windwp/nvim-autopairs',
--   config = function()
--     require('nvim-autopairs').setup()
--   end,
-- })

use({
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()
  end,
})

-- use({
--   'AndrewRadev/splitjoin.vim',
--   config = function()
--     vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
--     vim.g.splitjoin_trailing_comma = 1
--     vim.g.splitjoin_php_method_chain_full = 1
--   end,
-- })

use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

use({
  'nvim-telescope/telescope.nvim',
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
  },
  config = function()
    require('user.plugins.telescope')
  end,
})

use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.nvim-tree')
  end,
})

-- use({
--   'tpope/vim-fugitive',
--   requires = 'tpope/vim-rhubarb',
--   cmd = 'G',
-- })

use({
  'lewis6991/gitsigns.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup()
    vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<CR>', { desc = 'next git diff' })
    vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'previous git diff' })
    -- vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<CR>')
  end,
})

use({
    'emmanueltouzery/agitator.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gb', '<cmd>lua require("agitator").git_blame_toggle()<CR>', { desc = 'git blame file' })
      vim.keymap.set('n', '<leader>gt', '<cmd>lua require("agitator").git_time_machine()<CR>', { desc = 'git time machine' })
    end
})

use({
  'f-person/git-blame.nvim',
  config = function()
    vim.keymap.set('n', '<leader>gB', '<cmd>GitBlameToggle<CR>', { desc = 'toggle git blame line' })
    vim.keymap.set('n', '<leader>gc', '<cmd>GitBlameCopySHA<CR>', { desc = 'copy current line commit sha' })
  end
})

use({
  'nvim-treesitter/nvim-treesitter',
  run = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  requires = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'ziontee113/syntax-tree-surfer',
  },
  config = function()
    require('user.plugins.treesitter')
  end,
})

use({
  'hrsh7th/nvim-cmp',
  requires = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'onsails/lspkind-nvim',
  },
  config = function()
    require('user.plugins.cmp')
  end,
})

use({
  'neovim/nvim-lspconfig',
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

if packer_bootstrap then
  require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
