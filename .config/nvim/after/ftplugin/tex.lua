vim.opt_local.spelllang = 'en_us'
vim.opt_local.spell = true
vim.opt_local.cindent = false
vim.opt_local.textwidth = 80

vim.b.minipairs_disable = true

local function smartpair(open, close, conds)
  conds = conds or {}
  local skip_before = conds.skip_before or "\\left%s*$"

  -- Return the actual mapping function (expr mapping)
  return function()
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local before = (col > 1) and line:sub(1, col - 1) or ""

    if skip_before and before:match(skip_before) then
      return open
    end

    return open .. close .. "<left>"
  end
end

local opts = { silent = true, noremap = true, buffer = true }

vim.keymap.set('i', '_', '_{}<left>', opts)
vim.keymap.set('i', '^', '^{}<left>', opts)
vim.keymap.set('i', '$', '\\(\\)<left><left>', opts)
vim.keymap.set('i', '\"', '``\'\'<left><left>', opts)

vim.keymap.set('i', '<M-CR>', '<cr>\\item<esc>V=$a ', opts)

-- Note: I have tried to use <C-'> before, but this can be quite dependent on
-- terminals. In many terminals, Ctrl+punctuation is unsupported.
vim.keymap.set('i', "<M-'>", '\\', opts)
vim.keymap.set('i', "<C-s>", '\\', opts)

opts.expr = true
vim.keymap.set("i", "(", smartpair("(", ")", { skip_before = "lr%s*$" }), opts)
vim.keymap.set("i", "[", smartpair("[", "]", { skip_before = "lr%s*$" }), opts)
vim.keymap.set("i", "{", smartpair("{", "}", { skip_before = "lr%s*$" }), opts)

-- vim.keymap.set(
--   "n", "<localleader>a", ":<c-u>update<cr>:VimtexCompileSS<cr>", opts
-- )