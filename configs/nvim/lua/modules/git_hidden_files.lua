-- Oil hides gitignored files and untracked dotfiles.
local M = {}

local function parse_output(proc, hoist_top)
	local result = proc:wait()
	local paths = {}

	if result.code == 0 then
		for path in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			path = path:gsub("/$", "")
			paths[path] = true
			-- Tracked files live under dirs. Hoist so `lua/foo.lua` keeps `lua` visible.
			-- Do not hoist ignored paths: `configs/nvim/nvim` (gitignored) must not hide `configs/`.
			if hoist_top then
				local top = path:match("^[^/]+")
				if top then
					paths[top] = true
				end
			end
		end
	end

	return paths
end

local function new_git_status()
	return setmetatable({}, {
		__index = function(cache, dir)
			local ignored_proc = vim.system(
				{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
				{ cwd = dir, text = true }
			)
			local tracked_proc = vim.system(
				{ "git", "ls-files", "--cached", "--", "." },
				{ cwd = dir, text = true }
			)
			local status = {
				ignored = parse_output(ignored_proc, false),
				tracked = parse_output(tracked_proc, true),
			}

			rawset(cache, dir, status)
			return status
		end,
	})
end

local git_status = new_git_status()

function M.is_hidden(name, bufnr)
	local dir = require("oil").get_current_dir(bufnr)
	local is_dotfile = vim.startswith(name, ".") and name ~= ".."

	if not dir then
		return is_dotfile
	end

	if is_dotfile then
		return not git_status[dir].tracked[name]
	end

	return git_status[dir].ignored[name]
end

function M.setup()
	local refresh = require("oil.actions").refresh
	local original_refresh = refresh.callback

	refresh.callback = function(...)
		git_status = new_git_status()
		return original_refresh(...)
	end
end

return M
