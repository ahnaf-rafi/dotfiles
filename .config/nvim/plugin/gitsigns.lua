vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })


require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function keymap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    keymap('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gs.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    keymap('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gs.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- Visual mode
    keymap('v', '<leader>gs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    keymap('v', '<leader>gr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    -- Normal mode
    keymap('n', '<leader>gs', gs.stage_hunk, { desc = 'git [s]tage hunk' }) 
    keymap('n', '<leader>gr', gs.reset_hunk, { desc = 'git [r]eset hunk' })
    keymap('n', '<leader>gS', gs.stage_buffer, { desc = 'git [S]tage buffer' })
    keymap('n', '<leader>gu', gs.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    keymap('n', '<leader>gR', gs.reset_buffer, { desc = 'git [R]eset buffer' })
    keymap('n', '<leader>gp', gs.preview_hunk, { desc = 'git [p]review hunk' })
    keymap('n', '<leader>gb', gs.blame_line, { desc = 'git [b]lame line' })
    keymap('n', '<leader>gd', gs.diffthis, { desc = 'git [d]iff against index' })
    keymap('n', '<leader>gD', function()
      gs.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })

    -- Toggles
    keymap('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    keymap('n', '<leader>tD', gs.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
})
