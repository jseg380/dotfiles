-- Search
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Indentation
vim.opt.tabstop = 4
--vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Line numeration
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse
vim.opt.mouse = 'a'

-- Colorscheme (theme)
vim.opt.termguicolors = true
vim.opt.cc = '80'
vim.cmd('colorscheme slate')

-- Syntax highlighting
vim.cmd('syntax on')

-- Key mappings
vim.g.mapleader = ' '
vim.g.localmapleader = ' '
-- Leader associated keymaps
vim.keymap.set('n', '<Leader>w', ':write<CR>')
vim.keymap.set('n', '<Leader>q', ':quit<CR>')
vim.keymap.set('n', '<Leader>e', '<C-W>v<C-W>l:Ex<CR>')
vim.keymap.set('n', '<Leader>bn', ':bn<CR>')
vim.keymap.set('n', '<Leader>bb', ':bp<CR>')
vim.keymap.set('n', '<Leader>c', ':bp<bar>sp<bar>bn<bar>bd<CR>')
vim.keymap.set('n', '<Leader>h', ':noh<CR>')
-- Move lines
vim.keymap.set('n', '<A-k>', 'ddkP')
vim.keymap.set('n', '<A-j>', 'ddp')
-- Move between windows
vim.keymap.set('n', '<C-H>', '<C-W>h')
vim.keymap.set('n', '<C-J>', '<C-W>j')
vim.keymap.set('n', '<C-K>', '<C-W>k')
vim.keymap.set('n', '<C-L>', '<C-W>l')

-- Other
-- vim.opt.wildmode = 'longest,list'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.ttyfast = true

-- Undofile
vim.opt.undofile = false
-- vim.opt.undodir = "$HOME/.cache/nvim/undo-dir"
-- vim.opt.undolevels = 200
