"
" --- General settings ---
"

" Don't force compatibility with older ex, vi, etc
set nocompatible

" Enable syntax and plugins (for netrw)
syntax enable
filetype plugin on

" Set tab complete to bash-like behavior
"   1st tab completes to longest common prefix,
"   2nd-Nth tab cycles through matches
set wildmode=longest,list

" Set searches to be case-sensitive by default
set noignorecase

" Case-insensitive searches will use the case
"   of the matched word from the buffer
set noinfercase

filetype indent on

" Turn on line numbering
set nu

" Ensure UTF-8
scriptencoding utf-8
set encoding=utf-8

" Default new splits to either below or right of existing
set splitbelow
set splitright

" Enable mouse scrolling
set mouse=a

" Always show file name in status bar,
"   even when just one file open
set laststatus=2

" Display file name, percent through file, curr line/col
set statusline=%{expand('%:~:.')}%m\ %=%P\ %l,%c

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Remove trailing whitespace right before saving
"   and maintain current cursor position
autocmd BufWritePre * let save_cursor = getpos(".") | %s/\s\+$//e | call setpos('.', save_cursor)


"
" --- C++ settings ---
"

au BufNewFile,BufRead *.c,*.cc,*.h,*.hh
    \ set tabstop=4 |		" tabs set to 4 spaces
    \ set softtabstop=4 |	" visual tabs to 4 spaces
    \ set shiftwidth=4 |	" shift commands to 4 spaces
    \ set textwidth=99 |	" max width before forced new line
    \ set expandtab |		" convert tabs to spaces
    \ set autoindent |		" copy indentation level from prev line
    \ set fileformat=unix |	" use unix line endings (LF)
    \ set colorcolumn=88	" display ruler

"
" --- Python settings ---
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

