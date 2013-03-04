set nocompatible               " be iMproved
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'git://github.com/mattn/zencoding-vim.git'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'git://github.com/Sixeight/unite-grep.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
" Ctrl-P Ctrl-N
NeoBundle 'YankRing.vim'
"  これをしないとYankRingがエラーを起こす。
let g:yankring_manual_clipboard_check = 0

" \ig
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

NeoBundle 'thinca/vim-quickrun'

filetype plugin indent on     " required!
filetype indent on
syntax on

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
highlight CursorLine ctermbg=grey guibg=grey


"neocomplcacheを起動時に有効にする
let g:neocomplcache_enable_at_startup = 1
" 保管候補の一番先頭を選択状態にする
let g:neocomplcache_enable_auto_select = 1
" CamelCase保管
let g:neocomplcache_enable_camel_case_completion = 1
" Underbar保管
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'java' : '~/.vim/dict/java.dict'
  \ }


let g:unite_source_file_ignore_pattern='target/.*'
" insert modeで開始
let g:unite_enable_start_insert=1
" 縦分割で開く
"let g:unite_enable_split_vertically = 1
" let g:unite_winwidth = 40

let g:unite_source_grep_default_opts = '-iRHn'

" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
noremap <silent>:un :Unite -buffer-name=file file<CR>
" 最近使ったファイル一覧
noremap <C-Z> :Unite file_mru<CR>
noremap <silent>:uz :Unite file_mru<CR>

nnoremap <silent>:ug :Unite grep:%:-iHRn<CR>

" ブックマーク
noremap <silent>:uf :Unite bookmark<CR>

"現在開いているファイルのディレクトリ下のファイル一覧。
"開いていない場合はカレントディレクトリ
nnoremap <silent> :ul :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"バッファ一覧
nnoremap <silent> :ub :<C-u>Unite buffer<CR>
"レジスタ一覧
nnoremap <silent> :ur :<C-u>Unite -buffer-name=register register<CR>

"タグブラウジング
noremap <silent>:ut :Unite tag<CR>
" snippetのブラウジング
noremap <silent>:us :Unite snippet<CR>
    
" escape２回で終了
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" Ctrl + J ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" " Ctrl + k ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" %コマンドのジャンプを拡張 divとかも飛べるようになる。
:runtime macros/matchit.vim

let g:vimfiler_safe_mode_by_default = 0
"colorscheme desert
" colorscheme slate

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
 
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neosnippet.git'

let g:neosnippet#snippets_directory='~/.vim/snippets/'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

"neocomplcacheのマッピング
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
noremap :es :<C-u>NeoComplCacheEditSnippets<CR>

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
set conceallevel=2 concealcursor=i
endif

" :eでvimfilerをいいかんじで開く
noremap <silent>:e :VimFiler -split -simple -winwidth=35 -no-quit<CR>

" 起動<c-p>
" vsplit open <c-v>
" split open <c-x>
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore = { "file": ".*target\/.*$" }
let g:ctrlp_working_path_mode = 'ra'

set number
set nowrap
set backupdir=/tmp/vim/backup
set directory=/tmp/vim/swp

" for javascript
NeoBundle 'JavaScript-syntax'
NeoBundle 'pangloss/vim-javascript'

"gxでブラウザ起動。なぜもっと早く気がつかなかった。。
NeoBundle 'open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

NeoBundle 'tell-k/vim-browsereload-mac'

noremap <C-j> <C-w>-
noremap <C-k> <C-w>+
noremap <C-h> <C-w><
noremap <C-l> <C-w>>

set tabstop=2
set expandtab
set shiftwidth=2

NeoBundle 'fuenor/qfixgrep.git'
