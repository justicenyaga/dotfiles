-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- Insert mode mappings for adding braces with a newline
-- keymap.set("i", "{<CR>", "{<CR>}<Esc>ko<Tab>", { noremap = true, silent = true })
-- keymap.set("i", "[<CR>", "[<CR>]<Esc>ko<Tab>", { noremap = true, silent = true })
-- keymap.set("i", "(<CR>", "()<CR><Esc>ko<Tab>", { noremap = true, silent = true })

-- Select All
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Resize window
keymap.set("n", "<up>", "<C-w>+", { desc = "Increase window height" })
keymap.set("n", "<down>", "<C-w>-", { desc = "Decrease window height" })
keymap.set("n", "<right>", "<c-w>>", { desc = "Increase window width" })
keymap.set("n", "<left>", "<c-w><", { desc = "Decrease window width" })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Find and Replace Keymap
keymap.set("n", "<leader>rc", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Find and replace under cursor" })
keymap.set("n", "<leader>rw", ":%s//gc<Left><Left><Left>", { desc = "Find and Replace a word" })

-- Git Graph
keymap.set("n", "<leader>gg", ":Flog<CR>", { noremap = true, silent = true, desc = "Open Git Graph" })

-- Live Server
keymap.set("n", "<leader>ls", "<cmd>LiveServerToggle<cr>", { desc = "Toggle live server" })

-- WakaTime
keymap.set("n", "<leader>ct", ":WakaTimeToday<cr>", { desc = "Echo today's coding time" })
