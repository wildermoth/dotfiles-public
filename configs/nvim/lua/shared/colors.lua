-- Load shared palette from configs/theme/palette.json.
local M = {}

local function repo_root()
	local env = vim.env.DOTFILES_DIR
	if env and env ~= "" then
		return env
	end
	local source = debug.getinfo(1, "S").source
	if source:sub(1, 1) == "@" then
		-- ~/.config/nvim is a symlink to $DOTFILES_DIR/configs/nvim;
		-- resolve first or :h:h:h:h:h lands on ~/.config.
		local this_file = vim.fn.resolve(vim.fn.fnamemodify(source:sub(2), ":p"))
		return vim.fn.fnamemodify(this_file, ":h:h:h:h:h")
	end
	return vim.fn.expand("~/dotfiles")
end

local function resolve_group(mapping, palette)
	local out = {}
	for key, ref in pairs(mapping) do
		local hex = palette[ref]
		if type(hex) ~= "string" then
			error("unknown palette color: " .. tostring(ref))
		end
		out[key] = hex
	end
	return out
end

local function load_theme()
	local path = repo_root() .. "/configs/theme/palette.json"
	local lines = vim.fn.readfile(path)
	if vim.tbl_isempty(lines) and vim.fn.filereadable(path) == 0 then
		error("cannot read palette: " .. path)
	end
	local data = vim.json.decode(table.concat(lines, "\n"))
	local palette = data.palette
	if type(palette) ~= "table" then
		error("palette.json: missing palette")
	end
	local theme = { colors = palette }
	for group, mapping in pairs(data) do
		if group ~= "palette" then
			theme[group] = resolve_group(mapping, palette)
		end
	end
	return theme
end

local theme = load_theme()
for key, value in pairs(theme) do
	M[key] = value
end

return M
