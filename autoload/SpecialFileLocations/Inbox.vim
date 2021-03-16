" SpecialFileLocations/Inbox.vim: File locations in inbox directory.
"
" DEPENDENCIES:
"
" Copyright: (C) 2018-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! SpecialFileLocations#Inbox#NewestFileProcessing( filename, fileOptionsAndCommands )
    return SpecialFileLocations#Completions#NewestFileProcessing(g:inboxDirspec, a:filename, a:fileOptionsAndCommands)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
