local keyopts = { silent = true, noremap = true }
local keymap = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " m"

keymap({"n", "v"}, "j", "gj", keyopts)
keymap({"n", "v"}, "k", "gk", keyopts)
keymap("v", "<", "<gv", keyopts)  -- Better indent in visual
keymap("v", ">", ">gv", keyopts)  -- Better dedent in visual
keymap({"i", "v"}, "fd", "<esc>", keyopts)  -- fd = esc in insert
keymap("t", "<c-f><c-d>", "<c-\\><c-n>", keyopts)  -- <c-f><c-d> = esc in term
keymap("i", "<m-b>", "<c-left>", keyopts)
keymap("i", "<m-f>", "<c-right>", keyopts)
keymap("i", "<c-b>", "<left>", keyopts)
keymap("i", "<c-f>", "<right>", keyopts)
keymap({"n", "v"}, "<leader>fs", ":update<cr>", keyopts)

keyopts.desc = "+window"
keymap("n", "<leader>w", "<c-w>", keyopts)

keyopts.desc = "delete"
keymap('n', '<c-w>x', ':<c-u>bdel<cr>', keyopts)
keymap('n', '<leader>wx', ':<c-u>bdel<cr>', keyopts)

keyopts.desc = 'Copy Absolute Path'
keymap('n', '<leader>fyy', ':<c-u>let @+=expand("%:p")<cr>', keyopts)

keyopts.desc = 'Copy Directory Path'
keymap('n', '<leader>fyd', ':<c-u>let @+=expand("%:p:h")<cr>', keyopts)

keyopts.desc = 'Copy File Name'
keymap('n', '<leader>fyn', ':<c-u>let @+=expand("%:t")<cr>', keyopts)

keyopts.desc = 'Copy Relative File Name'
keymap('n', '<leader>fyr', ':<c-u>let @+=expand("%")<cr>', keyopts)

keyopts.desc = 'Delete Buffer'
keymap('n', '<leader>bd', ':<c-u>bprev<cr>:bdel #<cr>', keyopts)

keyopts.desc = 'Previous Buffer'
keymap('n', '<leader>bp', ':<c-u>bprev<cr>', keyopts)
keymap('n', '<leader>b[', ':<c-u>bprev<cr>', keyopts)

keyopts.desc = 'Next Buffer'
keymap('n', '<leader>bn', ':<c-u>bnext<cr>', keyopts)
keymap('n', '<leader>b]', ':<c-u>bnext<cr>', keyopts)

keyopts.desc = 'Clear search'
keymap('n', '<leader>sc', ':nohl<cr>', keyopts)

keyopts.desc = 'Terminal Other Window'
keymap('n', '<leader>at', ':<c-u>vsp | term<cr>', keyopts)

keyopts.desc = 'Terminal Current Window'
keymap('n', '<leader>aT', ':<c-u>term<cr>', keyopts)
