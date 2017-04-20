scriptencoding utf-8
set encoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'https://github.com/jistr/vim-nerdtree-tabs.git'
Plugin 'https://github.com/ervandew/supertab.git'
Plugin 'https://github.com/airblade/vim-gitgutter.git'
Plugin 'https://github.com/itchyny/lightline.vim.git'
Plugin 'https://github.com/sickill/vim-monokai.git'
Plugin 'https://github.com/vim-syntastic/syntastic.git'
Plugin 'easymotion/vim-easymotion'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

colorscheme monokai

set tabstop=4
set nu
syntax enable

map <C-n> :NERDTreeTabsToggle<CR>
map ,n :NERDTreeFind<CR>

nnoremap <C-k> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>


set laststatus=2

" show existing tab with 4 spaces width
set tabstop=2
" " when indenting with '>', use 4 spaces width
set shiftwidth=2
" " On pressing tab, insert 4 spaces
set expandtab
:set listchars=trail:@
:set list

set clipboard+=unnamedplus

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_args = "--no-eslintrc --config /Users/snicksnk/projects/moda/frontend/.eslintrc"

let g:syntastic_error_symbol = '%'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '.!'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

map  <c-f> <Plug> (asymotion-bd-w)
nmap <c-f> <Plug> (easymotion-overwin-w)


function! MyTabLine()
    let tabline = ''

    " Формируем tabline для каждой вкладки -->
        for i in range(tabpagenr('$'))
            " Подсвечиваем заголовок выбранной в данный момент вкладки.
            if i + 1 == tabpagenr()
                let tabline .= '%#TabLineSel#'
            else
                let tabline .= '%#TabLine#'
            endif

            " Устанавливаем номер вкладки
            let tabline .= '%' . (i + 1) . 'T'

            " Получаем имя вкладки
            let tabline .= '%{MyTabLabel(' . (i + 1) . ')}|'
        endfor
    " Формируем tabline для каждой вкладки <--

    " Заполняем лишнее пространство
    " let tabline .= '%#TabLineFill#%T'

    " Выровненная по правому краю кнопка закрытия вкладки
    if tabpagenr('$') > 1
        let tabline .= '%=%#TabLine#%999XX'
    endif

    return tabline
endfunction

function! MyTabLabel(n)
    let label = ''
    let buflist = tabpagebuflist(a:n)
    let filePathSeparator = '/'

    " Имя файла и номер вкладки -->
        let filePath = bufname(buflist[tabpagewinnr(a:n) - 1])
        let filePathParts = split(filePath, filePathSeparator)
        let fileName = get(filePathParts, -1)
        let fileLastDir = get(filePathParts, -2)
        if matchstr(fileName, 'index') == 'index'
          echo 'ok!'
          let label = substitute(filePath, '\v(.*)\/([a-zA-Z]+)\/index\.(\w+)$', '$\2 \3', '')
        else
          let label =  fileName
        endif
        echo matchstr(split(filePath, filePathSeparator)[-1], 'index2')


        if label == ''
            let label = '[No Name]'
        endif

        let label =  ' ' . a:n . ' ' . label
    " Имя файла и номер вкладки <--

    " Определяем, есть ли во вкладке хотя бы один
    " модифицированный буфер.
    " -->
        for i in range(len(buflist))
            if getbufvar(buflist[i], "&modified")
                let label = '[+]' . label
                break
            endif
        endfor
    " <--

    return label
endfunction

function! MyGuiTabLabel()
    return '%{MyTabLabel(' . tabpagenr() . ')}'
endfunction

set tabline=%MyTabLine()
set guitablabel=%!MyGuiTabLabel()
" Задаем собственные функции для назначения имен заголовкам табов <--
