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
vim.opt.updatetime = 251
vim.opt.timeoutlen = 301
vim.opt.termguicolors = true
vim.opt.tabstop = 5
vim.opt.shiftwidth = 5
vim.opt.expandtab = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("i", "<C-v>", '<ESC>"+pa')
vim.keymap.set("n", "<C-v>", '"+p')
vim.keymap.set("v", "<C-v>", '"+p')
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<C-v>', '"+p', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })
vim.keymap.set('c', '<C-v>', '<C-r>+', { noremap = true, silent = true })

vim.opt.clipboard = "unnamedplus"

vim.cmd.colorscheme("fairyfloss")

local colors = {
    fg = '#f8f8f0',
    bg = '#5a5475',
    bg_alt = '#373348',
    gray = '#a8a4b1',
    purple = '#ae81ff',
    pink = '#f92672',
    yellow = '#e6c000',
    cyan = '#c2ffdf',
    blue = '#96cbfe',
    none = 'NONE',
}

local fairyfloss_line = {
    normal = { a = { bg = colors.purple, fg = colors.bg, gui = 'bold' }, b = { bg = colors.none, fg = colors.fg }, c = { bg = colors.none, fg = colors.gray } },
    insert = { a = { bg = colors.cyan, fg = colors.bg, gui = 'bold' }, b = { bg = colors.none, fg = colors.fg }, c = { bg = colors.none, fg = colors.gray } },
    visual = { a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' }, b = { bg = colors.none, fg = colors.fg }, c = { bg = colors.none, fg = colors.gray } },
    replace = { a = { bg = colors.pink, fg = colors.fg, gui = 'bold' }, b = { bg = colors.none, fg = colors.fg }, c = { bg = colors.none, fg = colors.gray } },
    command = { a = { bg = colors.blue, fg = colors.bg, gui = 'bold' }, b = { bg = colors.none, fg = colors.fg }, c = { bg = colors.none, fg = colors.gray } },
    inactive = { a = { bg = colors.none, fg = colors.gray }, b = { bg = colors.none, fg = colors.gray }, c = { bg = colors.none, fg = colors.gray } },
}

require("lazy").setup({
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = fairyfloss_line,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "filename", file_status = true, path = 1 }, { "branch" }, { "filetype" } },
                    lualine_c = {},
                    lualine_x = { { function() local nr = vim.fn.char2nr(vim.fn.matchstr(vim.fn.getline("."), "\\%<" .. vim.fn.col(".") .. "c.")) return string.format("0x%04X", nr) end } },
                    lualine_y = { { "progress" }, { "location" } },
                    lualine_z = { { function() return os.date("%H:%M") end } },
                },
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep)
            vim.keymap.set("n", "<leader>fb", builtin.buffers)
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item() else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }),
            })
        end,
    },
})
