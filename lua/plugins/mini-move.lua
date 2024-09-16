return {
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-n>',
        right = '<M-i>',
        down = '<M-e>',
        up = '<M-u>',
        -- Move current line in Normal mode
        line_left = '<M-n>',
        line_right = '<M-i>',
        line_down = '<M-e>',
        line_up = '<M-u>',
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },
}
