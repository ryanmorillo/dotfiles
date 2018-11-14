set t_Co=256
set modeline
" make the nvim command-line 2 lines high so that we can see secret
" messages emitted by UniCycle and others
set cmdheight=2
setlocal spell spelllang=en_us
set dictionary=/usr/share/hunspell/en_US.dic
set thesaurus+=/usr/share/doc/dict-moby-thesaurus/mthesaur.txt
set spell
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set foldmethod=indent
set printoptions=paper:letter,duplex:short
set pastetoggle=<F6>
set wildmenu
set wildmode=longest:full,full
set tabpagemax=20
set path=.,/usr/include,$PWD/**,,
set autowrite
let g:virtualenv_directory = '/home/ryan/Envs'
let g:virtualenv_auto_activate = 1
let g:virtualenv_stl_format = '[%n]'
set laststatus=2
set statusline=%{exists('*GTMStatusline')?'['.GTMStatusline().']':''}%{virtualenv#statusline()}\ %{fugitive#statusline()}%<%f%<%{FileTime()}%<%h%m%r%=%-20.(ln=%03l,col=%02c,totln=%L%)\%h%m%r%=%-3(%)\%P\%=%{CurTime()}
" set statusline=%{exists('*GTMStatusline')?'['.GTMStatusline().']':''}\ %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" Use ag for search
if executable('ag')
  let g:ag_working_path_mode="r"
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_source_session_enable_auto_save = 1
