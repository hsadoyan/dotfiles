let mapleader = ","

"============================================================================
" CORE SETTINGS
"============================================================================

set background=dark
set termguicolors
set textwidth=120
set linebreak                   " Wrap at word boundaries

" Indentation - using spaces, 2-wide
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" Line numbers - hybrid relative/absolute
set number
set relativenumber
augroup numbertoggle
  autocmd!
  autocmd InsertEnter,FocusLost * setlocal norelativenumber
  autocmd InsertLeave,FocusGained * setlocal relativenumber
augroup END

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" UI
set showcmd                     " Show partial command in bottom bar
set showmatch                   " Highlight matching brackets
set wildmenu                    " Command-line completion
set wildmode=longest:full,full  " Better completion behavior
set wildignore+=*/node_modules/*,*/vendor/*,*/.git/*,*.o,*.pyc
set laststatus=2                " Always show statusline
set signcolumn=yes              " Prevent gutter from jumping
set scrolloff=5                 " Keep 5 lines visible above/below cursor
set sidescrolloff=5
set ruler
set confirm                     " Ask to save instead of failing
set mouse=a

" Behavior
set hidden                      " Allow switching buffers without saving
set backspace=indent,eol,start
set nostartofline               " Don't jump to start of line when scrolling
set splitright                  " Open vertical splits to the right
set splitbelow                  " Open horizontal splits below
set updatetime=250              " Faster CursorHold (better for coc, gitgutter)

" Disable bells completely
set belloff=all

" Persistent undo (survives closing vim)
set undofile
if !has('nvim')
  set undodir=~/.vim/undo
  silent! call mkdir(&undodir, 'p')
endif

" No swap/backup (git handles this)
set nobackup
set nowritebackup
set noswapfile

" Better diff
set diffopt+=vertical,algorithm:patience

" Use ripgrep if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" Auto-open quickfix after grep
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

"============================================================================
" PLUGINS
"============================================================================

call plug#begin('~/.vim/bundle')

" Navigation & Movement
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'yangmillstheory/vim-snipe'

" Autocomplete & LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Appearance
Plug 'Rigellute/rigel'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" Utilities
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat'         " Make . work with plugin maps

" Language
Plug 'elixir-editors/vim-elixir'

call plug#end()

colorscheme rigel

"============================================================================
" KEYMAPS
"============================================================================

" Make Y behave like D and C (yank to end of line)
nnoremap Y y$

" Clear search highlight
nnoremap <leader>l :nohlsearch<CR>

" Quick buffer switching
nnoremap <leader>b :ls<CR>:b<space>

" Toggle semicolon/comma at end of line
nnoremap ;; :s/\v(.)$/\=submatch(1)==';' ? '' : submatch(1).';'<CR>:noh<CR>
nnoremap ,, :s/\v(.)$/\=submatch(1)==',' ? '' : submatch(1).','<CR>:noh<CR>

" Quote toggling
nnoremap <leader>' :s/"/'/g<CR>:noh<CR>
nnoremap <leader>" :s/'/"/g<CR>:noh<CR>

" --- FZF ---
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles?<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>G :grep!<space>
nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>T :BTags<CR>

" FZF completion
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file)

" Custom ripgrep command (fixed strings, case insensitive)
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color=always -- '.shellescape(<q-args>),
  \   fzf#vim#with_preview(), <bang>0)

" --- NERDTree ---
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDSpaceDelims = 1
let g:DevIconsEnableFolderPatternMatching = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" --- vim-snipe ---
map f <Plug>(snipe-f)
map F <Plug>(snipe-F)
map t <Plug>(snipe-t)
map T <Plug>(snipe-T)

map <leader><leader>w <Plug>(snipe-w)
map <leader><leader>W <Plug>(snipe-W)
map <leader><leader>e <Plug>(snipe-e)
map <leader><leader>E <Plug>(snipe-E)
map <leader><leader>b <Plug>(snipe-b)
map <leader><leader>B <Plug>(snipe-B)
map <leader><leader>ge <Plug>(snipe-ge)
map <leader><leader>gE <Plug>(snipe-gE)

" --- Git (fugitive) ---
nnoremap <leader>gb :.GBrowse<CR>
vnoremap <leader>gb :GBrowse<CR>

" Diff helpers (for merge conflicts)
nnoremap <leader>dt :diffget //2<CR>
nnoremap <leader>dm :diffget //3<CR>
nnoremap <leader>du :diffupdate<CR>

"============================================================================
" COC.NVIM CONFIGURATION
"============================================================================

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Refactoring
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>ll <Plug>(coc-codelens-action)

" Use <CR> to confirm completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" Use K to show documentation
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

"============================================================================
" FILETYPE SETTINGS
"============================================================================

augroup filetypes
  autocmd!
  autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType make setlocal noexpandtab
augroup END
