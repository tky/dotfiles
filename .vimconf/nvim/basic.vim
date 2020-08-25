inoremap jk <esc>

set nowrap
set nobackup
set noswapfile
set number
set autoindent
set expandtab
set splitright
set clipboard=unnamed
set hls


" windowsのサイズ変更
noremap <C-j> 5<C-w>-
noremap <C-k> 5<C-w>+
noremap <C-h> 5<C-w><
noremap <C-l> 5<C-w>>

" ywで単語のどこにいても全単語をヤンクできる。
noremap <silent>yw yiw

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> <C-t>'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> <C-t>c :tablast <bar> tabnew<CR>

autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=javascript
