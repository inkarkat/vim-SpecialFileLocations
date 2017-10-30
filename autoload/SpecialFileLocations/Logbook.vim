" SpecialFileLocations/Logbook.vim: File locations of logbooks.
"
" DEPENDENCIES:
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation

function! SpecialFileLocations#Logbook#InstallLogbookFilename( filename, fileOptionsAndCommands )
    return [(a:filename =~# '\.txt$' ? a:filename : a:filename . '.txt'), a:fileOptionsAndCommands]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
