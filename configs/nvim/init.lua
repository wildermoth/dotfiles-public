-- Load core configuration
if vim.loader then
	vim.loader.enable()
end

-- Settings
require("core.options")

-- Keymap
require("core.keymaps")

-- Custom Functions
require("modules.xml_tags").setup()
require("modules.python_fstring").setup()

-- Plugin manager and plugins
require("core.lazy")
