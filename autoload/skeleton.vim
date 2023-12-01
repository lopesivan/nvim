function! skeleton#Skel()
  let extension = expand("%:e")
  return system("skeleton ".extension)
endfunction

" vim: fdm=marker:sw=2:sts=2:et
