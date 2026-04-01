vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- When selected Shift-V K and J will move the selected lines up and down respectively
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Append line below to end of line that cursor is currently on
vim.keymap.set("n", "J", "mzJ`z")

-- When half page jumping (Ctrl-d, Ctrl-u) keep cursor in middle of page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- When searching will keep cursor in middle when going to next and previous
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy highlighted word into void register and paste from current register
-- Essentailly paste while keeping whatever was previously in the register
vim.keymap.set("n", "<leader>p", "\"_dP")

-- Leader y will allow yo uto use yank commands that put everything into the system clipboard instead of vims clipboard
vim.keymap.set("n", "<leader>y", "+y")
vim.keymap.set("v", "<leader>y", "+y")
vim.keymap.set("n", "<leader>Y", "+Y")

-- Disable Q for quit
vim.keymap.set("n", "Q", "<nop>")

-- <leader> f will format current buffer using lsp
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)
