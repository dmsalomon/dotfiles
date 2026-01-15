local opt = vim.opt

opt.backup = false
opt.compatible = false
opt.swapfile = false
opt.cursorline = false
opt.showmode = false
opt.hlsearch = false
opt.list = false
opt.number = true
opt.relativenumber = true
opt.exrc = true
opt.modeline = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.visualbell = true
opt.splitbelow = true
opt.splitright = true
opt.so = 10
opt.mouse = "a"
opt.wildmode = { "longest", "list", "full" }
opt.spelllang = "en_us"
opt.undodir = vim.fn.expand("~/.cache/vim/undo")
opt.laststatus = 3
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.foldlevel = 99
opt.dictionary:append("/usr/share/dict/words")
opt.lcs = "tab:> ,lead:."
opt.completeopt = { "menu", "menuone", "noselect" }
opt.tags = { "./tags", "./TAGS", "tags", "./.git/tags;~" }

vim.g.java_ignore_javadoc = 1
