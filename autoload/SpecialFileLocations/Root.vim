" SpecialFileLocations/Root.vim: File locations relative to VCS root.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"   - VcsRoot.vim plugin
"
" Copyright: (C) 2017-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! SpecialFileLocations#Root#Dirspec()
    let l:vcsRoot = VcsRoot#Root()
    if empty(l:vcsRoot)
	throw 'Cannot determine project root'
    endif
    return ingo#fs#path#Combine(l:vcsRoot, '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
