-- Runs the current file or its tests in a persistent tmux pane.
local M = {}

local commands = {
	python = {
		run = function(file)
			return { "uv", "run", file }
		end,
		test = function(file)
			return { "uv", "run", "pytest", "--failed-first", "-s", "--cov", file }
		end,
	},
	rust = {
		run = function()
			return { "cargo", "run", "--quiet" }
		end,
		test = function()
			return { "cargo", "test" }
		end,
	},
}

local function open_in_tmux(command)
	local escaped = vim.tbl_map(vim.fn.shellescape, command)
	local shell_command = table.concat(escaped, " ") .. '; exec "$SHELL"'

	vim.system(
		{ "tmux", "split-window", "-h", "-l", "30%", shell_command },
		{ text = true },
		function(result)
			if result.code ~= 0 then
				vim.schedule(function()
					local message = vim.trim(result.stderr or "")
					vim.notify(
						message ~= "" and message or "Tmux could not open the runner",
						vim.log.levels.ERROR
					)
				end)
			end
		end
	)
end

local function execute(action)
	local filetype = vim.bo.filetype
	local command = commands[filetype] and commands[filetype][action]
	if not command then
		vim.notify("No " .. action .. " command for " .. filetype, vim.log.levels.WARN)
		return
	end

	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Save the file before running it", vim.log.levels.WARN)
		return
	end

	open_in_tmux(command(file))
end

function M.run_file()
	execute("run")
end

function M.test_file()
	execute("test")
end

return M
