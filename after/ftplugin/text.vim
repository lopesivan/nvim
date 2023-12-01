" txt.vim - Txt
" Maintainer: Ivan Lopes

fun! FoldSomething(lnum)
  let line1=getline(a:lnum)
  let line2=getline(a:lnum+1)
  if line1=~'^$'
    if line2=~#'^"\s[A-Z][A-Z]'
      return ">1"
    elseif line2=~'^$'
      return 0
    elseif foldlevel(a:lnum-1)==2
      return 1
    endif
  elseif line1=~#'^"\s[A-Z][a-z]'
    return ">2"
  endif
  return "="
endfun

set foldexpr=FoldSomething(v:lnum)
set foldmethod=expr
set foldcolumn=3

" vim: fdm=marker:sw=4:sts=4:et
