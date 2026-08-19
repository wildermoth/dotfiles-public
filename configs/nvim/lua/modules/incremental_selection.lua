-- Expand/shrink visual selection by Treesitter node (v / V in visual mode).
local M = {}

---@type table<integer, TSNode[]>
local selections = {}

local function visual_range()
	local _, start_row, start_col = unpack(vim.fn.getpos("v"))
	local _, end_row, end_col = unpack(vim.fn.getpos("."))
	if start_row > end_row or (start_row == end_row and start_col > end_col) then
		start_row, end_row = end_row, start_row
		start_col, end_col = end_col, start_col
	end
	return start_row, start_col, end_row, end_col
end

local function node_visual_range(buf, node)
	local start_row, start_col, end_row, end_col = node:range()
	start_row = start_row + 1
	start_col = start_col + 1
	end_row = end_row + 1

	if end_col == 0 then
		end_row = end_row - 1
		local line = vim.api.nvim_buf_get_lines(buf, end_row - 1, end_row, false)[1] or ""
		end_col = math.max(#line, 1)
	end

	return start_row, start_col, end_row, end_col
end

local function range_matches(buf, node)
	local start_row, start_col, end_row, end_col = visual_range()
	local node_start_row, node_start_col, node_end_row, node_end_col = node_visual_range(buf, node)
	return start_row == node_start_row
		and start_col == node_start_col
		and end_row == node_end_row
		and end_col == node_end_col
end

local function select_node(buf, node)
	local start_row, start_col, end_row, end_col = node_visual_range(buf, node)
	if vim.fn.mode() ~= "v" then
		vim.cmd("normal! v")
	end
	vim.api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
	vim.cmd("normal! o")
	vim.api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

local function next_parent(parser, node)
	local parent = node:parent()
	if parent then
		return parent
	end

	local start_row, start_col, end_row, end_col = node:range()
	parent = parser:named_node_for_range({ start_row, start_col, end_row, end_col })
	if parent == node then
		return parent:parent()
	end
	return parent
end

function M.expand()
	local buf = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, buf)
	if not ok then
		return
	end
	parser:parse()

	local start_row, start_col, end_row, end_col = visual_range()
	local range = { start_row - 1, start_col - 1, end_row - 1, end_col }
	local nodes = selections[buf]

	if not nodes or #nodes == 0 or not range_matches(buf, nodes[#nodes]) then
		local node = parser:named_node_for_range(range, { ignore_injections = false })
		if node then
			selections[buf] = { node }
			select_node(buf, node)
		end
		return
	end

	local node = nodes[#nodes]
	repeat
		node = next_parent(parser, node)
	until not node or not range_matches(buf, node)

	if node then
		table.insert(nodes, node)
		select_node(buf, node)
	end
end

function M.shrink()
	local buf = vim.api.nvim_get_current_buf()
	local nodes = selections[buf]
	if not nodes or #nodes < 2 then
		return
	end

	table.remove(nodes)
	select_node(buf, nodes[#nodes])
end

function M.attach(buf)
	vim.keymap.set("x", "v", M.expand, { buffer = buf, desc = "Expand syntax selection" })
	vim.keymap.set("x", "V", M.shrink, { buffer = buf, desc = "Shrink syntax selection" })
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = buf,
		once = true,
		callback = function()
			selections[buf] = nil
		end,
	})
end

return M
