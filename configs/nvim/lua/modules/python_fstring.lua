-- Auto-prefix f on a Python string when you type { inside it.
local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("InsertCharPre", {
		group = vim.api.nvim_create_augroup("python_fstring", { clear = true }),
		callback = function(args)
			local bufnr = args.buf
			if vim.bo[bufnr].filetype ~= "python" then
				return
			end
			if vim.v.char ~= "{" then
				return
			end

			vim.schedule(function()
				local ok, node = pcall(vim.treesitter.get_node)
				if not ok or not node then
					return
				end

				if node:type() ~= "string" then
					node = node:parent()
				end

				if not node or node:type() ~= "string" then
					return
				end

				local row, col, _, _ = unpack(vim.treesitter.get_range(node))
				local head = vim.api.nvim_buf_get_text(bufnr, row, col, row, col + 2, {})[1] or ""
				if head:find("[fF]") then
					return
				end

				local text = vim.api.nvim_buf_get_text(bufnr, row, col, row, col + 1, {})
				table.insert(text, 1, "f")
				vim.api.nvim_buf_set_text(bufnr, row, col, row, col + 1, { table.concat(text, "") })
			end)
		end,
	})
end

return M
