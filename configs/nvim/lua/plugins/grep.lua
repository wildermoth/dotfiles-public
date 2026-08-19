-- Searches project text from a prompt, motion, line, or visual selection.
local grep = require("modules.grep_motion")

return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{ "<leader>gp", grep.prompt, desc = "Grep prompt" },
		{ "<leader>g", grep.start, expr = true, desc = "Grep motion" },
		{
			"<leader>gg",
			function()
				return grep.start("line")
			end,
			expr = true,
			desc = "Grep line",
		},
		{ "<leader>g", grep.visual, mode = "x", desc = "Grep selection" },
	},
}
