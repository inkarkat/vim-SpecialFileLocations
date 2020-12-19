" SpecialFileLocations/Root.vim: File locations relative to VCS root.
"
" DEPENDENCIES:
"   - VcsRoot.vim autoload script
"   - ingo/fs/path.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#Root#Dirspec()
    let l:vcsRoot = VcsRoot#Root()
    if empty(l:vcsRoot)
	throw 'Cannot determine project root'
    endif
    return ingo#fs#path#Combine(l:vcsRoot, '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
