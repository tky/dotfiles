" for nvie/vim-flake8'
autocmd BufWritePost *.py call Flake8()
let g:flake8_quickfix_location="topleft"
let g:flake8_quickfix_height=7
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1
