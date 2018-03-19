
set nocompatible
set noswapfile
set number relativenumber
set so=10
filetype off
set exrc

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'VundleVim/Vundle.vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'dylanaraps/wal'
Plugin 'localvimrc'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
"Plugin 'powerline/powerline'
"Plugin 'tpope/vim-commentary.git'
"Plugin 'ying17zi/vim-live-latex-preview'

call vundle#end()
filetype plugin indent on

syntax on
set visualbell

colorscheme delek
"colorscheme wal

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype ruby  setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

let g:LatexBox_latexmk_preview_continuously = 1
let g:powerline_pycmd="py3"

"splitting options
set splitbelow
set splitright

set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
"set complete+=k

" no arrow keys
noremap <Up>	<Nop>
noremap <Down>	<Nop>
noremap <Left>	<Nop>
noremap <Right>	<Nop>

if has ("mouse")
	set mouse=a
endif
