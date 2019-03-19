
call plug#begin('~/.vim/plugged')

Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'latex' }
"Plug 'embear/vim-localvimrc'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
"Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'bronson/vim-trailing-whitespace'
Plug 'sickill/vim-pasta'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'

call plug#end()

let mapleader=" "

set nocompatible
set noswapfile
set number relativenumber
set so=10
set clipboard=unnamedplus
set mouse=a
set wildmode=longest,list,full
set exrc
set modeline
filetype plugin indent on

set laststatus=2
set noshowmode

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ }

syntax on
set visualbell

colorscheme delek
"colorscheme wal

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype ruby  setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

let g:LatexBox_latexmk_preview_continuously = 1

"splitting options
set splitbelow splitright

set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
"set complete+=k

" no arrow keys
noremap <Up>	<Nop>
noremap <Down>	<Nop>
noremap <Left>	<Nop>
noremap <Right>	<Nop>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <leader>o :setlocal spell! spelllang=en_us<CR>
command TrimSpace :%s/\s\+$//e |

autocmd BufWritePre * TrimSpace

command -nargs=* Python :term python3 <args>
nnoremap <leader>p :w<CR>:Python %<CR>

set tags=./tags,./TAGS,tags,./.git/tags;~
