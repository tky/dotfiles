source ~/.config/nvim/basic.vim
source ~/.config/nvim/indent.vim
if !empty(glob("~/.local.vimrc"))
  source ~/.local.vimrc
endif

call plug#begin('~/.vim/plugged')

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html', 'typescript.tsx'] }

let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0


Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'github/copilot.vim'

Plug 'nvim-tree/nvim-tree.lua'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
" :CocInstall coc-fzf-preview after plug install.
Plug 'yuki-yano/fzf-preview.vim'

Plug 'dyng/ctrlsf.vim', { 'do': 'brew install the_silver_searcher' }
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'tpope/vim-surround'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'tyru/open-browser.vim'


Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': { -> coc#util#install()}}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}

Plug 'tpope/vim-abolish'
Plug 'mattn/emmet-vim', {'for': ['html', 'eruby']}
Plug 'tpope/vim-repeat'

Plug 'brglng/vim-im-select', {'do': 'brew tap daipeihust/tap && brew install im-select'}

Plug 'nvim-lua/plenary.nvim' 
Plug 'scalameta/nvim-metals'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'easymotion/vim-easymotion'

Plug 'rust-lang/rust.vim', { 'for': 'rust' }


call plug#end()

nmap s <Plug>(easymotion-overwin-f2)
nmap <Space><Space>s <Plug>(easymotion-overwin-f2)

" for ctrlsf {{{
let g:ctrlsf_ackprg = 'ag'
" }}}

" for coc.nvim {{{
"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


" Remap keys for gotos
nmap <silent> gD <Plug>(coc-definition)
nmap <silent> gd :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" 補完メニュー表示中: C-j=次候補 / C-k=前候補（非表示時は素のC-j/C-k）
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Use K to either doHover or show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of current line
xmap <leader>a  <Plug>(coc-codeaction-line)
nmap <leader>a  <Plug>(coc-codeaction-line)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Trigger for code actions
" Make sure `"codeLens.enable": true` is set in your coc config
nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}

nnoremap <silent> <C-p> :GFiles<CR>

" for nvim-tree {{{
" ツリーの中のキーは、以前使っていた defx の割り当てにできるだけそろえている
lua << EOF
local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  -- まず既定のキーを入れ、そのあとで defx と同じキーで上書きする
  api.config.mappings.default_on_attach(bufnr)

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = desc })
  end
  local function node() return api.tree.get_node_under_cursor() end

  -- defx の drop と同じく、ファイルなら開き、フォルダならその中へ移る
  local function drop()
    local n = node()
    if n and n.type == "directory" then
      api.tree.change_root_to_node(n)
    else
      api.node.open.edit()
    end
  end

  map("<CR>", drop, "開く・フォルダの中へ")
  map("l", drop, "開く・フォルダの中へ")
  map("o", api.node.open.edit, "フォルダを開く・閉じる")
  map("E", api.node.open.vertical, "縦に分けて開く")
  map("P", api.node.open.preview, "プレビュー")
  map("c", api.fs.copy.node, "コピー")
  map("m", api.fs.cut, "移動（切り取り）")
  map("p", api.fs.paste, "貼り付け")
  map("N", api.fs.create, "新しいファイル")
  map("K", api.fs.create, "新しいフォルダ（名前の最後に / を付ける）")
  map("d", api.fs.remove, "削除")
  map("r", api.fs.rename, "名前の変更")
  map("yy", api.fs.copy.absolute_path, "パスをコピー")
  map(".", api.tree.toggle_hidden_filter, "隠しファイルの表示の切り替え")
  map("h", api.tree.change_root_to_parent, "1つ上のフォルダへ")
  map("~", function() api.tree.change_root(vim.env.HOME) end, "ホームへ")
  map("q", api.tree.close, "閉じる")
  map("<Space>", function() api.marks.toggle(); vim.cmd("normal! j") end, "選択して次へ")
  map("C", api.node.show_info_popup, "ファイルの情報")
  map("<C-l>", api.tree.reload, "表示し直す")
  map("<C-g>", function() local n = node(); if n then print(n.absolute_path) end end, "パスを表示")
  map("cd", function()
    local n = node()
    if not n then return end
    local dir = n.type == "directory" and n.absolute_path or vim.fn.fnamemodify(n.absolute_path, ":h")
    vim.cmd.cd(dir)
    print(dir)
  end, "Vim の作業フォルダをここにする")
  -- 端で j・k を押したら反対の端へ
  vim.keymap.set("n", "j", function() return vim.fn.line(".") == vim.fn.line("$") and "gg" or "j" end, { buffer = bufnr, expr = true })
  vim.keymap.set("n", "k", function() return vim.fn.line(".") == 1 and "G" or "k" end, { buffer = bufnr, expr = true })
end

require("nvim-tree").setup({
  on_attach = on_attach,
  view = { width = 40, side = "left" },
  -- defx の show_ignored_files = 1 と同じく、隠しファイルと Git で無視しているファイルも出す
  filters = { dotfiles = false, git_ignored = false },
  -- Nerd Font がなくても崩れないように、アイコンは使わない
  renderer = {
    add_trailing = true,
    icons = {
      show = { file = false, folder = false, folder_arrow = true, git = false },
      glyphs = { folder = { arrow_closed = "+", arrow_open = "-" } },
    },
  },
})
EOF

nnoremap <silent> <Leader>d :<C-u>NvimTreeToggle<CR>
" }}}

nmap g* :CtrlSF<CR>
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
  execute "CtrlSF" . "'" . s:get_visual_selection() . "'"
endfunction
command! -nargs=0 GrepSelection call s:grep_visual_selection()
vnoremap <C-f> <ESC>:GrepSelection<CR>
let g:ctrlsf_auto_close = 1
let g:ctrlsf_ignore_dir = ["node_modules"]

let g:ctrlsf_mapping = {
    \ "split": "S",
    \ "tab": "T",
    \ }

" for Fugitive {{{
nnoremap <Space>gd :<C-u>Gdiff<Enter>
nnoremap <Space>gs :<C-u>Git status<Enter>
nnoremap <Space>gb :<C-u>Git blame<Enter>
" }}}

" for vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
" }}}


" for open-browser.vim {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}


let g:python3_host_prog = $PYENV_ROOT.'/shims/python3.13'


nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>


imap <C-,> <Plug>(copilot-next)
imap <C-.> <Plug>(copilot-previous)
