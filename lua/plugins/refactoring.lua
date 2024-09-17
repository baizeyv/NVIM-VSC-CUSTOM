return {
    {
        "ThePrimeagen/refactoring.nvim",
        -- events = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {
                cs = {
                    'Debug.Log("%sfoobar");'
                }
            },
            print_var_statements = {},
            show_success_message = true, -- shows a message with information about the refactor on success
            -- i.e. [Refactor] Inlined 3 variable occurrences
        },
        config = function(_, opts)
            require("refactoring").setup(opts)
            vim.keymap.set("n", "<leader>dp", function()
                require("refactoring").debug.printf({ below = true })
            end)
            vim.keymap.set("n", "<leader>dx", function()
                require("refactoring").debug.cleanup({})
            end)
        end,
    },
}
