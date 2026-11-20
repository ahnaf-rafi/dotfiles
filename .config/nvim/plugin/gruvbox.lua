vim.pack.add({ "https://github.com/ellisonleao/gruvbox.nvim" })

vim.o.background = "dark"
require("gruvbox").setup({ contrast = "hard", })
vim.cmd("colorscheme gruvbox")
