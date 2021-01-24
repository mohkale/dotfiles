""""""""""""""""""""""""""""""""""""
"            leader keys           "
""""""""""""""""""""""""""""""""""""

let mapleader       = ' '
let maplocalleader  = '<leader>m'
let g:which_key_map = {}

nnoremap <silent><leader> :WhichKey '<Space>'<cr>
nnoremap <leader>am :Man<Space>
nnoremap <leader>bk :Bclose<cr>
nnoremap <leader>ss :Lines<cr>
nnoremap <leader>tl :set wrap!<cr>
nnoremap <leader>tn :set relativenumber! number!<cr>
nnoremap <leader>sc :nohlsearch<cr>
nnoremap <leader>ff :edit<Space>
nnoremap <leader>jd :edit .<cr>
nnoremap <leader>xd gu
nnoremap <leader>xu gU
nnoremap <leader>xc gc

" Manipulate This Configuration File
nnoremap <leader>fet :tabedit ~/.config/vim/vimrc<cr>
nnoremap <leader>fec :edit ~/.config/vim/vimrc<cr>
nnoremap <leader>fer :source ~/.config/vim/vimrc<cr>
nnoremap <leader>bb  :Buffers<cr>
nnoremap <leader>fa  :Files<cr>
nnoremap <leader>fr  :History<cr>
nnoremap <leader>ss  :BLines<cr>
nnoremap <leader>sa  :Lines<cr>
nnoremap <leader>rm  :Marks<cr>
nnoremap <leader>ww  :Windows<cr>

nnoremap <leader>xt  :silent %s/[[:space:]]\+$//e<cr>

" Easymotions
map  <Leader>jj <Plug>(easymotion-overwin-f)
map  <Leader>jJ <Plug>(easymotion-overwin-f2)
map  <Leader>jhl <Plug>(easymotion-lineforward)
map  <Leader>jhj <Plug>(easymotion-j)
map  <Leader>jhk <Plug>(easymotion-k)
map  <Leader>jhh <Plug>(easymotion-linebackward)
map  <Leader>jhw <Plug>(easymotion-overwin-w)
map  <Leader>jn <Plug>(easymotion-next)
map  <Leader>jp <Plug>(easymotion-prev)
map  <Leader>js <Plug>(easymotion-sn)


""""""""""""""""""""""""""""""""""""
"         leader prefixes          "
""""""""""""""""""""""""""""""""""""
let g:which_key_map.f   = { 'name' : '+files' }
" don't ask... emacs has made me used to fe
let g:which_key_map.f.e = { 'name' : '+vim' }

let g:which_key_map.c = { 'name' : '+compile/comments' }
let g:which_key_map.b = { 'name' : '+buffers' }

call which_key#register('<Space>', 'g:which_key_map')
