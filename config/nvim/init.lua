
local util = require'dms.util'
local augroup = vim.api.nvim_create_augroup('vimrc', { clear = true })

util.disable {
  'backup',
  'compatible',
  'swapfile',
  'cursorline',
  'showmode',
  'hlsearch',
  'list',
}
util.enable {
  'number',
  'relativenumber',
  'exrc',
  'modeline',
  'ignorecase',
  'smartcase',
  'undofile',
  'visualbell',
  'splitbelow',
  'splitright',
}

vim.opt.so = 10
vim.opt.mouse = 'a'
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.spelllang = 'en_us'
vim.opt.undodir = vim.fn.expand('~/.cache/vim/undo')
vim.opt.laststatus = 3
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.dictionary:append('/usr/share/dict/words')
vim.opt.lcs = 'tab:> ,lead:.'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.tags = { "./tags", "./TAGS", "tags", "./.git/tags;~" }

if util.has('unnamedplus') then
  vim.opt.clipboard = 'unnamedplus'
else
  vim.opt.clipboard = 'unnamed'
end

vim.cmd[[
  syntax enable
  filetype plugin indent on
]]

vim.g.mapleader = ' '
vim.g.java_ignore_javadoc = 1

-- python3
local py3venv = vim.fn.expand('~/.local/share/nvim/site/py3nvim/bin')
if vim.fn.isdirectory(py3venv) then
  vim.g.python3_host_prog = py3venv .. '/python'
end

if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --no-heading --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end


vim.keymap.set('n', '<up>',    '<nop>')
vim.keymap.set('n', '<down>',  '<nop>')
vim.keymap.set('n', '<left>',  '<nop>')
vim.keymap.set('n', '<right>', '<nop>')

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<cr>', { silent = true })
vim.keymap.set('n', '<leader>sv', ':luafile $MYVIMRC<cr>')

vim.keymap.set('t', '<esc>', "<c-\\><c-n>")
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "*",
  callback = function()
    vim.keymap.set('', 'q', ':bd<cr>', { silent = true, buffer = true, })
    -- vim.cmd[[ startinsert ]]
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd('filetype', {
  pattern = "help",
  callback = function()
    vim.keymap.set('n', '<cr>', '<c-]>', { silent = true, buffer = true })
    vim.keymap.set('n', '<bs>', '<c-T>', { silent = true, buffer = true })
    vim.keymap.set('n', 'q', ':q!<cr>', { silent = true, buffer = true })
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd('filetype', {
  pattern = "fugitiveblame",
  callback = function()
    vim.keymap.set('n', 'q', ':q!<cr>', { silent = true, buffer = true })
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = "*",
  callback = function()
    require'vim.highlight'.on_yank({ timeout = 120 })
  end,
  group = augroup,
})

local au = function(events, pattern, action, arg)
  local opts = {}
  if type(action) == "function" then
    opts.callback = action
  else
    opts.command = action
  end
  vim.api.nvim_create_autocmd(events, vim.tbl_extend("force", arg or {}, {
    pattern = pattern,
    group = augroup,
  }, opts))
end

au({ 'BufRead', 'BufNewFile' }, '/etc/nginx/sites-*/*', 'set ft=nginx')
au({ 'BufRead', 'BufNewFile' }, { "*.tf", "*.hcl" }, 'set ft=terraform')
au({ 'BufRead', 'BufNewFile' }, "*.tpl", 'set ft=helm')
au('BufWritePost', { "*Xresources", "*Xdefaults" }, '!xrdb -merge %')
au('BufWritePost', '*sxhkdrc', '!pkill -USR1 sxhkd')
au('BufWritePre', '*.tf', vim.lsp.buf.formatting_sync, { desc = "LSP format" })

vim.keymap.set('n', '<leader>gh', [[:h <c-r>=expand("<cexpr>")<cr><cr>]])
vim.keymap.set('v', '<leader>e64', [[c<c-r>=system('base64', @")."\n"<cr><esc>]])
vim.keymap.set('v', '<leader>d64', [[c<c-r>=system('base64 --decode', @")."\n"<cr><esc>]])
vim.keymap.set('n', '<leader>ww', ':w<cr>', { silent = true })

require'dms'

if util.has'gui_running' then
  vim.cmd[[ colorscheme nord ]]
elseif util.isdirectory'~/.cache/wal' then
  vim.cmd[[ source $HOME/.cache/wal/colors-wal.vim ]]
  if vim.g.color1 == '#ff5555' then
    vim.cmd[[ colorscheme dracula ]]
  else
    vim.cmd[[ colorscheme wal ]]
  end
else
  vim.cmd[[colorscheme dracula]]
end
vim.cmd[[ highlight WinSeparator guibg=None ]]
