-- Synthwave '84 theme; palette overrides from configs/theme/palette.json.
local ui = require("shared.colors").ui

return {
	"samharju/synthweave.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		overrides = {
			Directory = { fg = ui.fg },
			qfLineNr = { fg = ui.orange },
			Visual = { bg = ui.visual },
			LineNr = { fg = ui.fg },
			CursorLineNr = { fg = ui.accent, bold = true },
			Folded = { bg = ui.surface },
		},
	},
	config = function(_, opts)
		local synthweave = require("synthweave")
		synthweave.setup(opts)
		synthweave.load()
	end,
}
