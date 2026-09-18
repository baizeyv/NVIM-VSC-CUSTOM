return {
    {
        "nvim-mini/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return
                        require("ts_context_commentstring.internal").calculate_commentstring() or
                            vim.bo.commentstring
                end,
                -- Whether to ignore blank lines when commenting
                ignore_blank_line = false,

                -- Whether to ignore blank lines in actions and textobject
                start_of_line = false,

                -- Whether to force single space inner padding for comment parts
                pad_comment_parts = true
            },
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Toggle comment (like `gcip` - comment inner paragraph) for both
                -- Normal and Visual modes
                comment = '<C-/>',

                -- Toggle comment on current line
                comment_line = '<A-/>',

                -- Toggle comment on visual selection
                comment_visual = '<C-/>',

                -- Define 'comment' textobject (like `dgc` - delete whole comment block)
                -- Works also in Visual mode if mapping differs from `comment_visual`
                textobject = '<C-/>'
            },

            -- Hook functions to be executed at certain stage of commenting
            hooks = {
                -- Before successful commenting. Does nothing by default.
                pre = function() end,
                -- After successful commenting. Does nothing by default.
                post = function() end
            }
        }
    }, {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {enable_autocmd = false}
    }
}
