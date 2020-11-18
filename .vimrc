scriptencoding utf-8

inoremap jk <esc>
set vb t_vb= " ビープ音を鳴らさない
set number
set nowrap
set nobackup
set noswapfile
set expandtab
autocmd FileType go set noexpandtab
set clipboard=unnamed
set t_Co=256
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,ucs-bom,default,latin1
set autoread
syntax on

" %コマンドのジャンプを拡張
:source $VIMRUNTIME/macros/matchit.vim
:let b:match_words='\<if\>:\<endif\>,(:),{:},[:],\<begin\>:\<end\>'
:let b:match_ignorecase = 1

"  カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
:hi clear CursorLine
:hi CursorLine gui=underline
"highlight CursorLine ctermbg=glay guibg=glay

" ywで単語のどこにいても全単語をヤンクできる。
noremap <silent>yw yiw

" ヤンクした文字列をcyで置換
nnoremap <silent> cy ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
vnoremap <silent> cy c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

" コマンド履歴を開く
nnoremap <F5> <Esc>q:
" 検索履歴を開く
nnoremap <F6> <Esc>q/

" ステータスラインにファイル名を常に表示
:set laststatus=2 

"現バッファの差分表示。
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" windowsのサイズ変更
noremap <C-j> 5<C-w>-
noremap <C-k> 5<C-w>+
noremap <C-h> 5<C-w><
noremap <C-l> 5<C-w>>

" 最後に編集された位置に移動
nnoremap Gb '[
nnoremap Gp ']

" タグジャンプ & バック
nnoremap <F2> <C-W><C-]>
nnoremap <F3> g<C-]> 
nnoremap <F4> <C-t>

nnoremap <S-LEFT> :bf<CR>
nnoremap <S-RIGHT> :bl<CR>

"インデント設定
source ~/.vimrc.indent
