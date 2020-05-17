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
Plug 'tomasr/molokai'
Plug 'dracula/vim', {'as': 'dracula'}

" Airline and Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Assist with auto-indent w.r.t line continuations
Plug 'vim-scripts/indentpython.vim'

" Add file tree
Plug 'scrooloose/nerdtree'

" Syntax checker
Plug 'vim-syntastic/syntastic'

" Python syntax highlighting
Plug 'vim-python/python-syntax'

" Python code formatter
Plug 'psf/black'

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
    \ set colorcolumn=88

" Ensure UTF-8
scriptencoding utf-8
set encoding=utf-8

" Run Black on save
" Provide option to bypass Black when buffer variable `b:noEditBlack` is set
let g:black_virtualenv="~/.vim_black"
fun! Blacken()
	if exists('b:noEditBlack')
		return
	endif
	let g:black_skip_string_normalization=1
	execute ':Black'
endfun
autocmd BufWritePre *.py call Blacken()


" Establish pylint as linter
let g:syntastic_python_checkers = ['pylint']

" Define warning labels for Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Synstatic settings also recorded in
" ~/.vim/after/plugin/syntastic.vim to avoid getting
" clobbered by later plugins
"
" Only check on explict call to :SyntasticCheck
let g:syntastic_mode_map = {'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': []}
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_wq = 0

" Map command for write and syntax check (normal mode only)
nnoremap :wc :w <bar> :SyntasticCheck

" Enable highlighting
let g:python_highlight_all=1


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

" Show all spaces as a center dot, and dashes for tabs.
" Ignoring $ for EOL (and any EOL char)
set list
set listchars=space:·,tab:>-
