--[[
  keybindings.json中需要加这个才能捕获insert模式下的key
	{
		"key": "backspace",
		"command": "vscode-neovim.send",
		"when": "editorTextFocus && neovim.init && neovim.mode == 'insert'",
		"args": "<BS>",
	},
  {
    "key": "`",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "`",
  },
  {
    "key": "shift+9",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "(",
  },
  {
    "key": "shift+0",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": ")",
  },
  {
    "key": "[",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "[",
  },
  {
    "key": "]",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "]",
  },
  {
    "key": "shift+[",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "{",
  },
  {
    "key": "shift+]",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "}",
  },
  {
    "key": "'",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "'",
  },
  {
    "key": "shift+'",
    "command": "vscode-neovim.send",
    "when": "editorTextFocus && neovim.init",
    "args": "\"",
  },
]] --
return {
    "nvim-mini/mini.pairs",
    version = '*',
    event = "VeryLazy",
    opts = {
        -- In which modes mappings from this `config` should be created
        modes = {insert = true, command = false, terminal = false},

        -- Global mappings. Each right hand side should be a pair information, a
        -- table with at least these fields (see more in |MiniPairs.map|):
        -- - <action> - one of 'open', 'close', 'closeopen'.
        -- - <pair> - two character string for pair to be used.
        -- By default pair is not inserted after `\`, quotes are not recognized by
        -- <CR>, `'` does not insert the pair after a letter.
        -- Only parts of tables can be tweaked (others will use these defaults).
        mappings = {
            ['('] = {action = 'open', pair = '()', neigh_pattern = '^[^\\]'},
            ['['] = {action = 'open', pair = '[]', neigh_pattern = '^[^\\]'},
            ['{'] = {action = 'open', pair = '{}', neigh_pattern = '^[^\\]'},

            [')'] = {action = 'close', pair = '()', neigh_pattern = '^[^\\]'},
            [']'] = {action = 'close', pair = '[]', neigh_pattern = '^[^\\]'},
            ['}'] = {action = 'close', pair = '{}', neigh_pattern = '^[^\\]'},

            ['"'] = {
                action = 'closeopen',
                pair = '""',
                neigh_pattern = '^[^\\]',
                register = {cr = false}
            },
            ["'"] = {
                action = 'closeopen',
                pair = "''",
                neigh_pattern = '^[^%a\\]',
                register = {cr = false}
            },
            ['`'] = {
                action = 'closeopen',
                pair = '``',
                neigh_pattern = '^[^\\]',
                register = {cr = false}
            }
        }
    },
    config = function(_, opts) require('mini.pairs').setup(opts) end
}
