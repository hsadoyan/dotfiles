" Use <F11> to toggle between 'paste' and 'nopaste'
" When in 'paste' mode, you can paste from the regular clipborad with "+p
" Yes, all three characters are needed to paste. Working on a way to make this
" faster.
" Remember to turn paste  off after. Leaving paste open permanently can fuck shit
" up
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

set lazyredraw  " redraw only when you have to. Can make things faster.

set showmatch   " fucking great one. Highlights matching parenthases. 

set incsearch   " search as characters are entered
set hlsearch    " highlight matches

"map Ctrl-L in command mode to turn off highlighting after search.
nnoremap <C-L> :nohl<CR><C-L> 

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
set foldmethod=indent   "tells vim where to fold. Syntax is also an option, as well as some others.


""""""""""""""""""""""""" MAPPINGS """""""""""""""""""""""""""""

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-rails'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rust-lang/rust.vim'
" Plugin 'scrooloose/nerdtree'
Plugin 'vim-syntastic/syntastic'
Plugin 'tyrannicaltoucan/vim-quantum'
Plugin 'hzchirs/vim-material'
Plugin 'zcodes/vim-colors-basic'
 10 " Vim Autocompletion Configuration

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" Pathogen is a great way to intall vim plugins. Requires it to be installed,
" but you should do that anyway. 
" execute pathogen#infect() 

colorscheme vim-material


"set hidden
""let g:racer_cmd = "/usr/local/bin/racer"
"let $RUST_SRC_PATH="~/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
""let g:racer_experimental_completer = 1

" set t_Co=256
nnoremap ;; :s/\v(.)$/\=submatch(1)==';' ? '' : submatch(1).';'<CR> :noh <CR>

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
let g:ycm_rust_src_path = '/home/ftlc/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'


nnoremap <leader>b :ls<CR>:b<space>

nnoremap <leader>w :w<CR>

nnoremap <leader>f :find<space>
nnoremap <leader>s :sfind<space>
nnoremap <leader>v :vert sfind<space>
nnoremap <leader>g :grep<space>


nnoremap <leader>F :find <C-R>=expand('%:h').'/*'<CR>
nnoremap <leader>S :sfind <C-R>=expand('%:h').'/*'<CR>
nnoremap <leader>V :vert sfind <C-R>=expand('%:h').'/*'<CR>

nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

set path+=~/work/Minimoserver/app/services/slack_service_states/
set path+=~/work/Minimoserver/spec/services

autocmd FileType ruby compiler ruby
