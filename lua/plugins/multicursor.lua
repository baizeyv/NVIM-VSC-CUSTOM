return {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    config = function(_, opts)
        local cursors = require("vscode-multi-cursor")
        local map = vim.keymap.set
        map({ "n", "x" }, "<C-o>o", cursors.create_cursor, { expr = true, desc = "Create Cursor" })
        map({ "n" }, "<C-o>'", "<C-o>okw*<Cmd>nohl<CR>", { remap = true, desc = "Create Cursor" })
        map({ "n" }, '<C-q>', cursors.cancel, { desc = "Cancel/Clear all cursors" })
        map({ "n", "x" }, '<C-o>n', cursors.start_left, { desc = "Start cursors on the left" })
        map({ "n", "x" }, '<C-o>N', cursors.start_left_edge, { desc = "Start cursors on the left edge" })
        map({ "n", "x" }, '<C-o>i', cursors.start_right, { desc = "Start cursors on the right" })
        map({ "n" }, '<C-o>u', cursors.prev_cursor, { desc = "Goto Previous cursor" })
        map({ "n" }, '<C-o>e', cursors.next_cursor, { desc = "Goto Next Cursor" })
        map({ "n" }, '<C-o>f', cursors.flash_char,
            { desc = "Create cursor using flash" })
        map({ "n" }, '<C-o>w', cursors.flash_word,
            { desc = "Create selection using flash" })
        cursors.setup{
            default_mappings = false,
            no_selection = false,
        }
    end
}
