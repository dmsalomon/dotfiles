
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex', {'for': 'latex'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
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
Plug 'rhysd/vim-llvm'
Plug 'JuliaEditorSupport/julia-vim'

Plug 'vim-scripts/nginx.vim'

Plug 'reedes/vim-pencil', {'on': ['Pencil', 'SoftPencil', 'TogglePencil']}
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'sgur/vim-editorconfig'

Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'baskerville/vim-sxhkdrc'
" Plug 'vimwiki/vimwiki', {'branch': 'dev'}

Plug 'ntpeters/vim-better-whitespace'
Plug 'Chiel92/vim-autoformat'

Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'
Plug 'frazrepo/vim-rainbow'
Plug 'severin-lemaignan/vim-minimap'

Plug 'unblevable/quick-scope'

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
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'dylanaraps/wal.vim'

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
set ignorecase smartcase
set nocursorline
filetype plugin indent on

set laststatus=2
set noshowmode

set foldmethod=indent
set foldlevelstart=99

syntax on
set visualbell

let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1
let g:strip_whitespace_confirm = 0
let g:strip_max_file_size = 0

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

let g:vimtex_view_method = 'mupdf'

let g:lightline = {
  \ 'colorscheme': 'dracula',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'filetype': 'DevIconsFiletype',
  \   'fileformat': 'DevIconsFileformat',
  \ },
  \ }

let g:dracula_colorterm = 0

function! DevIconsFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! DevIconsFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

if has('gui_running')
  colorscheme nord
elseif isdirectory(expand('~') . '/.cache/wal')
  source $HOME/.cache/wal/colors-wal.vim
  if color1 == '#ff5555'
    colorscheme dracula
  else
    colorscheme wal
  endif
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
  au filetype cpp        setlocal noet ts=4 sw=4 sts=4
  au filetype sql        setlocal noet ts=4 sw=4 sts=4
  au filetype yaml       setlocal et   ts=2 sw=2 sts=2
  au filetype julia      setlocal et   ts=2 sw=2 sts=2
  au filetype r          setlocal et   ts=2 sw=2 sts=2
  au filetype sh         setlocal noet ts=4 sw=4 sts=4
  au filetype mail       setlocal tw=80
augroup end

"splitting options
set splitbelow splitright

set dictionary+=/usr/share/dict/words
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

noremap <silent><leader>w :ToggleWhitespace<cr>

command! -nargs=* -complete=file Run call RunProg(<f-args>)
nnoremap <silent><leader>r :w<cr>:Run<cr>

function! Executable(...)
  if a:0 == 1
    let file = a:1
  else
    let file = expand('%:p')
  endif
  if file ==? ''
    return 0
  endif
  call system('test -x ' . file)
  return v:shell_error==0
endfunction

function! RunProg(...) abort
  if getline(1) =~? '\v^\s*#!' && Executable()
    let prog = "./"
  elseif &filetype ==? "c"
    let prog = "tcc -run "
  elseif &filetype ==? "python"
    let prog = "python "
  elseif &filetype ==? "sh"
    let prog = "sh "
  else
    echoerr "Unsupported filetype"
    return
  endif

  let prog = prog . '%'
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
  au filetype mail,markdown,tex,text,vimwiki Pencil
augroup end

nnoremap <silent><leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

if has('terminal')
  tnoremap <esc> <c-\><c-n>
  if exists('##TerminalOpen')
    augroup vimrc
      au TerminalOpen * noremap <silent><buffer>q :bd<cr>
    augroup end
  endif
endif

augroup vimrc
  au filetype help call HelpFileMode()
augroup end
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

" let g:vimwiki_list = [
"   \ {
"   \   'path': '~/nextcloud/compsci/databases/notes',
"   \ }
"   \ ]

augroup vimrc
  au BufRead,BufNewFile /etc/nginx/sites-*/* set ft=nginx
  au BufWritePost *Xresources,*Xdefaults !xrdb -merge %
  au BufWritePost *sxhkdrc !pkill -USR1 sxhkd
augroup END
