local print_content = '[ ** <color=#ff88ff>%s</color> ** ]'
local print_var_content = '$"Variable -> [ <color=#0088ff>%s</color> **<color=#00ff00>{%s}</color>** ]"'
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
                    'UnityEngine.Debug.Log("' .. print_content .. '");'
                }
            },
            print_var_statements = {
                cs = {
                    'UnityEngine.Debug.Log(' .. print_var_content .. ');'
                }
            },
            show_success_message = true, -- shows a message with information about the refactor on success
            -- i.e. [Refactor] Inlined 3 variable occurrences
        },
        config = function(_, opts)
            require("refactoring").setup(opts)
            vim.keymap.set("n", "<leader>dpi", function()
                require("refactoring").debug.printf({ below = true })
            end)
            vim.keymap.set("n", "<leader>dpe", function()
                require("refactoring").debug.printf({
                    printf_statements = {
                        cs = {
                            'UnityEngine.Debug.LogError("' .. print_content .. '");'
                        }
                    }
                })
            end)
            vim.keymap.set("n", "<leader>dpw", function()
                require("refactoring").debug.printf({
                    printf_statements = {
                        cs = {
                            'UnityEngine.Debug.LogWarning("' .. print_content .. '");'
                        }
                    }
                })
            end)
            vim.keymap.set("n", "<leader>dvi", function()
                require("refactoring").debug.print_var()
            end)
            vim.keymap.set("n", "<leader>dve", function()
                require("refactoring").debug.print_var({
                    print_var_statements = {

                        cs = {
                            'UnityEngine.Debug.LogError(' .. print_var_content .. ');'
                        }
                    }
                })
            end)
            vim.keymap.set("n", "<leader>dvw", function()
                require("refactoring").debug.print_var({
                    print_var_statements = {

                        cs = {
                            'UnityEngine.Debug.LogWarning(' .. print_var_content .. ');'
                        }
                    }
                })
            end)
            vim.keymap.set("n", "<leader>dx", function()
                require("refactoring").debug.cleanup({})
            end)

            -- refactor inline variable
            vim.keymap.set({ "n", "v" }, "<leader>ri", function()
                require("refactoring").refactor("Inline Variable")
            end)

            -- refactor extract block
            vim.keymap.set({ "n" }, "<leader>rb", function()
                require("refactoring").refactor("Extract Block")
            end)
            
            -- refactor extract function
            vim.keymap.set({ "v" }, "<leader>rf", function()
                require("refactoring").refactor("Extract Function")
            end)
            
            -- refactor extract variable
            vim.keymap.set({ "v" }, "<leader>rv", function()
                require("refactoring").refactor("Extract Variable")
            end)

        end,
    },
}
