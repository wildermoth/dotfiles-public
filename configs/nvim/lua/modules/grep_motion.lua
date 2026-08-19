-- Telescope grep from a motion or visual selection, plus a prompt.
local M = {}

local selection_types = {
	char = "v",
	line = "V",
	block = "\22",
}

local function grep(lines)
	local search = vim.trim(table.concat(lines, " "))
	if search ~= "" then
		require("telescope.builtin").grep_string({ search = search })
	end
end

function M.operator(type)
	grep(vim.fn.getregion(vim.fn.getpos("'["), vim.fn.getpos("']"), {
		type = selection_types[type],
	}))
end

function M.start(mode)
	vim.go.operatorfunc = "v:lua.require'modules.grep_motion'.operator"
	return mode == "line" and "g@_" or "g@"
end

function M.visual()
	grep(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
		type = vim.fn.mode(),
	}))
end

function M.prompt()
	vim.ui.input({ prompt = "Grep: " }, function(input)
		if input then
			grep({ input })
		end
	end)
end

return M
