fu! FileTime()
        let ext=tolower(expand("%:e"))
    let fname=tolower(expand('%<'))
    let filename=fname . '.' . ext
    let msg=""
    let msg=msg." ".strftime("(Mod %b,%d %H:%M)",getftime(filename))
    return msg
endf

fu! CurTime()
    let ftime=""
    let ftime=ftime." ".strftime("%b,%d %y %H:%M:%S")
    return ftime
endf

" modify selected text using combining diacritics
function! s:CombineSelection(line1, line2, cp)
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')


" usage, :CHB
command! CHB call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
	let open_buffers = []
	for i in range(tabpagenr('$'))
		call extend(open_buffers, tabpagebuflist(i + 1))
	endfor
	for num in range(1, bufnr("$") + 1)
		if buflisted(num) && index(open_buffers, num) == -1
			exec "bdelete ".num
		endif
	endfor
endfunction

noremap <leader>ldt :Linediff<CR>
noremap <leader>ldo :LinediffReset<CR>
noremap ]q :lnext<CR>
noremap [q :lprev<CR>
noremap [c :lcl<CR>

function! DoPrettyXML()
	" save the filetype so we can restore it later
	let l:origft = &ft
	set ft=
	" delete the xml header if it exists. This will
	" permit us to surround the document with fake tags
	" without creating invalid xml.
	1s/<?xml .*?>//e
	" insert fake tags around the entire document.
	" This will permit us to pretty-format excerpts of
	" XML that may contain multiple top-level elements.
	0put ='<PrettyXML>'
	$put ='</PrettyXML>'
	silent %!xmllint --format -
	" xmllint will insert an <?xml?> header. it's easy enough to delete
	" if you don't want it.
	" delete the fake tags
	2d
	$d
	" restore the 'normal' indentation, which is one extra level
	" too deep due to the extra tags we wrapped around the document.
	silent %<
	" back to home
	1
	" restore the filetype
	exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
" modify selected text using combining diacritics

function! ToUnix()
    set ff=unix
    w
    e
endfunction
command! Tounix call ToUnix()
" Put plugins and dictionaries in this dir (also on Windows)

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(nvimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . nvimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

set tags+=.tags
function! MakeTags()
    !etags -f .tags -R *
endfunction

func! FoldedToText( ) 
    let res = [] 
    let l = 1 
    while l <= line('$') 
      if foldclosed(l) != -1 
        let res+= [ foldtextresult(l) ] 
        let l = foldclosedend(l) 
      else 
        let res+= [ getline(l) ] 
      endif 
      let l+=1 
    endwhile 
    return res 
endfun 
command! Writefolds call writefile(FoldedToText(),'/tmp/bar') | tabe /tmp/bar

command! Maketags call MakeTags()
nnoremap <leader>m :MarkologyToggle<CR>

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @'.group.' /usr/local/share/nvim/runtime/syntax/'.a:filetype.'.vim'
    try
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
    \ matchgroup='.a:textSnipHl.'
    \ start="'.a:start.'" end="'.a:end.'"
    \ contains=@'.group
endfunction

call TextEnableCodeSnip(  'xml', '# @begin=xml@', '@end=xml@', 'SpecialComment')
call TextEnableCodeSnip(  'java', '@begin=java@', '@end=java@', 'SpecialComment')
call TextEnableCodeSnip(  'json', '# @begin=json@', '@end=json@', 'SpecialComment')

cmap w!! w !sudo tee >/dev/null %
" enables to search in all open buffers with :Search <pattern>
command! -nargs=1 Search call setqflist([]) | silent execute "bufdo grepadd! '<args>' %" | redraw!
nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
map bufn :echo bufnr('')-1<cr>

" Workspace Setup
" ----------------
function! DefaultWorkspace()
    " Rough num columns to decide between laptop and big monitor screens
    let numcol = 2
    if winwidth(0) >= 220
        let numcol = 3
    endif

    if numcol == 3
        e term://bash
        file Bash
        vnew
    endif

    vsp term://mutt
    file Mutt
    sp term://ikhal
    file ikhal
    wincmd k
    resize 34
    wincmd h
endfunction
command! -register DefaultWorkspace call DefaultWorkspace()

" Window split settings
highlight TermCursor ctermfg=red guifg=red
set splitbelow
set splitright

" Window navigation function
" Make ctrl-h/j/k/l move between windows and auto-insert in terminals
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor
