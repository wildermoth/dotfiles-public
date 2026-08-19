-- Format on save: ruff (Python), stylua (Lua), otherwise LSP. Skip markdown.
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			python = { "ruff_format", "ruff_organize_imports" },
			lua = { "stylua" },
		},
		format_on_save = function(bufnr)
			if vim.bo[bufnr].filetype == "markdown" then
				return
			end
			return { lsp_format = "fallback" }
		end,
	},
}
