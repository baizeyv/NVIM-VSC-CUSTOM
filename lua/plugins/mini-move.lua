return {
	"nvim-mini/mini.move",
	version = "*",
	keys = { "<A-n>", "<A-i>", "<A-e>", "<A-u>" },
	opts = {
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			left = "<A-n>",
			right = "<A-i>",
			down = "<A-e>",
			up = "<A-u>",

			-- Move current line in Normal mode
			line_left = "<A-n>",
			line_right = "<A-i>",
			line_down = "<A-e>",
			line_up = "<A-u>",
		},

		-- Options which control moving behavior
		options = {
			-- Automatically reindent selection during linewise vertical move
			reindent_linewise = true,
		},
	},
}
