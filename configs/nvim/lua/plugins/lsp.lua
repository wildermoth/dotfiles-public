-- LSP servers (ty, ruff, lua_ls), blink capabilities, and buffer maps.
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
		"SmiteshP/nvim-navic",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local navic = require("nvim-navic")
		navic.setup()

		local function setup_server(name, cfg)
			cfg = cfg or {}
			cfg.capabilities = vim.tbl_deep_extend("force", cfg.capabilities or {}, capabilities)
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end

		setup_server("ty", {
			settings = {
				ty = {
					completions = {
						autoImport = true,
					},
				},
			},
		})

		setup_server("ruff", {})

		setup_server("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, ev.buf)
				end

				local map = function(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
				end

				map("gd", vim.lsp.buf.definition, "Go to definition")

				map("<leader>ln", vim.lsp.buf.rename, "Rename")

				map("<leader>lr", "<cmd>LspRestart<CR>", "Reload LSP")

				map("gr", function()
					require("telescope.builtin").lsp_references()
				end, "References")

				map("]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Next diagnostic")
				map("[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Prev diagnostic")
			end,
		})
	end,
}
