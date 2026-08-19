-- Filesystem editing, directory startup view, and file/Oil path actions.
-- Oil buffers represent directories, so both path actions can share the same lookup.
local function handle_path(action)
	local oil_dir = require("oil").get_current_dir()
	local path = oil_dir or vim.api.nvim_buf_get_name(0)
	local is_directory = oil_dir ~= nil
	if path == "" then
		path = vim.fn.getcwd()
		is_directory = true
	end

	if action == "open" then
		if vim.fn.has("wsl") == 0 then
			vim.notify("Windows Explorer is WSL-only", vim.log.levels.WARN)
			return
		end
		-- Explorer opens the current Oil directory or the parent of a normal file.
		if not is_directory then
			path = vim.fs.dirname(path)
		end
		local winpath = vim.fn.system({ "wslpath", "-w", path })
		if vim.v.shell_error ~= 0 then
			vim.notify("Could not convert path for Windows Explorer", vim.log.levels.ERROR)
			return
		end
		vim.fn.jobstart({ "explorer.exe", vim.trim(winpath) })
	else
		vim.fn.setreg("+", path)
		vim.notify("Copied: " .. path)
	end
end

return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Oil",
		},
		{
			"<leader>fe",
			function()
				handle_path("open")
			end,
			desc = "Open in Windows Explorer",
		},
		{
			"<leader>yp",
			function()
				handle_path("yank")
			end,
			desc = "Yank path",
		},
	},
	config = function()
		local git_hidden_files = require("modules.git_hidden_files")
		local oil = require("oil")
		local show_details = false

		git_hidden_files.setup()

		oil.setup({
			-- Keep deletes recoverable while skipping prompts for harmless one-file edits.
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			-- Pick up files created outside Neovim, such as from tmux or Git.
			watch_for_changes = true,
			view_options = {
				show_hidden = false,
				is_hidden_file = git_hidden_files.is_hidden,
			},
			keymaps = {
				-- Do not let Oil replace the global save mapping or add split/tab shortcuts.
				["<C-h>"] = false,
				["<C-s>"] = false,
				["<C-t>"] = false,
				["gd"] = {
					desc = "Toggle file details",
					callback = function()
						show_details = not show_details
						oil.set_columns(
							show_details and { "icon", "permissions", "size", "mtime" }
								or { "icon" }
						)
					end,
				},
			},
		})

		-- Only replace an untouched, no-argument startup buffer with the current directory.
		vim.api.nvim_create_autocmd("StdinReadPre", {
			once = true,
			callback = function()
				vim.g.oil_started_with_stdin = true
			end,
		})
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = vim.schedule_wrap(function()
				if
					vim.fn.argc() == 0
					and not vim.g.oil_started_with_stdin
					and vim.bo.filetype == ""
				then
					oil.open(vim.fn.getcwd())
				end
			end),
		})
	end,
}
