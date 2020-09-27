" # Some guidance before jumping in
" ## The Help Reference Manual (main help file)
" Access the vim help system with `:help`
" note that the first page has instructions for navigating around the help
"   press `ctrl-]` to follow a link
"   press `ctrl-o` to return to a previous location
"   press `/` and then text and enter to search for a specific word
"
" But don't actually read through the help yet - just know that it is there
" because the help is more like a reference manual than a guide, so you should
" know the basics of vim first.
"
" ## The User Manual
" To learn your way around vim, read the user manual with `:help user-manual`
"
" # VIMRC
" This is a .vimrc file, which is the main configuration file for vim (and
" neovim), but it is not always called '.vimrc'. Use `:help vimrc` to learn
" the details about it and where it should be located in your filesystem.
"
" As you can tell by now, the " character precedes comments.
"
" To get additional help on anything in this file, use the help system, but
" for anything that follows a 'set ' make sure to incude the term in single
" quotes when searching help (ie. to learn more about "smartindent" use `:help
" 'smartindent'`). The single quotes seem to differentiate between config
" variables and commands (in cases where both a config variable and command
" share the same name).
"
" This config was originally developed with fedora 32 and neovim v0.4.3 in
" Sept. 2020.
"
" The first part of this file is not related to any plugins. The second part
" is all plugin specific stuff (starting with the line '')

if has("termguicolors") " true truecolor (insted of 256 color) when available
  set termguicolors
endif

filetype plugin on " detect filetype and load filetype specific plugins
syntax on " use syntax highlighting based on filetype

set hidden " allow hidden buffers with unsaved changes
set noshowmatch " don't jump to matching bracket
set noerrorbells " don't beep on errors
set tabstop=2 softtabstop=2 " number of spaces in a tab
set shiftwidth=2 " how much to outdent/indent with < and >
set expandtab " use spaces instead of tabs in insert mode
set smartindent " do some smart indenting
set number " show line numbers
set nowrap " don't wrap lines
set smartcase " ignare case for searches unless there is a capital in the search text
set noswapfile " don't save swap files (not needed when undofile is used)
set nobackup " don't automatically save backup files on save (not needed when undofile is used)
set incsearch " when searching show pattern matches while typing search term
set scrolloff=8 " when scrolling always show this min number of lines above or below the current line
set colorcolumn=120 " draw a vertical line to show this column position
" set viminfo='50 " (alias to shada in neovim) save editor metadata for last 50 files edited
set list " show trailing spaces
set laststatus=2 " always show a status line
set splitbelow " open horizontal splits below current window
set splitright " open vertical splits to the right of the current window
set encoding=utf-8 " use utf-8 encodings (required according to YCM docs)

if !isdirectory($HOME . "/.vim/undodir") " create undodir if it does not exist
  call mkdir($HOME . "/.vim/undodir", "p")
endif
set undofile " use undofiles (so set noswapfile and set nobackup)
set undodir=~/.vim/undodir " location for undofiles

let g:clipboard = "xsel"

set cursorline " highlight the line the cursor is on
au WinEnter * setlocal cursorline " turn on cursorline for active window
au WinLeave * setlocal nocursorline " turn off cursorline for inactive window

" " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
" set updatetime=2000

let mapleader = ' ' " change leader to space for convienence

" press leader twice to turn of search highlighting
nnoremap <leader><leader> :noh<cr>

" some bindings to edit this config
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" set up better tab completion for opening new files
set wildmode=longest,list,full
set wildmenu

" remap home keys to Dvarak
noremap h h
noremap t j
noremap n k
noremap s l

" map capital letters for searching (since n is in dvorak homerow)
noremap T n
noremap N N

" to move between tabs
noremap H :tabp<CR>
noremap S :tabn<CR>

" map control-homerow to move between windows
noremap <leader>h <C-W><C-H>
noremap <leader>t <C-W><C-J>
noremap <leader>n <C-W><C-K>
noremap <leader>s <C-W><C-L>

" maximize current window
nnoremap <C-W>m <C-W>_<C-W><Bar>

augroup javascript_local
    au!
    au FileType javascript setlocal foldmethod=indent
    au FileType javascript IndentLinesEnable
augroup END

function MarkdownLocalSetup()
  setlocal spell spelllang=en_us
  setlocal wrap linebreak nolist
  Goyo
  noremap t gj
  noremap n gk
endfunction
augroup markdown_local
  au!
  au FileType markdown call MarkdownLocalSetup()
augroup END

" Everything below here is related to plugins (using
" https://github.com/junegunn/vim-plug plugin manager).
"
" Each plugin is hosted at 'https://github.com/<plugin>' where <plugin> is the
" part in single quotes in each line below that starts with 'Plug '.
"
" You can read some documentation in the readme file on the github site, but
" the real documentation is incorporated into the vim help system.
"
" So for instance, to learn more about the 'mbbill/undotree' plugin type
" `:help undotr` and then hit the TAB key to see all of possible completions
" in the help system for undotree. After looking at the possible completions,
" it is obvious that a good place to start is `:help undotree-intro`, and then
" go from there.

" if empty(glob('~/.vim/autoload/plug.vim')) " auto install vim-plug if not already installed
if empty(glob('`ls "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim`')) " auto install vim-plug if not already installed
  silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary' " comment/uncomment easily (visual select and type gc to toggle comments)
Plug 'tpope/vim-surround' " easily change/add/remove matching brackets and quotes
Plug 'tpope/vim-fugitive' " git integration (to get some git info in the status bar, but it also does other stuff)
Plug 'jkramer/vim-narrow' " select subset of file to edit
" Plug 'prettier/vim-prettier', { 'do': 'yarn install' } " code formatting
" Plug 'tpope/vim-unimpaired' " some shortcuts for jumping around

Plug 'morhetz/gruvbox' " gruvbox color scheme
autocmd vimenter * colorscheme gruvbox

Plug 'mbbill/undotree' " show fine grained undo list in a side panel
nnoremap <leader>u :UndotreeShow<CR>

Plug 'junegunn/goyo.vim' " distraction free editing (I use it when editing markdown)
nnoremap <leader>z :Goyo<cr>

Plug 'vim-airline/vim-airline' " decorate status bar (including showing git branch)
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

Plug 'Yggdroot/indentLine' " show vertical indentation lines
let g:indentLine_color_term = 'black'
let g:indentLine_char_list = ['|']
" let g:indentLine_enabled = 0 " off by default

Plug 'easymotion/vim-easymotion' " jump cursor to arbitrary position on the visible screen
let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_smartcase = 1 " case sensitive only when target is uppercase
map <leader>- <Plug>(easymotion-bd-f)
map <leader>l <Plug>(easymotion-bd-jk)

Plug 'sheerun/vim-polyglot' " syntax highlighting for lots of languages
let g:vim_markdown_conceal_code_blocks = 0 " don't hide markdown code block control characters (ie. ```)
let g:vim_markdown_conceal = 0 " don't hide other markdown control characters (ie. * and _)

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " fuzzy searcher (for finding files)
nnoremap <leader>G :GFiles<CR>
nnoremap <leader>R :Files<CR>
let g:fzf_buffers_jump = 1 " [Buffers] Jump to the existing window if possible
let g:fzf_commands_expect = 'alt-enter,ctrl-x' " [Commands] --expect expression for directly executing the command

Plug 'ycm-core/YouCompleteMe', { 'dir': '~/.vim/plugged/YouCompleteMe', 'do': 'python3 install.py --all' } " autocompletion, refactoring, and jumping to references
" requires python3, python3-devel, cmake
" requires manual install step:
" `cd ~/.vim/plugged/YouCompleteMe && python3 install.py --all`
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <silent> <leader>rr :YcmCompleter RefactorRename<space>

Plug 'neomake/neomake'
let g:neomake_javascript_enabled_makers = ['standard'] " use linter from https://standardjs.com/ for javascript
autocmd! BufWritePost,BufEnter * Neomake " lint files when opening and saving

call plug#end()
