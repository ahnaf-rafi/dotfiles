local opt = vim.opt
local g = vim.g

-- Line numbers, make them relative.
opt.number = true
opt.relativenumber = true

-- Adjust splitting behavior
opt.splitbelow = true
opt.splitright = true

-- Set highlight on search
opt.hlsearch = false

-- Case-insensitive searching UNLESS \C or capital in search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Tabs and indentation
opt.cindent = false
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Enable mouse mode
opt.mouse = 'a'

-- Sync clipboard between OS and Neovim. See `:help 'clipboard'`
opt.clipboard = 'unnamedplus'

-- Save undo history
opt.undofile = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Enable break indent
opt.breakindent = true

-- Break lines at
opt.linebreak = true

-- Column indicators
opt.colorcolumn = '81,101,121'

-- Highlight current line
opt.cursorline = true

-- Disable vim folds
opt.foldenable = false

-- Window borders
opt.winborder = "rounded"

-- Completion options
vim.cmd('set completeopt+=menuone,noselect,popup')

-- Some globals
g.python3_host_prog = '~/miniforge3/bin/python3'
g.tex_flavor = 'latex'
g.tex_comment_nospell = 1
-- g.tex_nospell = 1

vim.cmd('set iskeyword-=_')
