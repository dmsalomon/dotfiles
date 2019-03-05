
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Plugin" 'VundleVim/Vundle.vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
"Plugin 'dylanaraps/wal'
"Plugin 'embear/vim-localvimrc'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'
"Plugin 'tpope/vim-fugitive'
"Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'scrooloose/nerdtree'
"Plugin 'jnurmine/Zenburn'
"Plugin 'altercation/vim-colors-solarized'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'sickill/vim-pasta'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'powerline/powerline'
"Plugin 'tpope/vim-commentary.git'
"Plugin 'ying17zi/vim-live-latex-preview'
Plugin 'fatih/vim-go'
"Plugin 'pangloss/vim-javascript'
"Plugin 'mxw/vim-jsx'
Plugin 'ajh17/VimCompletesMe'

call vundle#end()

let mapleader=" "

set nocompatible
set noswapfile
set number relativenumber
set so=10
set clipboard=unnamedplus
set mouse=a
set wildmode=longest,list,full
set exrc
filetype plugin indent on

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+={SyntaticStatusLineFlag()}
"set statusline+=%*
"let g:syntastic_check_on_open=1
"let g:syntastic_check_on_wq=0

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

command -nargs=* Python :term python <args>
nnoremap <leader>p :w<CR>:term python %<CR>

vnoremap <C-c> "+y
map <C-p> "+P

