
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex', {'for': 'latex'}
" Plug 'embear/vim-localvimrc'
" Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'bronson/vim-trailing-whitespace'
Plug 'sickill/vim-pasta'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

Plug 'jiangmiao/auto-pairs'
Plug 'reedes/vim-pencil', {'on': 'Pencil'}

Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}

" Colors
Plug 'junegunn/seoul256.vim'
Plug 'mhartington/oceanic-next'
Plug 'vim-scripts/wombat256.vim'
Plug 'jdsimcoe/abstract.vim'
Plug 'tomasr/molokai'
Plug 'sickill/vim-monokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'morhetz/gruvbox'
Plug 'yuttie/hydrangea-vim'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'AlessandroYorba/Despacio'
Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'
Plug 'nightsense/snow'
Plug 'nightsense/stellarized'
Plug 'arcticicestudio/nord-vim'

call plug#end()

let mapleader=" "

set nocompatible
set noswapfile
set number relativenumber
set so=10
set clipboard=unnamed
set mouse=a
set wildmode=longest,list,full
set exrc
set modeline
filetype plugin indent on

set laststatus=2
set noshowmode

set foldmethod=indent
set foldlevelstart=99

let g:vimtex_view_method = 'mupdf'

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ ['mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ },
  \ }

syntax on
set visualbell

colorscheme delek
" colorscheme monokai
" colorscheme wal

augroup vimrc
	au!
	au filetype python setlocal et ts=4 sw=4 sts=4
	au filetype haskell setlocal et ts=4 sw=4 sts=4
	au filetype ruby  setlocal et ts=2 sw=2 sts=2
	au filetype javascript setlocal et ts=2 sw=2 sts=2
	au filetype html setlocal et ts=2 sw=2 sts=2
	au filetype vim setlocal et ts=2 sw=2 sts=2
augroup end

"splitting options
set splitbelow splitright

set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
"set complete+=k

" no arrow keys
noremap <up>	<nop>
noremap <down>	<nop>
noremap <left>	<nop>
noremap <right>	<nop>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

nnoremap <leader>o :setlocal spell! spelllang=en_us<cr>
command TrimSpace :%s/\s\+$//e |

augroup vimrc
	au BufWritePre * TrimSpace
augroup end

command -nargs=* Python :term python3 <args>

augroup vimrc
	au filetype python nnoremap <leader>r :w<cr>:Python %<cr>
	au filetype sh nnoremap <leader>r :term ./%<cr>
augroup end

set tags=./tags,./TAGS,tags,./.git/tags;~

noremap <silent> <leader>g :Goyo<cr>
let g:limelight_conceal_ctermfg = 240
au! User GoyoEnter Limelight
au! User GoyoLeave Limelight!

augroup vimrc
	au filetype markdown,text Pencil
augroup end

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
