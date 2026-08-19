-- Jump to labeled targets with s; S is Treesitter nodes. Char f/t stay vanilla.
local function with_raw_markdown(fn)
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].filetype ~= "markdown" then
		return fn()
	end

	-- The public toggle redraws later; Flash needs the extmarks gone synchronously.
	local ok_state, state = pcall(require, "render-markdown.state")
	local ok_ui, ui = pcall(require, "render-markdown.core.ui")
	if not (ok_state and ok_ui) then
		return fn()
	end

	local config = state.get(buf)
	if not config.enabled then
		return fn()
	end

	-- Flash stays in normal mode, so hide rendering before it calculates target columns.
	local win = vim.api.nvim_get_current_win()
	local conceallevel = vim.wo[win].conceallevel
	config.enabled = false
	vim.wo[win].conceallevel = 0
	for _, extmark in ipairs(ui.get(buf):get()) do
		extmark:hide(ui.ns, buf)
	end
	vim.cmd("redraw!")

	local ok, result = xpcall(fn, debug.traceback)
	config.enabled = true
	if vim.api.nvim_win_is_valid(win) then
		vim.wo[win].conceallevel = conceallevel
	end
	require("render-markdown").render({ buf = buf, event = "FlashLeave" })
	if not ok then
		error(result, 0)
	end
	return result
end

return {
	"folke/flash.nvim",
	opts = {
		modes = {
			char = { enabled = false },
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				return with_raw_markdown(require("flash").jump)
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				return with_raw_markdown(require("flash").treesitter)
			end,
			desc = "Flash Treesitter",
		},
	},
}
