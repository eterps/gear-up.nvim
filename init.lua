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

-- Sane aliases
local map = vim.api.nvim_set_keymap
local autocmd = vim.api.nvim_create_autocmd

-- Sane defaults
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.number     = true -- display line numbers
vim.opt.expandtab  = true -- convert tabs to whitespace
vim.opt.splitbelow = true -- put new windows below current
vim.opt.splitright = true -- put new windows right of current

map('n', '<esc>', ':nohlsearch<cr>',
  { noremap = true, silent = true }) -- esc disables search highlights

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  if packer_bootstrap then require('packer').sync() end
end)
if packer_bootstrap then return end

-- Theme
require("tokyonight").setup({ style = 'night', transparent = true })
vim.cmd('colorscheme tokyonight')

-- Treesitter
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "c", "cpp", "css", "fish", "go", "html", "java", "javascript",
    "json", "lua", "markdown", "php", "python", "ruby", "rust", "toml", "typescript", "yaml" },
  auto_install = true,
  highlight = { enable = true },
}

-- LSP
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()
