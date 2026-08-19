-- Indent and LSP reference visuals, file safeguards, and floating input prompts.
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next reference",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Previous reference",
		},
	},
	init = function()
		local ui = require("shared.colors").ui
		local augroup = vim.api.nvim_create_augroup("SnacksIndentHighlights", { clear = true })
		local function set_indent_hls()
			vim.api.nvim_set_hl(0, "SnacksIndent", { fg = ui.visual, nocombine = true })
			vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = ui.border_active, nocombine = true })
			vim.api.nvim_set_hl(0, "LspReferenceText", { bg = ui.surface, nocombine = true })
			vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = ui.surface, nocombine = true })
			vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = ui.surface, nocombine = true })
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = ui.muted, nocombine = true })
		end
		vim.schedule(set_indent_hls)
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = augroup,
			callback = function()
				vim.schedule(set_indent_hls)
			end,
			desc = "Reapply custom highlight overrides",
		})
	end,
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = true },
		indent = {
			enabled = true,
			animate = {
				easing = "inCirc",
				duration = {
					step = 3,
				},
			},
		},
	},
}
