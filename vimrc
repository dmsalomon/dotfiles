
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex', {'for': 'latex'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'bronson/vim-trailing-whitespace'
Plug 'sickill/vim-pasta'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}
Plug 'junegunn/vim-easy-align'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'roman/golden-ratio'

Plug 'reedes/vim-pencil', {'on': ['Pencil', 'SoftPencil', 'TogglePencil']}
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'sgur/vim-editorconfig'

Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vimwiki/vimwiki', {'branch': 'dev'}

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
Plug 'therubymug/vim-pyte'

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
set spelllang=en_us
filetype plugin indent on

set laststatus=2
set noshowmode

set foldmethod=indent
set foldlevelstart=99

let g:vimtex_view_method = 'mupdf'

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ },
  \ }

syntax on
set visualbell

if has('gui_running')
  colorscheme nord
else
  colorscheme delek
endif

augroup vimrc
  au!
  au filetype python     setlocal et   ts=4 sw=4 sts=4
  au filetype haskell    setlocal et   ts=4 sw=4 sts=4
  au filetype ruby       setlocal et   ts=2 sw=2 sts=2
  au filetype javascript setlocal et   ts=2 sw=2 sts=2
  au filetype html       setlocal et   ts=2 sw=2 sts=2
  au filetype vim        setlocal et   ts=2 sw=2 sts=2
  au filetype c          setlocal noet ts=4 sw=4 sts=4
augroup end

"splitting options
set splitbelow splitright

set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
"set complete+=k

" no arrow keys
noremap <up>	  <nop>
noremap <down>	<nop>
noremap <left>	<nop>
noremap <right>	<nop>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

function! TrimSpace()
  let save_pos = getpos('.')
  %s/\s\+$//e
  call setpos('.', save_pos)
endfunction

command! TrimSpace call TrimSpace()

augroup vimrc
  au BufWritePre * TrimSpace
augroup end


command! -nargs=* -complete=file Run call RunProg(<f-args>)
nnoremap <silent><leader>r :w<cr>:Run<cr>

function! RunProg(...) abort
  if getline(1) =~? '\v^#!'
    let prog = "./%"
  elseif &filetype ==? "c"
    let prog = "tcc -run %"
  elseif &filetype ==? "python"
    let prog = "python3 %"
  elseif &filetype ==? "sh"
    let prog = "bash %"
  else
    echoerr "Unsupported filetype"
    return
  endif

  if a:0 > 0
    let prog = prog . ' ' . join(a:000, ' ')
  endif
  exec 'terminal' prog
endfunction

set tags=./tags,./TAGS,tags,./.git/tags;~

noremap <silent> <leader>g :GoldenRatioToggle<cr>:Goyo<cr>
let g:limelight_conceal_ctermfg = 240
au! User GoyoEnter Limelight
au! User GoyoLeave Limelight!

let g:pencil#wrapModeDefault = 'soft'

augroup vimrc
  au filetype markdown,tex,text,vimwiki Pencil
augroup end

nnoremap <silent><leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

if has('terminal')
  tnoremap <esc> <c-\><c-n>
  if exists('##TerminalOpen')
    augroup vimrc
      autocmd TerminalOpen * noremap <silent><buffer>q :bd<cr>
    augroup end
  endif
endif

au filetype help call HelpFileMode()
function! HelpFileMode()
  nnoremap <silent><buffer><cr> <c-]>
  nnoremap <silent><buffer><bs> <c-T>
  nnoremap <silent><buffer>q :q!<cr>
endfunction

function! s:thesaurus(...)
  if a:0
    let word = a:1
  else
    let word = expand('<cword>')
  endif

  call system('xdg-open https://www.thesaurus.com/browse/' . word)
endfunction

command! -nargs=? Thesaurus call s:thesaurus(<f-args>)
noremap <leader>t :Thesaurus<cr>

let g:vimwiki_list = [
  \ {
  \   'path': '~/nextcloud/compsci/databases/notes',
  \ }
  \ ]
