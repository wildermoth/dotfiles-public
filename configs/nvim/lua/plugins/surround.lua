-- Wraps visual selections with one leader key; visual S remains Flash.
return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	init = function()
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup()

		local wrappers = {
			['"'] = '""',
			["'"] = "''",
			["}"] = "{}",
			["]"] = "[]",
			[")"] = "()",
			["`"] = "``",
		}

		for key, pair in pairs(wrappers) do
			-- Reselect only the wrapped text, excluding the new delimiters.
			vim.keymap.set(
				"x",
				"<leader>" .. key,
				"<Plug>(nvim-surround-visual)" .. key .. "gvolol",
				{
					remap = true,
					desc = "Wrap selection in " .. pair,
				}
			)
		end
	end,
}
