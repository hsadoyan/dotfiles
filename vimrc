" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

let mapleader = ","
 
"------------------------------------------------------------   

set nocompatible			
set background=dark
set termguicolors
set textwidth=120

set linebreak   " turn on word wrapping

set tabstop=2   " Number of spaces per <TAB> when opening a file
set softtabstop=0 noexpandtab  " number of spaces per tab when editing a file
set expandtab   "turn <TAB> into 4 spaces. Good for python and bash.
set shiftwidth=2


set number  " Show line numbers
set showcmd " show command in bottom bar

filetype indent plugin on " pretty self explanatory. Sets filetype-specific indents.
syntax on " enable syntax highlighting
set wildmenu " enable command line completion
set wildignore+=*/node_modules/*,*/vendor/*

set lazyredraw  " redraw only when you have to. Can make things faster.

set showmatch   " fucking great one. Highlights matching parenthases. 

set incsearch   " search as characters are entered
set hlsearch    " highlight matches


set ignorecase  " case insensitive search
set smartcase

set backspace=indent,eol,start  " allow backspacing over autoindent
set autoindent " when opening a new line, keep the same indent as the previous line, 
               " unless there's filetype specific indentation. i.e. after an
               " open curly brace

set nostartofline   " stop curser from always going to start of line when scrolling down
set ruler   " Display cursor position in status line. Better readability



set laststatus=2 " always display status line, even if there's only 1 window. Can be changed if you want.

set confirm " ask if you wish to save changes to file instead of failing command
set visualbell " get visuals instead of beeping when doing something wrong. I hate beeping.
set t_vb=  " don't visual bell either. Just leave me the fuck alone. Will only work if previous line also exists

set mouse=a " Enable the mouse

set cmdheight=2 " Sets command line height to 2 lines. Almost entirely aesthetic



set modelines=0 " special comments at the end of the file that allow certain settings to only be for this file



" Turn on line numbering. Turn it off with "set nonu" 
if exists('+rnu')
  set rnu
  au InsertEnter * :set nu
  au InsertLeave * :set rnu
  au FocusLost * :set nu
  au FocusGained * :set rnu
else
  set number
endif


set foldenable  " enable folding. i.e. you can minimize your functions
set foldlevelstart=10 " open up to 5 folds when opening file.
set foldmethod=syntax   "tells vim where to fold. Syntax is also an option, as well as some others.

set rtp+=/usr/bin/fzf

""""""""""""""""""""""""" MAPPINGS """""""""""""""""""""""""""""

call plug#begin('~/.vim/bundle')

" Movement
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-unimpaired'
Plug 'yangmillstheory/vim-snipe'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'tpope/vim-projectionist'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"Language Specific
Plug 'tpope/vim-rails'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'yalesov/vim-emblem'
Plug 'kchmck/vim-coffee-script'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-endwise'
Plug 'avdgaag/vim-phoenix'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'wlangstroth/vim-racket'
Plug 'kien/rainbow_parentheses.vim'
Plug 'jpalardy/vim-slime'
Plug 'sheerun/vim-polyglot'
Plug 'jalvesaq/nvim-r'

"Autocomplete/linting
Plug 'Valloric/YouCompleteMe', { 'do': './install.py'}
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
" Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'kristijanhusak/vim-hybrid-material'

"Appearance
Plug 'skielbasa/vim-material-monokai'
Plug 'flazz/vim-colorschemes'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'hzchirs/vim-material'
Plug 'zcodes/vim-colors-basic'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'romainl/flattened'
Plug 'KeitaNakamura/neodark.vim'
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-solarized8'
Plug 'gertjanreynaert/cobalt2-vim-theme'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'mkarmona/colorsbox'
Plug 'edkolev/tmuxline.vim'

"Misc
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'

Plug 'bfredl/nvim-ipy'

" All of your Plugins must be added before the following line
call plug#end()            " required


filetype plugin indent on    

colorscheme material-monokai

:highlight Search guibg=Grey40

let g:easytags_async = 1


nnoremap ;; :s/\v(.)$/\=submatch(1)==';' ? '' : submatch(1).';'<CR> :noh <CR>
nnoremap ,, :s/\v(.)$/\=submatch(1)==',' ? '' : submatch(1).','<CR> :noh <CR>

map Y y$
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

augroup myvimrc
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END"
" Vim Autocompletion Configuration

let g:ycm_global_ycm_extra_conf = '~/.ycm_global_ycm_extra_conf'
let g:ycm_rust_src_path = '/usr/lib/rustlib/src/rust/src/'


nnoremap <leader>b :ls<CR>:b<space>
nnoremap <leader>' :s/"/'/g<CR>
nnoremap <leader>" :s/'/"/g<CR>
nnoremap <leader>l :nohl<CR>

nnoremap <leader>w :w<CR>

" nnoremap <leader>f :find<space> 
" nnoremap <leader>s :sfind<space>
" nnoremap <leader>v :vert sfind<space>
nnoremap <leader>g :grep!<space>


nnoremap <leader>f :Files<CR>

nnoremap <leader>t :ta<space>
nnoremap <leader>tl :tselect<CR>
nnoremap <leader>tn :tn<CR>
nnoremap <leader>tp :tp<CR>
nnoremap <leader>p :pop<CR>

nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

set path+=*/**

nnoremap <leader>dt :diffget //2<CR>
nnoremap <leader>dm :diffget //3<CR>
nnoremap <leader>du :diffupdate<CR>

" Vim snipe mappings. Let's see how this works
"Character
map <leader><leader>F <Plug>(snipe-F)
map <leader><leader>f <Plug>(snipe-f)
map <leader><leader>T <Plug>(snipe-T)
map <leader><leader>t <Plug>(snipe-t)

" Word
map <leader><leader>w <Plug>(snipe-w)
map <leader><leader>W <Plug>(snipe-W)
map <leader><leader>e <Plug>(snipe-e)
map <leader><leader>E <Plug>(snipe-E)
map <leader><leader>b <Plug>(snipe-b)
map <leader><leader>B <Plug>(snipe-B)
map <leader><leader>ge <Plug>(snipe-ge)
map <leader><leader>gE <Plug>(snipe-gE)

autocmd FileType ruby compiler ruby

au FileType ruby setl sw=2 sts=2 et
au FileType c setl sw=4 sts=4 et

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

map <C-n> :NERDTreeToggle<CR>
let g:DevIconsEnableFolderPatternMatching = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:NERDSpaceDelims = 1


set diffopt+=vertical

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=racket
  au filetype racket set lisp
  au filetype racket set autoindent
endif


if exists('$TMUX') 

  let g:slime_target = "tmux"
  let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.1"}
endif


au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


let g:ale_completion_enabled = 1
let g:airline#extensions#ale#enabled = 1



let g:ycm_autoclose_preview_window_after_completion=1
map <leader>[  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<s-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


let g:closetag_filenames = '*.html.eex, *.html.erb, *.html,*.xhtml,*.phtml'


nmap <silent> <leader>] <Plug>(ale_next_wrap)

let g:ale_cpp_gcc_options = "-std=c++11 -Wall"
let g:ale_cpp_clang_options = "-std=c++11 -Wall"
let g:ale_cpp_clangcheck_options = "-std=c++11 -Wall"
let g:ale_cpp_clangtidy_options = "-std=c++11 -Wall"
let g:ale_cpp_cppcheck_options = "-std=c++11 -Wall"
let g:ale_cpp_cpplink_options = "-std=c++11 -Wall"
let g:ale_c_clangformat_options = "-std=c++11 -Wall"

let g:ale_cpp_gcc_executable = "g++"

let g:ycm_confirm_extra_conf = 0

let g:nvim_ipy_perform_mappings = 0

map <silent> <c-s> <Plug>(IPy-Run)
map <silent> <c-d> <Plug>(IPy-RunCell)
