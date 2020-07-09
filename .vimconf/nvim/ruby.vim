function! s:exists_file(file_name)
   if filereadable(a:file_name)
     return 1
   endif
   return 0
endfunction

function! s:is_rails_app()
  return s:exists_file('Gemfile')
endfunction

function! s:rails_callback()
  nnoremap [rails] <Nop>
  nmap :u [rails]
  nnoremap [rails]r :Denite<Space>rails:
  nnoremap <silent> [rails]r :<C-u>Denite<Space>rails:dwim<Return>
  nnoremap <silent> [rails]m :<C-u>Denite<Space>rails:model<Return>
  nnoremap <silent> [rails]c :<C-u>Denite<Space>rails:controller<Return>
  nnoremap <silent> [rails]v :<C-u>Denite<Space>rails:view<Return>
  nnoremap <silent> [rails]h :<C-u>Denite<Space>rails:helper<Return>
  nnoremap <silent> [rails]r :<C-u>Denite<Space>rails:test<Return>
  nnoremap <silent> [rails]s :<C-u>Denite<Space>rails:spec<Return>
endfunction

function! s:init_command()
  if s:is_rails_app()
    let F = function('s:rails_callback')
    call F()
  end
endfunction

call s:init_command()

" $ gem install solargraph
if executable('solargraph')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'solargraph',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
    \ 'initialization_options': {"diagnostics": "true"},
    \ 'whitelist': ['ruby'],
  \ })
endif
