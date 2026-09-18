return {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    opts = {
        -- whether to set default mappings
        default_mappings = false,
        -- if set to true, only multiple cursors will be created without multiple selections
        no_selection = false
    },
    config = function(_, opts)
        local cursors = require('vscode-multi-cursor')
        cursors.setup(opts)
        local k = vim.keymap.set
        k({'n', 'x'}, '<leader>mca', cursors.create_cursor,
          {expr = true, desc = 'Create cursor'})
        k({'n'}, '<leader>mcx', cursors.cancel,
          {expr = true, desc = 'cancel/clear all cursors'})
        k({'n', 'x'}, '<leader><left>', cursors.start_left,
          {expr = true, desc = 'start cursors on the left'})
        k({'n', 'x'}, '<leader>mcN', cursors.start_left_edge,
          {expr = true, desc = 'start cursors on the left edge'})
        k({'n', 'x'}, '<leader><right>', cursors.start_right,
          {expr = true, desc = 'start cursors on the right'})
        k({'n', 'x'}, '<leader>mcI', cursors.start_right,
          {expr = true, desc = 'start cursors on the right'})
        k({'n'}, '<leader><up>', cursors.prev_cursor,
          {desc = 'goto prev cursor'})
        k({'n'}, '<leader><down>', cursors.next_cursor,
          {desc = 'goto next cursor'})
        k({'n'}, '<leader>mcs', cursors.flash_char,
          {expr = true, desc = 'create cursor using flash'})
        k({'n'}, '<leader>mcw', cursors.flash_word,
          {expr = true, desc = 'create selection using flash'})
        -- --------------------- split ----------------------
        k({'n'}, '<C-t>', '<leader>mcakw<Cmd>nohl<CR>', {remap = true})
        k({'n'}, '<down>', '<leader>mcakw*<Cmd>nohl<CR>', {remap = true})
        k({'n'}, '<up>', '<leader>mcakw#<Cmd>nohl<CR>', {remap = true})
    end
}

