" $Id$
" Name Of File: |n|
"
"  Description: Vim plugin
"
"       Author: Ivan Carlos S. Lopes <lopesivan (at) poli (dot) com (dot) br>
"   Maintainer: Ivan Carlos S. Lopes <lopesivan (at) poli (dot) com (dot) br>
"
"  Last Change: $Date:$
"      Version: $Revision:$
"
"    Copyright: This script is released under the Vim License.
"

if &cp || exists("g:loaded_maps")
        finish
endif

let g:loaded_maps = "v01"
let s:keepcpo  = &cpo
set cpo&vim

" ----------------------------------------------------------------------------
map <leader>c1 :%g/^\n\{2,\}/ d<CR>:%s/\s\+$//g<CR>
map <leader>c2 :setlocal expandtab<CR>:retab<CR>
map <silent><C-S-Left>  :new<CR>
map <silent><C-S-Right> :tabnew<CR>
map <PageUp>   :tabprevious<CR>
map <PageDown> :tabNext<CR>

"" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

vmap <Enter> <Plug>(EasyAlign)

" 1 - faço /palavra
" 2 - cw para mudar a palavra
" 3 - n. faz amudança na proxima palavra  ...
" nn Q n.
" nn Q @='n.'<CR>
" nn Q :normal n.<CR>
" ----------------------------------------------------------------------------

let &cpo= s:keepcpo
unlet s:keepcpo

" vim: ts=8

