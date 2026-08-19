-- Renders Markdown in normal mode and adds checkbox actions outside the Obsidian vault.
local vault = vim.fs.normalize(vim.env.OBSIDIAN_PATH or vim.fn.expand("~/obsidian"))

local function set_non_vault_checkbox_map(buf)
	local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
	if path == vault or vim.startswith(path, vault .. "/") then
		return
	end

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_get_current_line()
		local before, state, after = line:match("^(%s*[%-%+%*]%s+)%[([^%]])%](%s*.*)$")
		if not state then
			vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
			return
		end

		if state == " " then
			vim.api.nvim_set_current_line(before .. "[x]" .. after)
		else
			-- A checked or old custom state becomes a normal bullet again.
			vim.api.nvim_set_current_line(before .. after:gsub("^%s*", "", 1))
		end
	end, { buffer = buf, desc = "Cycle checkbox" })
end

return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- In nofile buffers (LSP hover), keep rendering but drop the code border
		-- which adds lines after the window is sized, causing overflow.
		overrides = {
			buftype = {
				nofile = {
					code = {
						border = "hide",
						left_pad = 0,
						language = false,
					},
				},
			},
		},
		-- Keep the cursor line fully rendered; modes outside normal already show raw text.
		anti_conceal = { enabled = false },
		-- There is no LaTeX parser or converter installed.
		latex = { enabled = false },
		inline_highlight = { enabled = false },
		win_options = {
			conceallevel = { default = 0, rendered = 2 },
			concealcursor = { rendered = "n" },
		},
		render_modes = { "n" },
		heading = {
			icons = {},
		},
		code = {
			left_pad = 1,
			border = "thin",
		},
		bullet = {
			icons = { "•" },
		},
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)
		-- The plugin loads after FileType, so apply the map to the current buffer too.
		local checkbox_group = vim.api.nvim_create_augroup("MarkdownCheckbox", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = checkbox_group,
			pattern = "markdown",
			callback = function(event)
				set_non_vault_checkbox_map(event.buf)
			end,
		})
		if vim.bo.filetype == "markdown" then
			set_non_vault_checkbox_map(vim.api.nvim_get_current_buf())
		end
	end,
}
