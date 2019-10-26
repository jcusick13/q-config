
" --- vim-plug packages---
"
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" Vim Notes
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" Colorschemes
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'tomasr/molokai'
Plug 'dracula/vim', {'as': 'dracula'}

" Airline and Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Assist with auto-indent w.r.t line continuations
Plug 'vim-scripts/indentpython.vim'

" Add file tree
Plug 'scrooloose/nerdtree'

" Flake8 syntax checker
Plug 'nvie/vim-flake8'

" Code autocompleter
Plug 'davidhalter/jedi-vim'

" Python syntax highlighting
Plug 'vim-python/python-syntax'

" Vimtex
Plug 'lervag/vimtex'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"
" --- Color Schemes ---
"
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme dracula
let g:airline_theme='dracula'


"
" --- Python specific ---
"

" PEP-8 support
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=99 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=99

" Ensure UTF-8
set encoding=utf-8

" Invoke Flake8 checking with 'f8', autorun on write
autocmd FileType python map <buffer> f8 :call Flake8()<CR>
autocmd BufWritePost *.py call Flake8()
let g:flake8_show_in_gutter=1
let g:flake8_show_quickfix=1
let g:flake8_max_markers=100
let g:flake8_complexity_marker=''
let g:flake8_error_marker='EE'
let g:flake8_warning_marker='WW'

" Enable highlighting
let g:python_highlight_all=1

" Disable Jedi autocomplete
let g:jedi#completions_enabled=0


"
" --- Vim-notes speficic ---
"

" Necessary for vim-notes to function properly
filetype plugin on

let g:notes_suffix='.txt'
let g:notes_directories=['~/Documents/notebook']


"
" --- General text editor utilities ---
"

" Turn on line numbering on the side of screen
set nu

" Map NERDTree (file table of contents tree) toggle to 'toc'
map toc :NERDTreeToggle<CR>
" Ignore .pyc files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']

"Navigate across windows/split panes (Crtl-vim motion cmd)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Default new splits to either below or right of existing
set splitbelow
set splitright
