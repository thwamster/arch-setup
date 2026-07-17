local vimrc_path = vim.fn.expand("~/.vimrc")
if vim.fn.filereadable(vimrc_path) == 1 then
    vim.cmd("source " .. vimrc_path)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        { "filename", file_status = true, path = 1 },
                        { "branch" },
                        { "filetype" },
                    },
                    lualine_c = {},
                    lualine_x = {
                        {
                            function()
                                local nr = vim.fn.char2nr(vim.fn.matchstr(vim.fn.getline("."), "\\%<" .. vim.fn.col(".") .. "c."))
                                return string.format("0x%04X", nr)
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress" },
                        { "location" },
                    },
                    lualine_z = {
                        {
                            function()
                                return os.date("%H:%M")
                            end,
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "python", "html", "css" },
            auto_install = true,
            highlight = { enable = true },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright" },
            })

            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({})
                    end,
                },
            })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Variable" })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
            })
        end,
    },
})