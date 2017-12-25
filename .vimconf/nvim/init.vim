" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" {{{ dein
let s:dein_dir = expand('$DATA/dein')

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    execute 'set runtimepath^=' . s:dein_repo_dir
endif


" dein.vim settings

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let s:toml_dir = expand('$CONFIG/dein')

    call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/lightline.toml', {'lazy': 1})
    call dein#load_toml(s:toml_dir . '/watchdog.toml', {'lazy': 1})
    call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
" }}}
"
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

colorscheme desert

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> <C-t>'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> <C-t>c :tablast <bar> tabnew<CR>
inoremap jk <esc>
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

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! s:grep_visual_selection() 
  let a:word = s:get_visual_selection()
  execute "CtrlSF" . "'" . a:word . "'"
endfunction
command! -nargs=0 GrepSelection call s:grep_visual_selection()
vnoremap <C-f> <ESC>:GrepSelection<CR>

function! s:grep_functions()
  let a:word = expand("<cword>")
  if (&filetype == "java")
    execute "CtrlSF" . "'" . a:word . "'"
  elseif (&filetype == "ruby")
     execute "CtrlSF -R " . "'(def |def self.) " . a:word . "'"
  elseif (&filetype =="php")
     execute "CtrlSF -R " . "'(function) " . a:word . "'"
  else
     execute "CtrlSF -R " . "'(def |val ) " . a:word . "'"
  end
endfunction
command! -nargs=0 GrepFunctions call s:grep_functions()
nnoremap k* :GrepFunctions<CR>

function! s:grep_classes()
  let a:word = expand("<cword>")
  execute "CtrlSF -R " . "'(class|module) " . a:word . "'"
endfunction
command! -nargs=0 GrepClasses call s:grep_classes()

function! s:grep_all_definitions()
  let a:word = expand("<cword>")
  let a:is_lower = match(a:word[0],'\U')!=-1
  if a:is_lower
    call s:grep_functions()
  else
    call s:grep_classes()
  end
endfunction
command! -nargs=0 GrepAllDefinitions call s:grep_all_definitions()
nnoremap <Space>* :GrepAllDefinitions<CR>

function! s:grep_current_file()
  let a:file = expand("%:t:r")
  call ctrlsf#Search(a:file)
endfunction
command! -nargs=0 GrepCurrentFile call s:grep_current_file()
nnoremap f* :GrepCurrentFile<CR>

nmap g* :CtrlSF<CR>

" for termainal
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jk <C-\><C-n>
