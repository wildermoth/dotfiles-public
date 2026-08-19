-- Python call and type hierarchy picker powered by Telepy.
return {
	"wildermoth/telepy",
	build = "make build-parser",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = { "python" },
	keys = {
		{ "<leader>li", "<cmd>Telescope hierarchy<cr>", desc = "Inspect Python hierarchy" },
	},
	config = function()
		require("telescope").load_extension("hierarchy")
	end,
}
