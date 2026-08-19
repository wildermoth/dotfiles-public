-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup("plugins", {
	rocks = { enabled = false },
	ui = {
		border = "rounded",
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			reset = true,
			-- Disable some rtp plugins for faster startup
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})
