local map = vim.keymap.set

map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("n", "<left>", "<nop>")
map("n", "<right>", "<nop>")

map("n", "<c-h>", "<c-w>h")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")

map("n", "<leader>ev", ":edit $MYVIMRC<cr>", { silent = true })
map("n", "<leader>sv", ":luafile $MYVIMRC<cr>")

map("t", "<esc>", "<c-\\><c-n>")

map("n", "<leader>gh", [[:h <c-r>=expand("<cexpr>")<cr><cr>]])
map("v", "<leader>e64", [[c<c-r>=system('base64', @")."\n"<cr><esc>]])
map("v", "<leader>d64", [[c<c-r>=system('base64 --decode', @")."\n"<cr><esc>]])
map("n", "<leader>ww", ":w<cr>", { silent = true })
map("n", "<leader>cp", ":Copilot enable<cr>", { silent = true })
