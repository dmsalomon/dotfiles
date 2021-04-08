
call plug#begin()

" Tpope
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
Plug 'tpope/vim-speeddating'

" Window
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeFocus', 'NERDTreeToggle'] }
Plug 'sickill/vim-pasta'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'szw/vim-maximizer'
Plug 'airblade/vim-rooter'

" Filetypes
Plug 'lervag/vimtex', { 'for': 'latex' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'udalov/kotlin-vim', { 'for': 'kotlin' }
Plug 'tweekmonster/gofmt.vim', { 'for': 'go' }
Plug 'rhysd/vim-llvm', { 'for': 'llvm' }
Plug 'vim-scripts/nginx.vim', { 'for': 'nginx' }
Plug 'vim-scripts/html-improved-indentation', { 'for': 'html' }
Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }
Plug 'baskerville/vim-sxhkdrc', { 'for': 'sxhkdrc' }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascriptreact'] }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascriptreact' }
Plug 'ap/vim-css-color', { 'for': 'css' }

" Editing
Plug 'reedes/vim-pencil', {'on': ['Pencil', 'SoftPencil', 'TogglePencil']}
Plug 'junegunn/vim-easy-align'
Plug 'jiangmiao/auto-pairs'
Plug 'unblevable/quick-scope'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'

" Misc
Plug 'vim-utils/vim-man', { 'on': ['Man', 'Vman'] }
Plug 'mhinz/vim-rfc', { 'on': 'RFC' }

" Colors
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'dylanaraps/wal.vim'

call plug#end()

set nobackup
set nocompatible
set noswapfile
set number relativenumber
set so=10
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set mouse=a
set wildmode=longest,list,full
set exrc
set modeline
set spelllang=en_us
set ignorecase smartcase
set nocursorline
set undodir=~/.cache/vim/undo
set undofile
set laststatus=2
set noshowmode
set foldmethod=indent
set foldlevelstart=99
set visualbell
set nohlsearch
set splitbelow splitright
set dictionary+=/usr/share/dict/words
syntax enable
filetype plugin indent on

let mapleader=" "

" nvim-treesitter
lua require'nvim-treesitter.configs'.setup {highlight = { enable = true }}

" szw/vim-maximizer
nnoremap <leader>m :MaximizerToggle!<cr>

" fzf
nnoremap <c-p> :Files<cr>

" vim-rooter
let g:rooter_patterns = ['.git', 'Makefile', 'package.json']

let py3venv = expand('~') . '/.local/share/nvim/site/py3nvim/bin'
if isdirectory(py3venv)
  let g:python3_host_prog = py3venv . '/python'
endif

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" vim-better-whitespace
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save  = 1
let g:strip_only_modified_lines = 1
let g:strip_whitespace_confirm  = 0
let g:strip_max_file_size       = 0

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" unblevable/quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

let g:vimtex_view_method = 'mupdf'

let g:rustfmt_autosave = 1

let java_ignore_javadoc = 1

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
  colorscheme dracula
endif

augroup vimrc
  au!
  au filetype python          setlocal et   ts=4 sw=4 sts=4
  au filetype haskell         setlocal et   ts=4 sw=4 sts=4
  au filetype ruby            setlocal et   ts=2 sw=2 sts=2
  au filetype php             setlocal et   ts=4 sw=4 sts=4
  au filetype html            setlocal et   ts=4 sw=4 sts=4
  au filetype vim             setlocal et   ts=2 sw=2 sts=2
  au filetype c               setlocal noet ts=4 sw=4 sts=4
  au filetype cpp             setlocal noet ts=4 sw=4 sts=4
  au filetype sql             setlocal noet ts=4 sw=4 sts=4
  au filetype yaml            setlocal et   ts=2 sw=2 sts=2
  au filetype julia           setlocal et   ts=2 sw=2 sts=2
  au filetype r               setlocal et   ts=2 sw=2 sts=2
  au filetype sh              setlocal noet ts=4 sw=4 sts=4
  au filetype kotlin          setlocal et   ts=4 sw=4 sts=4
  au filetype javascript      setlocal et   ts=2 sw=2 sts=2
  au filetype javascriptreact setlocal et   ts=2 sw=2 sts=2
  au filetype css             setlocal et   ts=4 sw=4 sts=4
  au filetype json            setlocal et   ts=2 sw=2 sts=2
  au filetype lua             setlocal et   ts=4 sw=4 sts=4
  au filetype mail            setlocal noet tw=80
augroup end

" no arrow keys
noremap <up>	  <nop>
noremap <down>	<nop>
noremap <left>	<nop>
noremap <right>	<nop>

" remap windows jumps
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

noremap <silent><leader>w :w<cr>

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
  elseif &filetype ==? "go"
    let prog = "go run "
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

noremap <silent> <leader>go :Goyo<cr>
let g:limelight_conceal_ctermfg = 240
" au! User GoyoEnter Limelight
" au! User GoyoLeave Limelight!

let g:pencil#wrapModeDefault = 'soft'

augroup vimrc
  au filetype mail,markdown,tex,text,vimwiki Pencil
augroup end

nnoremap <silent><leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

tnoremap <esc> <c-\><c-n>
augroup vimrc
  au TermOpen * noremap <silent><buffer>q :bd<cr>
  au TermOpen * startinsert
augroup end
nnoremap <leader>t :split \| term<cr>

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
" nnoremap <leader>th :Thesaurus<cr>
"
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <leader>gh :h <C-R>=expand("<cword>")<CR><CR>

augroup vimrc
  au BufRead,BufNewFile /etc/nginx/sites-*/* set ft=nginx
  au BufWritePost *Xresources,*Xdefaults !xrdb -merge %
  au BufWritePost *sxhkdrc !pkill -USR1 sxhkd
augroup end

augroup vimrc
  au TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 120})
augroup END
