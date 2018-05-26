colorscheme pablo
syntax enable
set tabstop=4
set expandtab
set number
set autoindent
set showmatch
set foldenable
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za
set foldmethod=indent

execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
autocmd BufNewFile *.bash 0r ~/.vim/templates/skeleton.bash
autocmd BufNewFile *.html 0r ~/.vim/templates/skeleton.html
autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py
