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

use({
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()
  end,
})

use({
  'luochen1990/rainbow',
  config = function()
    vim.g.rainbow_active = 1
  end
})

use('tpope/vim-commentary')
use('tpope/vim-eunuch')
use('tpope/vim-surround')
use('tpope/vim-unimpaired')
use('tpope/vim-sleuth') -- setup indentation config
use('tpope/vim-repeat')
use('sheerun/vim-polyglot')
use('farmergreg/vim-lastplace')
use('nelstrom/vim-visual-star-search') -- search for selected text with *or #
use('jessarcher/vim-heritage')
use('sickill/vim-pasta')               -- auto indent paster text

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
  "cshuaimin/ssr.nvim",
  config = function()
    require("ssr").setup()
    vim.keymap.set("n", "<leader>ss", '<cmd>lua require("ssr").open()<CR>', { desc = 'structured search' })
  end
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

use({
  'mfussenegger/nvim-treehopper',
  requires = {
    'phaazon/hop.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    vim.keymap.set('n', 'gt', ':lua require("tsht").move()<CR>', { desc = 'jump to syntax node' })
    vim.keymap.set('n', 'vN', ':<C-U>lua require("tsht").nodes()<CR>', { desc = 'select current node' })
    vim.keymap.set('x', '_', ':lua require("tsht").nodes()<CR>', { desc = 'extend to syntax node' })
  end
})

use({
  'airblade/vim-rooter',
  setup = function()
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

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
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  config = function()
    require('user.plugins.trouble')
  end
})

use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.nvim-tree')
  end,
})

use({
  'lewis6991/gitsigns.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup()
    vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<CR>', { desc = 'next git diff' })
    vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'previous git diff' })
  end,
})

use({
  'emmanueltouzery/agitator.nvim',
  config = function()
    vim.keymap.set('n', '<leader>Gb', '<cmd>lua require("agitator").git_blame_toggle()<CR>', { desc = 'git blame file' })
    vim.keymap.set('n', '<leader>Gt', '<cmd>lua require("agitator").git_time_machine()<CR>',
      { desc = 'git time machine' })
  end
})

use({
  'f-person/git-blame.nvim',
  config = function()
    vim.g.gitblame_enabled = 0
    vim.keymap.set('n', '<leader>GB', '<cmd>GitBlameToggle<CR>', { desc = 'toggle git blame line' })
    vim.keymap.set('n', '<leader>Gc', '<cmd>GitBlameCopySHA<CR>', { desc = 'copy current line commit sha' })
  end
})

use({
  'nvim-treesitter/nvim-treesitter',
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
  'kevinhwang91/nvim-ufo',
  requires = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('user.plugins.nvim-ufo')
  end
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
    'PaterJason/cmp-conjure'
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

use({
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      window = {
        options = {
          signcolumn = "no",      -- disable signcolumn
          number = false,         -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false,     -- disable cursorline
          cursorcolumn = false,   -- disable cursor column
          foldcolumn = "0",       -- disable fold column
          list = false,           -- disable whitespace characters
        },
      },
    })
  end
})

use({
  "nvim-neorg/neorg",
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
  'guns/vim-sexp',
  config = function()
    vim.g.sexp_filetypes = ''
  end
})

use({
  'Olical/conjure',
  config = function()
    vim.g['conjure#mapping#prefix'] = ","
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
