-- Global keymaps
vim.g.mapleader = " "

local runner = require("modules.runner")

-- Navigation
vim.keymap.set("n", "<Tab>", "<C-w>w", { desc = "Next window" })

vim.keymap.set("n", "<leader>n", "<C-o>", { desc = "Jump-List Back" })
vim.keymap.set("n", "<leader>i", "<C-i>", { desc = "Jump-List Forward" })
vim.keymap.set("n", "<leader>N", "<cmd>cprev<CR>zz", { desc = "Quickfix Prev" })
vim.keymap.set("n", "<leader>I", "<cmd>cnext<CR>zz", { desc = "Quickfix Next" })

vim.keymap.set({ "n", "v" }, "Q", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Page scrolling
vim.keymap.set("n", "<C-Down>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<M-Down>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<S-Down>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<C-Up>", "<C-u>zz", { desc = "Scroll up (centered)" })
vim.keymap.set("n", "<M-Up>", "<C-u>zz", { desc = "Scroll up (centered)" })
vim.keymap.set("n", "<S-Up>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

vim.keymap.set({ "i", "n", "v" }, "<M-a>", "<Esc>ggVG", { desc = "Select whole file" })

-- Word navigation and deletion
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set({ "i", "n", "v" }, "<M-Left>", "<C-Left>", { desc = "Move one word backward" })
vim.keymap.set({ "i", "n", "v" }, "<M-Right>", "<C-Right>", { desc = "Move one word forward" })

-- Save or return to normal mode
for _, key in ipairs({ "<C-s>", "<M-s>" }) do
	vim.keymap.set({ "i", "v" }, key, "<Esc>", { desc = "Escape to normal mode" })
	vim.keymap.set("n", key, "<cmd>write<CR>", { desc = "Save" })
end

-- Line movement
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

vim.keymap.set("n", "<C-S-Down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<C-S-Up>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<C-S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<leader>v", "<C-v>", { remap = true, desc = "Visual block mode" })

-- File runners
vim.keymap.set("n", "<leader>fr", runner.run_file, { desc = "Run file" })
vim.keymap.set("n", "<leader>ft", runner.test_file, { desc = "Test file" })
