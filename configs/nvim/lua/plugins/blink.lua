-- Insert-mode completion (LSP and path). Tab accepts; C-k is signature help.
return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	dependencies = {
		-- LuaSnip fills function parens / snippet tabstops. Not a blink source.
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	opts = {
		keymap = {
			preset = "none",
			["<C-Down>"] = { "select_next", "fallback" },
			["<C-Up>"] = { "select_prev", "fallback" },
			["<S-Tab>"] = { "show", "fallback" },
			["<Tab>"] = { "accept", "fallback" },
			["<C-Right>"] = { "show_documentation", "fallback" },
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},
		sources = {
			default = { "lsp", "path" },
		},
		snippets = { preset = "luasnip" },
		completion = {
			menu = {
				min_width = 60,
				scrollbar = false,
			},
			documentation = {
				auto_show = false,
			},
			list = {
				selection = { auto_insert = false },
			},
		},
		signature = {
			enabled = true,
			window = { show_documentation = false },
		},
		cmdline = {
			enabled = false,
		},
	},
}
