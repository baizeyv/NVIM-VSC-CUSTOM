local utils = require('config.utils')
-- Fast and feature-rich surround actions. For text that includes
-- surrounding characters like brackets or quotes, this allows you
-- to select the text inside, change or modify the surrounding characters,
-- and more.
return {
  "echasnovski/mini.surround",
  keys = function(_, keys)
    -- Populate the keys based on the user's options
    local opts = utils.opts("mini.surround")
    local mappings = {
      { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
      { opts.mappings.delete, desc = "Delete Surrounding" },
      { opts.mappings.find, desc = "Find Right Surrounding" },
      { opts.mappings.find_left, desc = "Find Left Surrounding" },
      { opts.mappings.highlight, desc = "Highlight Surrounding" },
      { opts.mappings.replace, desc = "Replace Surrounding" },
      { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    mappings = {
      add = "<leader>ka", -- Add surrounding in Normal and Visual modes
      delete = "<leader>kd", -- Delete surrounding
      find = "<leader>kf", -- Find surrounding (to the right)
      find_left = "<leader>kF", -- Find surrounding (to the left)
      highlight = "<leader>kh", -- Highlight surrounding
      replace = "<leader>kr", -- Replace surrounding
      update_n_lines = "<leader>kn", -- Update `n_lines`
    },
  },
}