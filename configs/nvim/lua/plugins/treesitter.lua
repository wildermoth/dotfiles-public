-- Installs parsers and enables highlighting, block objects, and incremental selection.
local parsers = {
	"bash",
	"css",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"regex",
	"latex",
}

local parser_set = {}
for _, parser in ipairs(parsers) do
	parser_set[parser] = true
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	config = function()
		require("nvim-treesitter").install(parsers)
		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
		})

		local group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			callback = function(event)
				local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
				if not lang or not parser_set[lang] then
					return
				end

				local started = pcall(vim.treesitter.start, event.buf, lang)
				if not started then
					return
				end

				require("modules.incremental_selection").attach(event.buf)
				local select = require("nvim-treesitter-textobjects.select")
				vim.keymap.set({ "x", "o" }, "ab", function()
					select.select_textobject("@block.outer", "textobjects")
				end, { buffer = event.buf, desc = "Around block" })
				vim.keymap.set({ "x", "o" }, "ib", function()
					select.select_textobject("@block.inner", "textobjects")
				end, { buffer = event.buf, desc = "Inside block" })
			end,
			desc = "Enable configured Treesitter features",
		})
	end,
}
