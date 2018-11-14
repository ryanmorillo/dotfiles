map <leader>c :set cursorline! cursorcolumn!<Enter>
",v brings up my .config/nvim/init.vim
",V reloads it -- making all changes active (have to save first)
map <leader>v :sp ~/.config/nvim/init.vim<Enter>
map <silent> <leader>V :source ~/.config/nvim/init.vim<Enter>:filetype detect<Enter>:exe ":echo 'nvim/init.vim reloaded'"<Enter>
map <leader>s :w<Enter>:!scons<Enter>
map =x :PrettyXML<Enter>:set syntax=xml<Enter>
map =js :call JsBeautify()<cr>
map =j :%!python -m json.tool<Enter>
map <leader>tok :let @x = join(readfile("/home/ryan/act_token"), "\n")<Enter>:%s/\(x-auth-token: \).\+$/\1<c-r>x<Enter>

nnoremap <F9> :UndotreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
" below maps to exit terminal insert mode
tnoremap <leader>e <C-\><C-n>
" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
:abbr bullet •
