-- Telescope picker for git log -L of the current line.
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local M = {}

M.line_history = function()
	local line = vim.fn.line(".")
	local rel_file = vim.fn.expand("%")

	local raw = vim.fn.systemlist({
		"git",
		"log",
		string.format("-L%d,%d:%s", line, line, rel_file),
		"--pretty=format:LOG:%H|%h|%an|%ar|%s",
	})
	if vim.v.shell_error ~= 0 then
		vim.notify("git log failed", vim.log.levels.WARN)
		return
	end

	-- Parse output: LOG: lines are metadata, everything else is the diff for that commit
	local entries = {}
	local current_entry = nil
	local current_diff = {}

	for _, l in ipairs(raw) do
		local hash, short, author, date, msg = l:match("^LOG:([^|]+)|([^|]+)|([^|]+)|([^|]+)|(.*)")
		if hash then
			if current_entry then
				current_entry.diff_lines = current_diff
				table.insert(entries, current_entry)
			end
			current_entry = { hash = hash, short = short, author = author, date = date, msg = msg }
			current_diff = {}
		elseif current_entry then
			table.insert(current_diff, l)
		end
	end
	if current_entry then
		current_entry.diff_lines = current_diff
		table.insert(entries, current_entry)
	end

	if #entries == 0 then
		vim.notify("No line history found", vim.log.levels.WARN)
		return
	end

	-- Write each commit's line-specific diff to a temp file for the previewer
	local tmpdir = vim.fn.tempname()
	vim.fn.mkdir(tmpdir, "p")
	for _, e in ipairs(entries) do
		local tmpfile = tmpdir .. "/" .. e.short .. ".diff"
		vim.fn.writefile(e.diff_lines, tmpfile)
		e.tmpfile = tmpfile
	end

	pickers
		.new({}, {
			prompt_title = string.format("Line %d History", line),
			finder = finders.new_table({
				results = entries,
				entry_maker = function(e)
					local display = string.format("%s  %s  %s", e.short, e.author, e.msg)
					return { value = e, display = display, ordinal = display }
				end,
			}),
			sorter = conf.generic_sorter({}),
			-- Pipe the stored line-specific diff through delta.
			-- tail -f /dev/null keeps the process alive so "[Process exited 0]" never appears.
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					return {
						"sh",
						"-c",
						'delta --paging=never --no-gitconfig < "$1"; tail -f /dev/null',
						"sh",
						entry.value.tmpfile,
					}
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				vim.api.nvim_create_autocmd("BufWipeout", {
					buffer = prompt_bufnr,
					once = true,
					callback = function()
						vim.fn.delete(tmpdir, "rf")
					end,
				})
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local sel = action_state.get_selected_entry()
					vim.fn.setreg("+", sel.value.hash)
					vim.notify("Copied " .. sel.value.hash, vim.log.levels.INFO)
				end)
				return true
			end,
		})
		:find()
end

return M
