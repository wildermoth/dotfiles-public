-- Labels leader-key groups and shows available key continuations.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer-local keymaps",
		},
	},
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>b", group = "Blame" },
			{ "<leader>f", group = "File" },
			{ "<leader>g", group = "Grep" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>o", group = "Obsidian" },
			{ "<leader>t", group = "Telescope" },
		},
	},
}
