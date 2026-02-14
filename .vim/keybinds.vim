let mapleader = " "
let maplocalleader = " m"

" Open netrw with <leader>fd
nnoremap <silent> <leader>fd :Ex<cr>

" Save file
nnoremap <silent> <leader>fs :update<cr>

" More natural movement across long wrapped lines
nnoremap <silent> j gj
vnoremap <silent> j gj
nnoremap <silent> k gk
vnoremap <silent> k gk

" Better indent and dedent in visual
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" fd = esc in insert and visual
inoremap <silent> fd <esc>
vnoremap <silent> fd <esc>

" Emacs like faster moves
inoremap <silent> <m-b> <c-left>
inoremap <silent> <m-f> <c-right>
inoremap <silent> <c-b> <left>
inoremap <silent> <c-f> <right>

nnoremap <silent> <leader>w <c-w>
" Delete window
nnoremap <silent> <c-w>x :<c-u>bdel<cr>
nnoremap <silent> <leader>wx :<c-u>bdel<cr>

" Copy Absolute Path
nnoremap <silent> <leader>fyy :<c-u>let @+=expand("%:p")<cr>

" Copy Directory Path
nnoremap <silent> <leader>fyd :<c-u>let @+=expand("%:p:h")<cr>

" Copy File Name
nnoremap <silent> <leader>fyn :<c-u>let @+=expand("%:t")<cr>

" Copy Relative File Name
nnoremap <silent> <leader>fyr :<c-u>let @+=expand("%")<cr>

" Delete Buffer
nnoremap <silent> <leader>bd :<c-u>bprev<cr>:bdel #<cr>

" Previous Buffer
nnoremap <silent> <leader>bp :<c-u>bprev<cr>
nnoremap <silent> <leader>b[ :<c-u>bprev<cr>

" Next Buffer
nnoremap <silent> <leader>bn :<c-u>bnext<cr>
nnoremap <silent> <leader>b] :<c-u>bnext<cr>

" Clear search
nnoremap <silent> <leader>sc :nohl<cr>