-- Auto-close brackets, quotes, and other pairs while typing.
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = { check_ts = true },
}
