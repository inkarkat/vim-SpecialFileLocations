" SpecialFileLocations.vim: Various ways to access files from special locations.
"
" DEPENDENCIES:
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	31-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#Above( dirspec, filename, fileOptionsAndCommands )
    execute ingo#plugin#setting#Default(g:CommandCompleteDirForAction_Context.mods, 'aboveleft') 'split' a:fileOptionsAndCommands . a:dirspec . a:filename
endfunction
function! SpecialFileLocations#Below( dirspec, filename, fileOptionsAndCommands )
    execute ingo#plugin#setting#Default(g:CommandCompleteDirForAction_Context.mods, 'belowright') 'split' a:fileOptionsAndCommands . a:dirspec . a:filename
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
