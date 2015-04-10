scriptencoding utf-8

" release autogroup in MyAutoCmd
"
augroup MyAutoCmd
  autocmd!
augroup END

au BufRead,BufNewFile,BufReadPre *.txt   set filetype=txt
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
au BufRead,BufNewFile,BufReadPre *.rs   set filetype=rust
au BufRead,BufNewFile,BufReadPre *.mustache   set filetype=mustache
au BufRead,BufNewFile,BufReadPre *.hs   set filetype=haskell
au BufRead,BufNewFile,BufReadPre *.erb   set filetype=erb
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html

" 前時代的スクリーンベルを無効化
set vb t_vb= " ビープ音を鳴らさない
set number
set nowrap
set nobackup
set noswapfile
set expandtab
set clipboard=unnamed
set t_Co=256
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,ucs-bom,default,latin1
"set spell
"set spelllang=en,cjk
set autoread
"mkspell! ~/.vim/spell/en.utf-8.add
syntax on

function! s:vim_slide_next()
  let a:file = expand("%:r") + 1
  let a:extension = expand("%:e")
  execute 'open ' . a:file . '.' . a:extension
endfunction
command! -nargs=0 VimSlideNext call s:vim_slide_next()

function! s:vim_slide_prev()
  let a:file = expand("%:r") - 1
  let a:extension = expand("%:e")
  execute 'open ' . a:file . '.' . a:extension
endfunction
command! -nargs=0 VimSlidePrev call s:vim_slide_prev()


function! s:vim_slide_up()
endfunction

function! s:is_single_byte_char(char)
  return match(a:char,'[a-zA-Z0-9!-/:-@¥[-`{-~]')!= -1
endfunction

function! s:move_left_text(string, pos)
  call append(a:pos - 1 ,"")
  let a:index = 0
  let a:length = strlen(a:string)
  while a:index < a:length 
    if (s:is_single_byte_char(a:string[a:length - a:index - 2 : a:length - a:index - 1]) == 0)
      let a:index = a:index + 3
    else
      let a:index = a:index + 1
    endif
    if (a:length - a:index >= 0)
      call setline(a:pos ,a:string[a:length - a:index : a:length])
    else
      :break
    endif
    execute "redraw"
    sleep 900ms
  endwhile
  call setline(a:pos ,a:string)
endfunction
command! -nargs=0 VimLeft call s:move_left_text("あa0いう1aあ(ほ-", 3)
nnoremap <F9> :VimLeft<CR>

function! s:move_up_text(string, pos)
  let a:index = line('$')
  while a:index > a:pos
    let a:prev_line = getline(a:index)
    call setline(a:index, a:string)
    call setline(a:index + 1, a:prev_line)
    let a:index = a:index - 1
    execute "redraw"
    sleep 100ms
  endwhile
endfunction
command! -nargs=0 VimUp call s:move_up_text("aaaaa", 3)

let g:angular_root = 'ok'
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction


function! s:java_version()
  let lines = split(system("java -version"), "\n")
  for l in lines
    if (l =~ "java version")
      if (l =~ "1\.7")
        return "1_7"
        elseif (l =~ "1\.8")
        return "1_8"
      endif
    endif
  endfor
  return ""
endfunction

" Set tabline.
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

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
endif

" gocode
set rtp+=$GOROOT/misc/vim
exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")

if $GOROOT != ''
  set rtp+=$GOROOT/misc/vim
endif
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
    " NeoBundleが存在しない、もしくはVimのバージョンが古い場合はプラグインを一切
    " 読み込まない
    let s:noplugin = 1
else
    " NeoBundleを'runtimepath'に追加し初期化を行う
    if has('vim_starting')
        execute "set runtimepath+=" . s:neobundle_root
    endif
    call neobundle#begin(s:bundle_root)

    " NeoBundle自身をNeoBundleで管理させる
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'dyng/ctrlsf.vim'
    NeoBundle 'rking/ag.vim', {
          \ "build": {
          \ "mac" : "brew install the_silver_searcher"
          \}}
    " 検索結果を閉じない
    let g:ctrlsf_auto_close = 0
    function! s:grep_fiels()
      let a:word = expand("<cword>")
      call ctrlsf#Search(a:word)
    endfunction
    command! -nargs=0 GrepAllFiles call s:grep_fiels()
    "nnoremap <C-g> :GrepAllFiles<CR>
    nnoremap g* :GrepAllFiles<CR>

    NeoBundle 'terryma/vim-multiple-cursors'
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
      call ctrlsf#Search("'" . a:word . "'")
    endfunction
    command! -nargs=0 GrepSelection call s:grep_visual_selection()
    vnoremap <C-f> <ESC>:GrepSelection<CR>

    function! s:grep_functions()
      let a:word = expand("<cword>")
      if (&filetype == "java")
        call ctrlsf#Search("' " . a:word . "'")
      else
        call ctrlsf#Search("'[def|val| |,] " . a:word . "[ (=[:]'")
      end
    endfunction
    command! -nargs=0 GrepFunctions call s:grep_functions()
    "nnoremap f* :GrepFunctions<CR>

    function! s:grep_classes()
      let a:word = expand("<cword>")
      call ctrlsf#Search("'[class|trait|object] " . a:word . "[ |(]'")
    endfunction
    command! -nargs=0 GrepClasses call s:grep_classes()
    "nnoremap c* :GrepClasses<CR>

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

    " 非同期通信を可能にする
    " 'build'が指定されているのでインストール時に自動的に
    " 指定されたコマンドが実行され vimproc がコンパイルされる
    NeoBundle "Shougo/vimproc", {
        \ "build": {
        \   "windows"   : "make -f make_mingw32.mak",
        \   "cygwin"    : "make -f make_cygwin.mak",
        \   "mac"       : "make -f make_mac.mak",
        \   "unix"      : "make -f make_unix.mak",
        \ }}

    NeoBundle 'tpope/vim-repeat'

    NeoBundle "rhysd/unite-codic.vim"
    NeoBundle "tpope/vim-eunuch"

    NeoBundle 'git://github.com/kana/vim-fakeclip.git'

    NeoBundle 'Shougo/vimshell'

    " Insertモードに入るまではneocompleteはロードされない
    NeoBundleLazy 'Shougo/neocomplete.vim', {
        \ "autoload": {"insert": 1}}
    " neocompleteのhooksを取得
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    " neocomplete用の設定関数を定義。下記関数はneocompleteロード時に実行される
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplete#enable_smart_case = 1

        " 補完候補の一番先頭を選択状態にする
        "let g:neocomplcache_enable_auto_select = 1
        " CamelCase補完
        let g:neocomplcache_enable_camel_case_completion = 1
        " Underbar補完
        let g:neocomplcache_enable_underbar_completion = 1

        let g:neocomplcache_dictionary_filetype_lists = {
          \ 'java' : '~/.vim/dict/java.dict',
          \ 'ruby' : '~/.vim/dict/ruby.dict',
          \ 'eruby' : '~/.vim/dict/erb.dict'
          \ }
        if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    endfunction

    " 'GundoToggle'が呼ばれるまでロードしない
    NeoBundleLazy 'sjl/gundo.vim', {
        \ "autoload": {"commands": ["GundoToggle"]}}
    " '<Plug>TaskList'というマッピングが呼ばれるまでロードしない
    NeoBundleLazy 'vim-scripts/TaskList.vim', {
        \ "autoload": {"mappings": ['<Plug>TaskList']}}
    " HTMLが開かれるまでロードしない
    NeoBundleLazy 'mattn/emmet-vim', {
        \ "autoload": {"filetypes": ['html', 'jsp', 'xml']}}

    nnoremap <Leader>g :GundoToggle<CR>

    NeoBundle "thinca/vim-template"
    " テンプレート中に含まれる特定文字列を置き換える
    autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
    function! s:template_keywords()
        silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
        silent! %s/<+FILENAME+>/\=expand('%:r')/g
    endfunction
    " テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
    autocmd MyAutoCmd User plugin-template-loaded
        \   if search('<+CURSOR+>')
        \ |   silent! execute 'normal! "_da>'
        \ | endif

    NeoBundle 'yuratomo/w3m.vim'

    NeoBundleLazy "Shougo/unite.vim", {
          \ "autoload": {
          \   "commands": ["Unite", "UniteWithBufferDir"]
          \ }}
    NeoBundleLazy 'h1mesuke/unite-outline', {
          \ "autoload": {
          \   "unite_sources": ["outline"],
          \ }}

    nnoremap [unite] <Nop>
    nmap U [unite]
    nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
    nnoremap <silent> [unite]r :<C-u>Unite register<CR>
    nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
    nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>
    nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
    nnoremap <silent> [unite]t :<C-u>Unite tag<CR>
    nnoremap <silent> [unite]w :<C-u>Unite window<CR>
    nnoremap <silent> [unite]s :<C-u>Unite snippet<CR>
    nnoremap <silent> [unite]r :<C-u>Unite ruby/require<CR>
    nnoremap <silent> [unite]c :<C-u>Unite codic<CR>
    let s:hooks = neobundle#get_hooks("unite.vim")
    function! s:hooks.on_source(bundle)
      " start unite in insert mode
      let g:unite_enable_start_insert = 1
      let g:unite_source_file_ignore_pattern='target/.*'
      let g:unite_source_grep_default_opts = '-iRHn'
      " use vimfiler to open directory
      call unite#custom_default_action("source/bookmark/directory", "vimfiler")
      call unite#custom_default_action("directory", "vimfiler")
      call unite#custom_default_action("directory_mru", "vimfiler")
      autocmd MyAutoCmd FileType unite call s:unite_settings()
      function! s:unite_settings()
        imap <buffer> <Esc><Esc> <Plug>(unite_exit)
        nmap <buffer> <Esc> <Plug>(unite_exit)
        nmap <buffer> <C-n> <Plug>(unite_select_next_line)
        nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
      endfunction

       " escape２回で終了
       au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
       au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
       " ウィンドウを分割して開く
       au FileType unite nnoremap <silent> <buffer> <expr> <C-x> unite#do_action('split')
       au FileType unite inoremap <silent> <buffer> <expr> <C-x> unite#do_action('split')
       " ウィンドウを縦に分割して開く
       au FileType unite nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
       au FileType unite inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
    endfunction

    NeoBundleLazy "Shougo/vimfiler", {
      \ "depends": ["Shougo/unite.vim"],
      \ "autoload": {
      \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
      \   "mappings": ['<Plug>(vimfiler_switch)'],
      \   "explorer": 1,
      \ }}
    nnoremap <Leader>e :VimFilerExplorer<CR>
    " close vimfiler automatically when there are only vimfiler open
    autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
    let s:hooks = neobundle#get_hooks("vimfiler")
    function! s:hooks.on_source(bundle)
      "セーフモードを無効にした状態で起動する
      let g:vimfiler_safe_mode_by_default = 0
      let g:vimfiler_enable_auto_cd = 1
  
      " .から始まるファイルおよび.pycで終わるファイルを不可視パターンに
      let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"
      let g:vimfiler_as_default_explorer = 1
      " vimfiler specific key mappings
      autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
      function! s:vimfiler_settings()
        " ^^ to go up
        nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
        " use R to refresh
        nmap <buffer> R <Plug>(vimfiler_redraw_screen)
        " overwrite C-l
        nmap <buffer> <C-l> <C-w>l
      endfunction
    endfunction



    NeoBundleLazy "mattn/gist-vim", {
          \ "depends": ["mattn/webapi-vim"],
          \ "autoload": {
          \   "commands": ["Gist"],
          \ }}

    " vim-fugitiveは'autocmd'多用してるっぽくて遅延ロード不可
    NeoBundle "tpope/vim-fugitive"
    " for Fugitive {{{
    nnoremap <Space>gd :<C-u>Gdiff<Enter>
    nnoremap <Space>gs :<C-u>Gstatus<Enter>
    nnoremap <Space>gl :<C-u>Glog<Enter>
    nnoremap <Space>ga :<C-u>Gwrite<Enter>
    nnoremap <Space>gc :<C-u>Gcommit<Enter>
    nnoremap <Space>gC :<C-u>Git commit --amend<Enter>
    nnoremap <Space>gb :<C-u>Gblame<Enter>
    " }}}
    NeoBundleLazy "gregsexton/gitv", {
          \ "depends": ["tpope/vim-fugitive"],
          \ "autoload": {
          \   "commands": ["Gitv"],
          \ }}


    NeoBundle 'tpope/vim-surround'
    NeoBundle 'vim-scripts/Align'

  NeoBundle 'LeafCage/yankround.vim'
  "http://leafcage.hateblo.jp/entry/2013/10/31/yankroundvim
  " for yankround {{{
  nmap p <Plug>(yankround-p)
  nmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  nmap gP <Plug>(yankround-gP)
  nmap <C-m> <Plug>(yankround-prev)
  nmap <C-n> <Plug>(yankround-next)
  nnoremap <silent>y<C-p> :<C-u>CtrlPYankRound<CR>
  " "}}}

    if has('lua') && v:version >= 703 && has('patch885')
        NeoBundleLazy "Shougo/neocomplete.vim", {
            \ "autoload": {
            \   "insert": 1,
            \ }}
        let g:neocomplete#enable_at_startup = 1
        let s:hooks = neobundle#get_hooks("neocomplete.vim")
        function! s:hooks.on_source(bundle)
            let g:acp_enableAtStartup = 0
            let g:neocomplet#enable_smart_case = 1
        endfunction
    else
        NeoBundleLazy "Shougo/neocomplcache.vim", {
            \ "autoload": {
            \   "insert": 1,
            \ }}
        let g:neocomplcache_enable_at_startup = 1
        let s:hooks = neobundle#get_hooks("neocomplcache.vim")
        function! s:hooks.on_source(bundle)
            let g:acp_enableAtStartup = 0
            let g:neocomplcache_enable_smart_case = 1
            " NeoComplCacheを有効化
            " NeoComplCacheEnable 
        endfunction
    endif


    NeoBundle "Shougo/neosnippet-snippets"
    NeoBundle "Shougo/neosnippet.vim"
    let s:hooks = neobundle#get_hooks("neosnippet.vim")
    function! s:hooks.on_source(bundle)
      " Plugin key-mappings.
      imap <C-k>     <Plug>(neosnippet_expand_or_jump)
      smap <C-k>     <Plug>(neosnippet_expand_or_jump)
      xmap <C-k>     <Plug>(neosnippet_expand_target)
      " SuperTab like snippets behavior.
      imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
      smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"
      " For snippet_complete marker.
      if has('conceal')
        set conceallevel=2 concealcursor=i
      endif
      " Enable snipMate compatibility feature.
      let g:neosnippet#enable_snipmate_compatibility = 1
      " Tell Neosnippet about the other snippets
      let g:neosnippet#snippets_directory=s:bundle_root . '~./vim/snippets'

      function! s:AngularSnippet()
        if exists("g:angular_root") && (&filetype == "javascript")
          NeoSnippetSource ~/.vim/snippets/angular.snippets
        endif
      endfunction
      function! s:KnockoutSnippet()
        if exists("g:knockout_root") && (&filetype == "javascript")
          NeoSnippetSource ~/.vim/snippets/knockout.snippets
        endif
      endfunction

      function! s:JavaSnippet()
        if (&filetype == 'java')
          let java_version = s:java_version()
          if (java_version =~ "1.7")
            NeoSnippetSource ~/.vim/snippets/java1_7.snippets
          elseif (java_version =~ "1.8")
            NeoSnippetSource ~/.vim/snippets/java1_8.snippets
          elseif (java_version =~ "1.6")
            NeoSnippetSource ~/.vim/snippets/java1_6.snippets
          endif
        endif
      endfunction

      function! s:ScalaSpecSnippet()
        let s:current_file_path = expand("%:p:h")
        if (&filetype == 'scala' && s:current_file_path =~ "test")
          NeoSnippetSource ~/.vim/snippets/specs2_scala.snippets
        endif
      endfunction

      function! s:PlayControllerSnippet()
        let s:current_file_path = expand("%:p:h")
        if (&filetype == 'scala' && s:current_file_path =~ "app/controllers")
          NeoSnippetSource ~/.vim/snippets/play_controller.snippets
        endif
      endfunction

      function! s:RailsControllerSnippet()
        let s:current_file_path = expand("%:p:h")
        if (&filetype == 'ruby' && s:current_file_path =~ "controllers")
          NeoSnippetSource ~/.vim/snippets/rails_controller.snippets
        endif
      endfunction

      function! s:RailsSpecSnippet()
        let s:current_file_path = expand("%:p:h")
        if (&filetype == 'ruby' && s:current_file_path =~ "spec")
          NeoSnippetSource ~/.vim/snippets/rails_spec.snippets
          set dictionary=~/.vim/dict/rails_spec.dict
        endif
      endfunction

      autocmd BufEnter * call s:AngularSnippet()
      autocmd BufEnter * call s:KnockoutSnippet()
      autocmd BufEnter * call s:JavaSnippet()
      autocmd BufEnter * call s:ScalaSpecSnippet()
      autocmd BufEnter * call s:PlayControllerSnippet()
      autocmd BufEnter * call s:RailsControllerSnippet()
      autocmd BufEnter * call s:RailsSpecSnippet()

    endfunction

    NeoBundle "nathanaelkane/vim-indent-guides"
    let s:hooks = neobundle#get_hooks("vim-indent-guides")
    function! s:hooks.on_source(bundle)
      let g:indent_guides_enable_on_vim_startup = 1
      let g:indent_guides_guide_size = 1
    endfunction
    NeoBundleLazy "bronson/vim-trailing-whitespace", {
      \ 'filetypes' : ['scala', 'ruby'],
      \ }

    NeoBundle "thinca/vim-quickrun"

    NeoBundleLazy 'majutsushi/tagbar', {
          \ "autload": {
          \   "commands": ["TagbarToggle"],
          \ },
          \ "build": {
          \   "mac": "brew install ctags",
          \ }}
    nmap <Leader>t :TagbarToggle<CR>

    " watchdogs
    NeoBundleLazy "jceb/vim-hier", {
      \ 'filetypes' : ['ruby'],
      \ }
    NeoBundleLazy "osyo-manga/shabadou.vim" , {
      \ 'filetypes' : ['ruby'],
      \ }
    NeoBundleLazy "osyo-manga/vim-watchdogs", {
      \ 'filetypes' : ['ruby'],
      \ }
    let s:hooks = neobundle#get_hooks("vim-watchdogs")
    function! s:hooks.on_source(bundle)
      let g:watchdogs_check_BufWritePost_enable = 1
      let g:watchdogs_check_CursorHold_enable = 1
      " quickfixを閉じる。
      "let g:quickrun_config = {
        "\   "watchdogs_checker/_" : {
        "\       "hook/close_quickfix/enable_exit" : 1,
        "\   },
        "\}
      "call watchdogs#setup(g:quickrun_config)
    endfunction
    NeoBundleLazy "dannyob/quickfixstatus", {
      \ 'filetypes' : ['ruby'],
      \ }
    " watchdogs

    NeoBundleLazy "scrooloose/syntastic", {
          \ "autoload": {
          \   "filetypes": ["java", "javascript", "rust"],
          \ },
          \ "build": {
          \   "mac": ["pip install flake8", "npm -g install coffeelint"],
          \   "unix": ["pip install flake8", "npm -g install coffeelint"],
          \ }}

    NeoBundleLazy "davidhalter/jedi-vim", {
          \ "autoload": {
          \   "filetypes": ["python", "python3", "djangohtml"],
          \ },
          \ "build": {
          \   "mac": "pip install jedi",
          \   "unix": "pip install jedi",
          \ }}
    let s:hooks = neobundle#get_hooks("jedi-vim")
    function! s:hooks.on_source(bundle)
      " jediにvimの設定を任せると'completeopt+=preview'するので
      " 自動設定機能をOFFにし手動で設定を行う
      let g:jedi#auto_vim_configuration = 0
      " 補完の最初の項目が選択された状態だと使いにくいためオフにする
      let g:jedi#popup_select_first=0
      let g:jedi#popup_on_dot=0
      " quickrunと被るため大文字に変更
      let g:jedi#rename_command = '<Leader>R'
      " gundoと被るため大文字に変更
      "let g:jedi#goto_command = '<Leader>P'
    endfunction

    " 起動<c-p>
    " vsplit open <c-v>
    " split open <c-x>
    NeoBundle 'kien/ctrlp.vim'
    let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bower_components|bin)\/|(\.(swp|ico|git|svn|class|jar))$'
    "let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_working_path_mode = 'w'

    " </ を入力したときに自動的に補完してくれる。
    NeoBundle 'docunext/closetag.vim'
    " スネークケース、キャメルケースの変換など crc crs
    NeoBundle 'tpope/vim-abolish'
    NeoBundle 'fuenor/qfixgrep.git'

    "for java
    NeoBundleLazy 'Shougo/javacomplete', {
      \ 'build': {
      \ 'cygwin': 'javac autoload/Reflection.java',
      \ 'mac': 'javac autoload/Reflection.java',
      \ 'unix': 'javac autoload/Reflection.java',
      \ },
      \ 'filetypes' : 'java',
      \}

    NeoBundleLazy "java_getset.vim", {
      \ 'filetypes' : 'java',
      \ }

    NeoBundleLazy 'KamunagiChiduru/unite-javaimport', {
      \ 'filetypes' : 'java',
      \ 'depends': [
       \ 'Shougo/unite.vim',
       \ 'KamunagiChiduru/vim-javaclasspath',
       \ 'KamunagiChiduru/vim-javalang',
       \ 'yuratomo/w3m.vim',
       \ ],
      \}

    NeoBundleLazy 'tky/java-insert-package.vim' ,{
      \ 'filetypes' : 'java',
    \}
    let s:hooks = neobundle#get_hooks('java-insert-package.vim')
    function! s:hooks.on_source(bundle)
      nnoremap :pkg :JavaInsertPackage<CR>
    endfunction

    NeoBundleLazy 'tky/java-import-assist.vim' ,{
      \ 'filetypes' : 'java',
    \}
    let s:hooks = neobundle#get_hooks('java-import-assist.vim')
    function! s:hooks.on_source(bundle)
      nnoremap :ip :JavaImportPackage<CR>
    endfunction

    NeoBundle '5t111111/alt-gtags.vim'

    " for javascript
    NeoBundleLazy "JavaScript-syntax", {
      \ 'filetypes' : 'javascript',
      \ }

    NeoBundleLazy "pangloss/vim-javascript", {
      \ 'filetypes' : 'javascript',
      \ }

    "gxでブラウザ起動。なぜもっと早く気がつかなかった。。
    NeoBundle 'open-browser.vim'
    let g:netrw_nogx = 1 " disable netrw's gx mapping.
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)

    NeoBundle 'tky/open-redmine'
    nnoremap gr :OpenRedmine<CR>

    NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_do_mapping = 0
    nmap s <Plug>(easymotion-s2)

    NeoBundle 'rhysd/clever-f.vim'
    " 大文字、小文字を無視してfする。
    let g:clever_f_ignore_case = 1

    NeoBundle 'mbbill/undotree'
    " undotree.vim
    " http://vimblog.com/blog/2012/09/02/undotree-dot-vim-display-your-undo-history-in-a-graph/
    " https://github.com/r1chelt/dotfiles/blob/master/.vimrc
    nmap <Leader>u :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_WindowLayout = 'topleft'
    let g:undotree_SplitWidth = 35
    let g:undotree_diffAutoOpen = 1
    let g:undotree_diffpanelHeight = 25
    let g:undotree_RelativeTimestamp = 1
    let g:undotree_TreeNodeShape = '*'
    let g:undotree_HighlightChangedText = 1
    let g:undotree_HighlightSyntax = "UnderLined"


    NeoBundle 'w0ng/vim-hybrid'
    NeoBundle 'nanotech/jellybeans.vim'
    NeoBundle 'Wombat'
    colorscheme desert
    NeoBundle 'itchyny/lightline.vim'
    let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'mode_map': {'c': 'NORMAL'},
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'directory' ] ]
            \ },
            \ 'component_function': {
            \   'modified': 'MyModified',
            \   'readonly': 'MyReadonly',
            \   'fugitive': 'MyFugitive',
            \   'filename': 'MyFilename',
            \   'fileformat': 'MyFileformat',
            \   'filetype': 'MyFiletype',
            \   'fileencoding': 'MyFileencoding',
            \   'directory': 'MyDirectory',
            \   'mode': 'MyMode'
            \ }
            \ }
    
    function! MyDirectory()
      return expand('%:p')
    endfunction

    function! MyModified()
      return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction
    
    function! MyReadonly()
      return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
    endfunction
    
    function! MyFilename()
      return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
            \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
            \  &ft == 'unite' ? unite#get_status_string() :
            \  &ft == 'vimshell' ? vimshell#get_status_string() :
            \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' != MyModified() ? ' ' . MyModified() : '')
    endfunction

    function! MyFugitive()
      try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
          return fugitive#head()
        endif
      catch
      endtry
      return ''
    endfunction

    function! MyFileformat()
      return winwidth(0) > 70 ? &fileformat : ''
    endfunction
    
    function! MyFiletype()
      return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction

    function! MyFileencoding()
      return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction

    NeoBundleLazy "skammer/vim-css-color", {
      \ 'filetypes' : 'css',
      \ }
    let s:bundle = neobundle#get('vim-css-color')
    function! s:bundle.hooks.on_source(bundle)
      let g:cssColorVimDoNotMessMyUpdatetime = 1
    endfunction

    NeoBundleLazy "derekwyatt/vim-scala", {
      \ 'filetypes' : 'scala',
      \ }

    function! MyMode()
      return winwidth(0) > 60 ? lightline#mode() : ''
    endfunction

    NeoBundle "vcscommand.vim"
    let howm_dir = '~/howmdir'
    let howm_fileencoding = 'utf-8'
    let howm_fielformat = 'unix'
    let QFixHowm_FileType = 'markdown'
    let QFixHowm_Title = '#'
    let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
    let QFixHowm_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.howm'

    NeoBundle 'fuenor/qfixhowm'
    NeoBundle 'szw/vim-tags'

    " for ruby
    NeoBundleLazy 'ruby-matchit', {
      \ 'filetypes' : 'ruby',
      \ }
    
    NeoBundleLazy 'rhysd/unite-ruby-require.vim', {
      \ 'filetypes' : 'ruby',
      \ }

    NeoBundleLazy 'rhysd/neco-ruby-keyword-args' , {
      \ 'filetypes' : 'ruby',
      \ }

    NeoBundleLazy 'Shougo/neocomplcache-rsense', {
      \ 'filetypes' : 'ruby',
      \ }

    let s:bundle = neobundle#get("neocomplcache-rsense")
    function! s:bundle.hooks.on_source(bundle)
      let g:neocomplcache_enable_at_startup = 1
      let g:neocomplcache#sources#rsense#home_directory = '/usr/local/Cellar/rsense/0.3'

      if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
      endif
      let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    endfunction
    unlet s:bundle

    NeoBundleLazy 'tpope/vim-endwise', {
      \ 'filetypes' : 'ruby',
      \ }

    NeoBundleLazy 'tpope/vim-dispatch', {
      \ 'filetypes' : 'ruby',
      \ }

    NeoBundleLazy 'thoughtbot/vim-rspec', {
      \ 'filetypes' : 'ruby',
      \ }
    let s:bundle = neobundle#get("vim-rspec")
    function! s:bundle.hooks.on_source(bundle)
       nnoremap :Tf :call RunCurrentSpecFile()<CR>
       nnoremap :Tn :call RunNearestSpec()<CR>
       nnoremap :Tl :call RunLastSpec()<CR>
       nnoremap :Ta :call RunAllSpecs()<CR>
    endfunction
    unlet s:bundle

    " for rails
    NeoBundleLazy 'tpope/vim-bundler', {
      \ 'filetypes' : 'ruby',
      \ }
    NeoBundleLazy 'tpope/vim-rails', {
      \ 'filetypes' : 'ruby',
      \ }


    " for tag
    NeoBundle  "tsukkee/unite-tag"
    
    NeoBundle "vim-scripts/taglist.vim"
    let Tlist_Exit_OnlyWindow = 1                      " taglistのウインドウだけならVimを閉じる
    map <silent> <leader>l :TlistToggle<CR>      " \lでtaglistウインドウを開いたり閉じたり出来るショートカット

    " for textobj
    NeoBundle "kana/vim-textobj-user"
    NeoBundle "h1mesuke/textobj-wiw"
    NeoBundle "osyo-manga/vim-textobj-multiblock"
    NeoBundle "thinca/vim-textobj-between"
    omap af <Plug>(textobj-multiblock-a)
    omap at <Plug>(textobj-multiblock-i)
    vmap af <Plug>(textobj-multiblock-a)
    vmap at <Plug>(textobj-multiblock-i)

    NeoBundleLazy "rhysd/vim-textobj-ruby" , {
      \ 'filetypes' : 'ruby',
      \ }

    NeoBundleLazy "wesleyche/SrcExpl", {
      \ "autoload": {"mappings": [' :SrcExplToggle']}
      \ }
    NeoBundleLazy "wesleyche/Trinity", {
      \ "autoload": {"mappings": [' :SrcExplToggle']}
      \ }

    nmap <F8> :SrcExplToggle<CR>
    let s:bundle = neobundle#get("SrcExpl")
    function! s:bundle.hooks.on_source(bundle)
      let g:SrcExpl_winHeight = 8
      let g:SrcExpl_refreshTime = 100
      let g:SrcExpl_pluginList = [ 
            \ "__Tag_List__"
        \ ] 
    endfunction
    unlet s:bundle
    NeoBundle "koron/codic-vim"

    NeoBundle 'Blackrush/vim-gocode', {
      \ 'filetypes' : 'go',
      \ }

    NeoBundleLazy "kchmck/vim-coffee-script" , {
      \ 'filetypes' : 'coffee',
      \ }

    NeoBundle 't9md/vim-quickhl'
    nmap <Space>m <Plug>(quickhl-manual-this)
    xmap <Space>m <Plug>(quickhl-manual-this)
    nmap <Space>M <Plug>(quickhl-manual-reset)
    xmap <Space>M <Plug>(quickhl-manual-reset)

    NeoBundle 'jlanzarotta/bufexplorer'

    "" for rust

    NeoBundleLazy "wting/rust.vim" , {
      \ 'filetypes' : 'rust',
      \ }

    "" for mustache
    NeoBundle "mustache/vim-mustache-handlebars", {
      \ 'filetypes' : 'mustache',
      \ }


    "" for haskell
    NeoBundle "dag/vim2hs", {
      \ 'filetypes' : 'mustache',
      \ }

    " 一身上の都合でgithubにあげられない設定を分離
    if !empty(glob("~/.local.vimrc"))
      source ~/.local.vimrc
    endif

    call neobundle#end()

    " インストールされていないプラグインのチェックおよびダウンロード
    NeoBundleCheck
endif

" ファイルタイププラグインおよびインデントを有効化
" これはNeoBundleによる処理が終了したあとに呼ばなければならない
filetype plugin indent on

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
":set statusline=%F%m%r%h%w\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
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
