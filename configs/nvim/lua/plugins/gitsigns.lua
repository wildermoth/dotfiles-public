-- Git gutter signs and blame.
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "c" },
			changedelete = { text = "cd" },
			delete = { text = "▁" },
			topdelete = { text = "▔" },
			untracked = { text = "u" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			map("n", "<leader>bf", gitsigns.blame, "Toggle File Blame")
			map("n", "<leader>bl", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
		end,
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)

		local theme = require("shared.colors")
		local git, diff = theme.git, theme.diff
		local function set_gitsigns_hl()
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = git.add, nocombine = true })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = git.change, nocombine = true })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = git.delete, nocombine = true })
			vim.api.nvim_set_hl(
				0,
				"GitSignsChangeDelete",
				{ fg = git.changedelete, nocombine = true }
			)
			vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = git.untracked, nocombine = true })
			vim.api.nvim_set_hl(0, "DiffAdd", { bg = diff.add_bg, fg = diff.add_fg })
			vim.api.nvim_set_hl(0, "DiffChange", { bg = diff.change_bg, fg = diff.change_fg })
			vim.api.nvim_set_hl(0, "DiffDelete", { bg = diff.delete_bg, fg = diff.delete_fg })
			vim.api.nvim_set_hl(
				0,
				"DiffText",
				{ bg = diff.text_bg, fg = diff.text_fg, bold = true }
			)
			vim.api.nvim_set_hl(
				0,
				"GitSignsAddInline",
				{ bg = diff.add_bg, fg = diff.add_fg, underline = false }
			)
			vim.api.nvim_set_hl(
				0,
				"GitSignsChangeInline",
				{ bg = diff.change_bg, fg = diff.change_fg, underline = false }
			)
			vim.api.nvim_set_hl(
				0,
				"GitSignsDeleteInline",
				{ bg = diff.delete_bg, fg = diff.delete_fg, underline = false }
			)
		end
		set_gitsigns_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("dotfiles_gitsigns_hl", { clear = true }),
			callback = set_gitsigns_hl,
		})
	end,
}
