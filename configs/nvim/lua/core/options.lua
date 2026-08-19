-- Neovim options and settings
local opt = vim.opt

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.g.editorconfig = false

opt.shortmess:append("I")

opt.number = true
opt.relativenumber = true
opt.cursorline = true

opt.tabstop = 4
opt.softtabstop = -1
opt.shiftwidth = 4
opt.expandtab = true

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false
opt.textwidth = 100

opt.swapfile = false
opt.undofile = true

opt.hlsearch = false

opt.termguicolors = true

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.winborder = "rounded"
opt.pumborder = "rounded"

opt.updatetime = 250

vim.lsp.log.set_level("OFF")

opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldcolumn = "1"
opt.fillchars:append({
	foldopen = " ",
	foldclose = "",
	foldsep = " ",
	foldinner = " ",
})
opt.statuscolumn = "%s%C%=%l "
