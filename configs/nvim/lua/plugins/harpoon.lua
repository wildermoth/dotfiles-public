-- Pin files and jump with Alt-1..7; <leader>fh opens the list in Telescope.
local function nav_file(idx)
	return function()
		require("harpoon"):list():select(idx)
	end
end

local function harpoon_telescope()
	local harpoon = require("harpoon")
	local items = harpoon:list().items
	if #items == 0 then
		vim.notify("Harpoon list is empty", vim.log.levels.INFO)
		return
	end

	local paths = {}
	for _, item in ipairs(items) do
		table.insert(paths, item.value)
	end

	local conf = require("telescope.config").values
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = paths,
				entry_maker = function(path)
					return {
						value = path,
						display = path,
						ordinal = path,
						path = path,
					}
				end,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>fH",
			function()
				require("harpoon"):list():add()
			end,
			desc = "File Harpoon add",
		},
		{ "<leader>fh", harpoon_telescope, desc = "File Harpoon List" },
		{ "<M-1>", nav_file(1), desc = "Harpoon 1" },
		{ "<M-2>", nav_file(2), desc = "Harpoon 2" },
		{ "<M-3>", nav_file(3), desc = "Harpoon 3" },
		{ "<M-4>", nav_file(4), desc = "Harpoon 4" },
		{ "<M-5>", nav_file(5), desc = "Harpoon 5" },
		{ "<M-6>", nav_file(6), desc = "Harpoon 6" },
		{ "<M-7>", nav_file(7), desc = "Harpoon 7" },
	},
	config = function()
		require("harpoon"):setup()
	end,
}
