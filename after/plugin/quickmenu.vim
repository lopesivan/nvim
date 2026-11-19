" /home/ivan/.config/nvim/after/plugin/quickmenu.vim
" Maintainer: Ivan Lopes

function! s:walk(menu, path, mode) abort
  let full = empty(a:path) ? a:menu.name : a:path . '.' . a:menu.name

  if !empty(get(a:menu, 'submenus', []))
    call quickmenu#append('# ' . a:menu.name, '')
    for sub in a:menu.submenus
      call s:walk(sub, full, a:mode)
    endfor
  elseif has_key(get(a:menu, 'mappings', {}), a:mode)
    call quickmenu#append(a:menu.name, 'emenu ' . full)
  endif
endfunction

function! Menu2Quick(name, mode) abort
  let menu_list = menu_get(a:name, a:mode)
  if empty(menu_list)
    echohl WarningMsg | echom 'Menu "' . a:name . '" vazio' | echohl None
    return
  endif

  call quickmenu#reset()
  call quickmenu#header(a:name)

  for menu in menu_list
    call s:walk(menu, '', a:mode)
  endfor

  call quickmenu#toggle(0)
endfunction

" vim: fdm=marker:sw=4:sts=4:et
