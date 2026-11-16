" plugin/f4.vim - F 4
" Maintainer: Ivan Lopes

if exists("g:loaded_f4") || v:version < 700 || &cp
    finish
endif
let g:loaded_f4 = 1

nnoremap <silent> <F4> :call <sid>zoom()<cr>
function s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction


