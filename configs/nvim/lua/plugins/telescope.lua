-- Finds files and buffers, with Tab switching file search to text search.
local find_files
local live_grep

local function switch_to(next_picker)
	return function(prompt_bufnr)
		local query = require("telescope.actions.state").get_current_line()
		require("telescope.actions").close(prompt_bufnr)
		vim.schedule(function()
			next_picker(query)
		end)
	end
end

local function picker_options(next_picker, default_text)
	return {
		default_text = default_text,
		attach_mappings = function(_, map)
			local switch = switch_to(next_picker)
			map("i", "<Tab>", switch)
			map("n", "<Tab>", switch)
			return true
		end,
	}
end

find_files = function(default_text)
	require("telescope.builtin").find_files(picker_options(live_grep, default_text))
end

live_grep = function(default_text)
	require("telescope.builtin").live_grep(picker_options(find_files, default_text))
end

return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{ "<leader>ts", find_files, desc = "Telescope search" },
		{
			"<leader>tw",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope windows",
		},
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			extensions = {
				hierarchy = {
					initial_multi_expand = true,
					multi_depth = 10,
					warm_parser_on_bufenter = true,
				},
			},
		})
		telescope.load_extension("fzf")
	end,
}
