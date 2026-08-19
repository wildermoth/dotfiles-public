-- Shows the current line's Git history in a Telescope picker.
return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>bh",
			function()
				require("modules.line_history").line_history()
			end,
			desc = "Line history",
		},
	},
}
