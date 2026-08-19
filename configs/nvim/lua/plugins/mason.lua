-- Installs the LSP servers configured in lsp.lua.
return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
	build = ":MasonUpdate",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_enable = false,
			ensure_installed = {
				"lua_ls",
				"ty",
				"ruff",
			},
		})

		-- stylua is a formatter (conform), not an LSP.
		local ok, registry = pcall(require, "mason-registry")
		if ok then
			local function ensure(name)
				local pkg_ok, pkg = pcall(registry.get_package, name)
				if pkg_ok and pkg and not pkg:is_installed() then
					pkg:install()
				end
			end
			if registry.refresh then
				registry.refresh(function()
					ensure("stylua")
				end)
			else
				ensure("stylua")
			end
		end
	end,
}
