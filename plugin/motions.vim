" $Id$
" Name Of File: |n|
"
"  Description: Vim plugin
"
"       Author: Ivan Lopes <lopesivan (at) poli (dot) com (dot) br>
"   Maintainer: Ivan Lopes <lopesivan (at) poli (dot) com (dot) br>
"
"  Last Change: $Date:$
"      Version: $Revision:$
"
"    Copyright: This script is released under the Vim License.
"

if &cp || exists("g:loaded_motion")
    finish
endif

let g:loaded_motion = "v01"
let s:keepcpo     = &cpo
set cpo&vim

"-----------------------------------------------------------------------------
"

function! MoveLineUp()
    call MoveLineOrVisualUp(".", "")
endfunction

function! MoveLineDown()
    call MoveLineOrVisualDown(".", "")
endfunction

function! MoveVisualUp()
    call MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction

function! MoveVisualDown()
    call MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction

function! MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
        echohl WarningMsg | echo '-- First line --'| echohl None
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
        call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
        echohl NonText | echo '-- Move to up --'| echohl None
    endif
endfunction

function! MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
        echohl WarningMsg | echo '-- Last line --'| echohl None
    else
        let move_arg = a:line_getter." +".v:count1
        call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
        echohl NonText | echo '-- Move to down --'| echohl None
    endif
endfunction

function! MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction

"
" MoveCharToRight
"
function MoveCharToRight()

    let cursor_position_x = col('.')
    let last_cursor_position = (col('$') -1)

    if cursor_position_x == last_cursor_position
        echohl WarningMsg | echo '-- End of line --'| echohl None
    else
        normal xp
        echohl NonText | echo '-- Move to right --'| echohl None
    endif

endfunction

"
" MoveCharToLeft
"
function MoveCharToLeft()

    let cursor_position_x = col('.')

    if cursor_position_x == 1
        echohl WarningMsg | echo '-- Begin of line --'| echohl None
    else
        normal xhP
        echohl NonText | echo '-- Move to left --'| echohl None
    endif

endfunction

"
" MoveCharToRightV
"
function MoveCharToRightV()

    let cursor_position_x = col('.')
    let last_cursor_position = (col('$') -1)

    if cursor_position_x == last_cursor_position
        echohl WarningMsg | echo '-- End of line --'| echohl None
    else
        normal xpgvlolo
        echohl NonText | echo '-- Move to right --'| echohl None
    endif

endfunction

"
" MoveCharToLeftV
"
function MoveCharToLeftV()

    let cursor_position_x = col('.')

    if cursor_position_x == 1
        echohl WarningMsg | echo '-- Begin of line --'| echohl None
    else
        normal xhPgvhoho
        echohl NonText | echo '-- Move to left --'| echohl None
    endif

endfunction

"
" MoveScreenToUP
"
function MoveScreenToUP()
    let first_line_visible = line('w0') +3
    let current_line = line('.')

    if first_line_visible == current_line
        echohl WarningMsg | echo '-- Begin of Screen --'| echohl None
    else
        let scrollaction=""
        exec "normal " . scrollaction
        redraw
        echohl NonText | echo '-- Move to UP --'| echohl None
    endif

endfunction

"
" MoveScreenToDown
"
function MoveScreenToDown()
    let last_line_visible = line('w$') -3
    let current_line = line('.')

    if last_line_visible == current_line
        echohl WarningMsg | echo '-- End of Screen --'| echohl None
    else
        let scrollaction=""
        exec "normal " . scrollaction
        redraw
        echohl NonText | echo '-- Move to Down --'| echohl None
    endif

endfunction

if( (maparg( '<s-Right>' ) == '' ) &&
\   (maparg( '<s-Left>'  ) == '' ) &&
\   (maparg( '<S-Up>'    ) == '' ) &&
\   (maparg( '<S-Down>'  ) == '' )
\)

nnoremap <silent> <s-Right>        :<C-u>call MoveCharToRight()<CR>
nnoremap <silent> <s-Left>         :<C-u>call MoveCharToLeft()<CR>
inoremap <silent> <s-Right>   <C-o>:<C-u>call MoveCharToRight()<CR>
inoremap <silent> <s-Left>    <C-o>:<C-u>call MoveCharToLeft()<CR>

function Wnext()
    if tabpagenr('$') == 1
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
            if exists('$TMUX')
              call system("tmux next-window")
            endif
        else
            bnext
        endif
    else
        tabnext
    endif
endfunction


function WNext()
    if tabpagenr('$') == 1
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
            if exists('$TMUX')
              call system("tmux previous-window")
            endif
        else
            bNext
        endif
    else
        tabNext
    endif
endfunction

function WFirst()
    if tabpagenr('$') == 1
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
            if exists('$TMUX')
              call system("tmux copy-mode")
            endif
        else
            bf
        endif
    else
        tabfirst
    endif
endfunction

function WLast()
    if tabpagenr('$') == 1
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
            if exists('$TMUX')
              call system("tmux new-window")
            endif
        else
            bl
        endif
    else
        tablast
    endif
endfunction

" nnoremap <silent> <c-Right> :<C-u>call WNext()<CR>
" nnoremap <silent> <c-Left>  :<C-u>call Wnext()<CR>
nnoremap <silent> <c-Right> :<C-u>call Wnext()<CR>
nnoremap <silent> <c-Left>  :<C-u>call WNext()<CR>
nnoremap <silent> <c-UP>    :<C-u>call WFirst()<CR>
nnoremap <silent> <c-Down>  :<C-u>call WLast()<CR>

nnoremap <silent> <s-Up>        :<C-u>call MoveLineUp()<CR>
nnoremap <silent> <s-Down>      :<C-u>call MoveLineDown()<CR>
inoremap <silent> <s-Up>   <C-o>:<C-u>call MoveLineUp()<CR>
vnoremap <silent> <s-Up>        :<C-u>call MoveVisualUp()<CR>
vnoremap <silent> <s-Down>      :<C-u>call MoveVisualDown()<CR>
inoremap <silent> <s-Down> <C-o>:<C-u>call MoveLineDown()<CR>

" A pair of maps for swapping a word to-the-left and to-the-right:
"nnoremap <unique> <silent> `h "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:silent! /Wuff  ----  Wuff!!<CR><c-o><c-l>
"nnoremap <unique> <silent> `l "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR>:silent! /Wuff  ----  Wuff!!<CR><c-l>
"map <C-F7> `h
"map <C-F8> `l
"map <a-Right> `l
"map <a-Left>  `h

"nnoremap <silent> <c-k>  :<C-u>call MoveScreenToUP()<CR>
"nnoremap <silent> <c-j>  :<C-u>call MoveScreenToDown()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
else
    echo "[my_motion.vim]: ERROR: Você tentou maper minhas marcações.\n"
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-----------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

" vim: ts=4
