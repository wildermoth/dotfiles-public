-- Highlight hex/rgb/hsl color values in the buffer (e.g. #ff7edb).
return {
	"brenoprata10/nvim-highlight-colors",
	event = "BufReadPre",
	opts = {
		enable_named_colors = false,
	},
}
