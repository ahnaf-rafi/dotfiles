-- Basic options and keybindings.
require("base")

vim.pack.add({
  -- Files
  { src = "https://github.com/stevearc/oil.nvim" },
  -- Git
  -- { src = "" },
  -- Snippets
  { src = "https://github.com/L3MON4D3/LuaSnip" },

  -- LaTeX
  { src = "https://github.com/lervag/vimtex" },

  -- Julia
  { src = "https://github.com/JuliaEditorSupport/julia-vim" },

  -- REPLs
  { src = "https://github.com/jpalardy/vim-slime"},
})
