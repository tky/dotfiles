source $XDG_CONFIG_HOME/nvim/basic.vim

call plug#begin('~/.vim/plugged')

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp', { 'do': 'pip install python-language-server'}

Plug 'lighttiger2505/deoplete-vim-lsp'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'

call plug#end()

call deoplete#custom#option({
    \ 'auto_complete': v:true,
    \ 'min_pattern_length': 2,
    \ 'auto_complete_delay': 0,
    \ 'auto_refresh_delay': 20,
    \ 'refresh_always': v:true,
    \ 'smart_case': v:true,
    \ 'camel_case': v:true,
    \ })
let s:use_lsp_sources = ['lsp', 'dictionary', 'file']
call deoplete#custom#option('sources', {
    \ 'go': s:use_lsp_sources,
    \ 'python': s:use_lsp_sources,
    \ 'vim': ['vim', 'buffer', 'dictionary', 'file'],
    \})


let g:deoplete#enable_at_startup = 1

inoremap <expr><C-h> deoplete#smart_close_popup()."<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."<C-h>"

nnoremap <silent> <C-p> :GFiles<CR>

let g:python_host_prog = expand('~/.pyenv/versions/3.7.3/bin/python3.7')
let g:python3_host_prog = expand('~/.pyenv/versions/3.7.3/bin/python3.7')

source $XDG_CONFIG_HOME/nvim/python.vim
