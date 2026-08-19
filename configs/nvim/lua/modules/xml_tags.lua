-- Insert or wrap with an XML tag pair (<leader>lx).
local M = {}

local function prompt_xml_tag_name()
	local tag_name = vim.trim(vim.fn.input("XML tag > "))

	if tag_name == "" then
		return nil
	end

	tag_name = tag_name:gsub("^</?", ""):gsub(">$", "")

	if tag_name:find("%s") then
		vim.notify("XML tag names cannot contain spaces", vim.log.levels.WARN)
		return nil
	end

	return tag_name
end

local function insert_xml_tag_pair()
	local tag_name = prompt_xml_tag_name()
	if not tag_name then
		return
	end

	local open_tag = string.format("<%s>", tag_name)
	local close_tag = string.format("</%s>", tag_name)
	local cursor = vim.api.nvim_win_get_cursor(0)

	vim.api.nvim_buf_set_text(
		0,
		cursor[1] - 1,
		cursor[2],
		cursor[1] - 1,
		cursor[2],
		{ open_tag .. close_tag }
	)
	vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #open_tag })
end

local function wrap_visual_with_xml_tag()
	local tag_name = prompt_xml_tag_name()
	if not tag_name then
		return
	end

	local visual_mode = vim.fn.mode()
	if visual_mode == "\22" then
		vim.notify("Blockwise XML wrapping is not supported", vim.log.levels.WARN)
		return
	end

	local open_tag = string.format("<%s>", tag_name)
	local close_tag = string.format("</%s>", tag_name)
	local start_pos = vim.fn.getpos("v")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local start_line = start_pos[2]
	local end_line = cursor[1]

	if visual_mode == "V" then
		local start_row
		local end_row

		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		start_row = start_line - 1
		end_row = end_line - 1

		vim.api.nvim_buf_set_lines(0, start_row, start_row, false, { open_tag })
		vim.api.nvim_buf_set_lines(0, end_row + 2, end_row + 2, false, { close_tag })
		vim.api.nvim_win_set_cursor(0, { start_row + 2, 0 })
		return
	end

	local start_char = start_pos[3]
	local end_char = cursor[2] + 1

	if start_line > end_line or (start_line == end_line and start_char > end_char) then
		start_line, end_line = end_line, start_line
		start_char, end_char = end_char, start_char
	end

	local start_row = start_line - 1
	local start_col = start_char - 1
	local end_row = end_line - 1
	local end_col = end_char
	local selected_text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})

	selected_text[1] = open_tag .. selected_text[1]
	selected_text[#selected_text] = selected_text[#selected_text] .. close_tag

	vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, selected_text)
	vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col + #open_tag })
end

function M.setup()
	vim.keymap.set("n", "<leader>lx", insert_xml_tag_pair, { desc = "Insert XML tag pair" })
	vim.keymap.set(
		"x",
		"<leader>lx",
		wrap_visual_with_xml_tag,
		{ desc = "Wrap selection in XML tag" }
	)
end

return M
