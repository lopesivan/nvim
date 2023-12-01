" $Id$
" Name Of File: snippets.vim
"
"  Description: Vim plugin
"
"       Author: Ivan Carlos S. Lopes <lopesivan (at) poli (dot) com (dot) br>
"   Maintainer: Ivan Carlos S. Lopes <lopesivan (at) poli (dot) com (dot) br>
"
"  Last Change: qua 02 dez 2020 11:02:28 -03
"      Version: |Revision|
"
"    Copyright: This script is released under the Vim License.
"

if &cp || exists("g:loaded_snippets")
	finish
endif

let g:loaded_snippets = "v01"
let s:keepcpo     = &cpo
set cpo&vim

"-----------------------------------------------------------------------------
set foldmethod=marker

"-----------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

" vim: ts=4
