" Zoom
nnoremap <silent> <F4> :call <sid>zoom()<cr>
function s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

command -nargs=* Stw call <SID>set_text_width()
function s:set_text_width()
  echohl ModeMsg
  let tw = 1 * input('set textwidth=')
  if tw > 0
    let &l:colorcolumn = tw+1
    let &l:tw = tw
  endif
  echon ' set colorcolumn='
  echohl None
  echon tw
endfunction

command -nargs=* Stab call <SID>tabstop_softtabstop_shiftwidth()
function s:tabstop_softtabstop_shiftwidth()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call <SID>summarize_tabs()
endfunction

function s:summarize_tabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction
