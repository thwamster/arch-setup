-- thwamster's init.lua

-- Vim Setup
vim.cmd('source ~/.vimrc')
vim.g.mapleader = " "

-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {}) 
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { "c", "cpp", "java", "rust", "lua", "bash", "vim" },
				highlight = { enable = true },
			}
		end
	},

	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "rust_analyzer", "jdtls" }
			})

			local lspconfig = require('lspconfig')
			lspconfig.clangd.setup({})
			lspconfig.rust_analyzer.setup({})
			lspconfig.jdtls.setup({})

			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
		end
	}
})