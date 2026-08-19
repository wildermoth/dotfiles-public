-- Personal vault plugin. Assumes this Obsidian layout. Not optional.
return {
	"wildermoth/personal-obsidian.nvim",
	dependencies = {
		{ "obsidian-nvim/obsidian.nvim", version = "*" },
	},
	ft = "markdown",
	cmd = { "Obsidian", "ObsidianNew", "ObsidianPasteImg" },
	keys = {
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian New" },
		{ "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian Today" },
		{ "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian Yesterday" },
	},
	config = function()
		require("personal_obsidian").setup()
	end,
}
