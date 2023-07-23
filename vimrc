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
set expandtab   "turn <TAB> into 2 spaces
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



" Turn on relative line numbering
if exists('+rnu')
  set rnu
  au InsertEnter * :set nu
  au InsertLeave * :set rnu
  au FocusLost * :set nu
  au FocusGained * :set rnu
else
  set number
endif

set rtp+=/usr/local/bin/fzf

""""""""""""""""""""""""" MAPPINGS """""""""""""""""""""""""""""

call plug#begin('~/.vim/bundle')

" Movement
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'yangmillstheory/vim-snipe'
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-easytags'

"Language Specific
"Plug 'tpope/vim-rails'
"Plug 'vim-ruby/vim-ruby'
" Plug 'leafgarland/typescript-vim'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
" Plug 'Quramy/tsuquyomi'
" Plug 'rust-lang/rust.vim'
" Plug 'racer-rust/vim-racer'
" Plug 'yalesov/vim-emblem'
" Plug 'kchmck/vim-coffee-script'
" Plug 'elixir-lang/vim-elixir'
"Plug 'tpope/vim-endwise'
" Plug 'avdgaag/vim-phoenix'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'wlangstroth/vim-racket'
" Plug 'kien/rainbow_parentheses.vim'
" Plug 'jpalardy/vim-slime'
" Plug 'sheerun/vim-polyglot'
" Plug 'jalvesaq/nvim-r'
" Plug 'fatih/vim-go'
" Plug 'sebdah/vim-delve'

"Autocomplete/linting
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py'}
"" Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-snippets'

" Track the engine.
" Plug 'SirVer/ultisnips', { 'on': 'InsertEnter' }
" Snippets are separated from the engine. Add this if you want them:
" Plug 'honza/vim-snippets'

"Plug 'neomake/neomake'
" Plug 'dense-analysis/ale'
"Plug 'jiangmiao/auto-pairs'
"Plug 'alvan/vim-closetag'

"Appearance
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

"Plug 'kristijanhusak/vim-hybrid-material'
"Plug 'skielbasa/vim-material-monokai'
"Plug 'flazz/vim-colorschemes'
"Plug 'hzchirs/vim-material'
"Plug 'zcodes/vim-colors-basic'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'lifepillar/vim-solarized8'
"Plug 'kristijanhusak/vim-hybrid-material'
"Plug 'mkarmona/colorsbox'
"Plug 'edkolev/tmuxline.vim'
Plug 'Rigellute/rigel'
"Misc
" Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'

" Plug 'bfredl/nvim-ipy'

" All of your Plugins must be added before the following line
call plug#end()            " required


filetype plugin indent on    

colorscheme rigel
" colorscheme material-monokai




" Toggle ; and , at the end of the line by douple tapping them
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


nnoremap <leader>b :ls<CR>:b<space>
nnoremap <leader>' :s/"/'/g<CR>       
nnoremap <leader>" :s/'/"/g<CR>
nnoremap <leader>l :nohl<CR>


" nnoremap <leader>f :find<space> 
" nnoremap <leader>s :sfind<space>
" nnoremap <leader>v :vert sfind<space>
" Open current line in the browser

nnoremap <Leader>gb :.Gbrowse<CR>

" Open visual selection in the browser
vnoremap <Leader>gb :Gbrowse<CR>


nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles?<CR>

nnoremap <leader>G :grep!<space>
nnoremap <leader>g :Find<CR>

nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :BLines<CR>


nnoremap <leader>t :Tags<CR>
nnoremap <leader>T :BTags<CR>

" nnoremap <leader>te :tabedit<CR>
" nnoremap <leader>t :ta<space>
" nnoremap <leader>tl :tselect<CR>
" nnoremap <leader>tn :tn<CR>
" nnoremap <leader>tp :tp<CR>
" nnoremap <leader>p :pop<CR>


nnoremap <leader>dt :diffget //2<CR>
nnoremap <leader>dm :diffget //3<CR>
nnoremap <leader>du :diffupdate<CR>

" Vim snipe mappings. Let's see how this works
"Character
map F <Plug>(snipe-F)
map f <Plug>(snipe-f)
map T <Plug>(snipe-T)
map t <Plug>(snipe-t)

" Word
map <leader><leader>w <Plug>(snipe-w)
map <leader><leader>W <Plug>(snipe-W)
map <leader><leader>e <Plug>(snipe-e)
map <leader><leader>E <Plug>(snipe-E)
map <leader><leader>b <Plug>(snipe-b)
map <leader><leader>B <Plug>(snipe-B)
map <leader><leader>ge <Plug>(snipe-ge)
map <leader><leader>gE <Plug>(snipe-gE)

" autocmd FileType ruby compiler ruby

au FileType ruby setl sw=2 sts=2 et

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
" let g:NERDTreeHijackNetrw=0

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>ll  <Plug>(coc-codelens-action)


inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

let g:DevIconsEnableFolderPatternMatching = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:NERDSpaceDelims = 1


set diffopt+=vertical



" if exists('$TMUX') 

  " let g:slime_target = "tmux"
  " let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.1"}
" endif


" au VimEnter * RainbowParenthesesToggle
" au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces



"let g:closetag_filenames = '*.html.eex, *.html.erb, *.html,*.xhtml,*.phtml'





let g:go_doc_popup_window = 1


let g:go_fmt_command = "goimports"
let g:go_def_mode = "gopls"
let g:go_autodetect_gopath = 1

let g:go_fmt_autosave = 1

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1


au FileType go nmap gl :GoDeclsDir<cr>


" When writing a buffer (no delay).
" call neomake#configure#automake('w')

set nobackup
set nowritebackup

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


map <c-x><c-j> <plug>(fzf-complete-file)
imap <c-x><c-f> <plug>(fzf-complete-path)
" inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')

