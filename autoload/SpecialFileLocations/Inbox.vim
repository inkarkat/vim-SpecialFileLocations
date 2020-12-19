" SpecialFileLocations/Inbox.vim: File locations in inbox directory.
"
" DEPENDENCIES:
"   - SpecialFileLocations/Completions.vim autoload script
"
" Copyright: (C) 2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	20-May-2018	file creation from
"                               autoload/SpecialFileLocations/Temp.vim

function! SpecialFileLocations#Inbox#NewestFileProcessing( filename, fileOptionsAndCommands )
    return SpecialFileLocations#Completions#NewestFileProcessing(g:inboxDirspec, a:filename, a:fileOptionsAndCommands)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
