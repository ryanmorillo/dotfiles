"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/ryan/.cache/dein/repos/github.com/Shougo/dein.vim
set runtimepath+=/home/ryan/.config/nvim/bundle.list

" Required:
if dein#load_state('/home/ryan/.cache/dein')
  call dein#begin('/home/ryan/.cache/dein')

  source /home/ryan/.config/nvim/bundle.list
  " Let dein manage dein
  " Required:
  call dein#add('/home/ryan/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

 " Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif
 "
" Required:

" Required:
filetype plugin indent on
syntax enable

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
"Large file is 500K
let g:LargeFile = 1024 * 1024 / 2
let nvimDir=expand('~/.config/nvim')
let mapleader = ","
let maplocalleader = "\\"
au! BufRead,BufNewFile *.c      setfiletype splint
au! BufNewFile,BufRead *.edc set syntax=edc
let g:zipPlugin_ext = '*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.celzip,*.oxt,*.kmz,*.wsz,*.xap,*.docx,*.docm,*.dotx,*.dotm,*.potx,*.potm,*.ppsx,*.ppsm,*.pptx,*.pptm,*.ppam,*.sldx,*.thmx,*.crtx,*.vdw,*.glox,*.gcsx,*.gqsx'
au! BufReadCmd *.odt,*.jar,*.egg,*.ua call zip#Browse(expand("<amatch>"))
if has("autocmd") && exists("+omnifunc") 
 autocmd Filetype * 
     \ if &omnifunc == "" | 
     \ setlocal omnifunc=syntaxcomplete#Complete | 
     \ syntax enable |
     \ endif 
endif

let bash_is_sh=1

":colorscheme koehler
:colorscheme lucius
:LuciusBlack
    " LuciusDark
    " LuciusDarkHighContrast
    " LuciusDarkLowContrast
    " LuciusBlack
    " LuciusBlackHighContrast
    " LuciusBlackLowContrast

    " LuciusLight "(light default)
    " LuciusLightLowContrast
    " LuciusWhite
    " LuciusWhiteLowContrast
let g:python_host_prog='/usr/bin/python'
let g:python3_host_prog='/usr/bin/python3'
"compiler scons
augroup java 
    autocmd! FileType java 
    if filereadable('pom.xml')
         setlocal makeprg=mvn\ -e\ -B\ -f\ ./pom.xml\ clean\ -DENVIRONMENT=staging\ -DWORKFLOW_NAME=RPC\ -DREREUN_FAILURE=FALSE\ test
         setlocal errorformat=\[ERROR]\ %f:[%l\\,%v]\ %m
    else
        compiler javac
        setlocal makeprg=javac\ %
    endif
    set tags=~/.tags
augroup END

augroup oo
    autocmd! FileType java,python,c++,cpp
    nmap <leader>t :TlistToggle<Enter>
augroup END

" Turn UniCycle on by default for all XML and XSLT files
augroup sgml
    autocmd FileType xml,xslt,tex UniCycleOn
    set syntax=xml
    let g:xml_syntax_folding=1
    au FileType xml setlocal foldmethod=syntax
augroup END

autocmd FileType python :set makeprg=python3\ %
autocmd FileType python :call TextEnableCodeSnip(  'json', '# @begin=json@', '@end=json@', 'SpecialComment')
autocmd! BufWritePost * Neomake

let settings=nvimDir."/settings.vim"
if filereadable(settings)
	exec 'source ' . settings
endif

let maps=nvimDir."/maps.vim"
if filereadable(maps)
	exec 'source ' . maps
endif

let functs=nvimDir."/functions.vim"
if filereadable(functs)
	exec 'source ' . functs
endif

" if has('mouse') |set mouse=a | endif

" negative/positive lookahead/behind
" /\(Start\)\@<!Date
" This will match the 'Date' in 'EndDate' and 'YesterdaysDate' but will not match 'StartDate'
" 
" and what the hell, while I'm lookup up vim syntax, here's negative lookahead:
" /Start\(Date\)\@!
" will match the 'Start' in 'Starting but not in 'StartDate'
" 
" Positive lookahead:
" /Start\(Date\)\@=
" will match the 'Start' in 'StartDate' but not in 'Starting
" 
" Positive lookbehind
" /\(Start\)\@<=Date
" will match the 'Date' in 'StartDate' but not in 'EndDate' and 'YesterdaysDate'
"
" For web pages
" %s#<\(/\)\@!#\r<#g

let g:unite_enable_start_insert = 0
let g:unite_force_overwrite_statusline = 1
let g:deoplete#enable_at_startup = 1
let g:gtm_plugin_status_enabled = 1
let g:syntastic_python_checkers = ['pycodestyle', 'pylint', 'mypy']
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\u26A0"
let g:syntastic_enable_highlighting = 1
let g:http_client_verify_ssl = 0
if executable('ag')
	let g:unite_source_rec_async_command = ['ag','--follow','--nocolor','--nogroup','--hidden','-g','']
endif

nnoremap <leader>r :<C-u>UniteWithCurrentDir -start-insert file_rec/async:!<CR>
nnoremap <space>/ :Unite grep:.<CR>
nnoremap <space>s :Unite -quick-match buffer<CR>
au TermClose * bd!
" termguicolors doesn't play nice with terminology
" set termguicolors
" colorscheme jellybeans

" eovim things
:nnoremap <F11> :call Eovim("sizing", {'aspect': 'fullscreen_toggle'})<CR>
function! EovimImageViewer ()
   call Eovim("imageviewer", expand("%:p"))
   bdelete
endfunction

:autocmd! BufEnter *.png,*.jpg,*gif  call EovimImageViewer()

" Notes:
" Edit past end of line (enable virtualedit):
"     set virtualedit=all
