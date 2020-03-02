" SpecialFileLocations.vim: Various ways to access files from special locations.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2017-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	004	03-Mar-2020	Adapt: g:CommandCompleteDirForAction_Context has
"				been renamed after moving into the ingo-library.
"	003	29-Oct-2019	Adapt: ingomappings#PutRegisterContents() moved
"				into ingo-library.
"	002	25-Oct-2018	Add SpecialFileLocations#Yank().
"	001	31-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#Above( dirspec, filename, fileOptionsAndCommands )
    execute ingo#plugin#setting#Default(g:IngoLibrary_CmdCompleteDirForAction_Context.mods, 'aboveleft') 'split' a:fileOptionsAndCommands . a:dirspec . a:filename
endfunction
function! SpecialFileLocations#Below( dirspec, filename, fileOptionsAndCommands )
    execute ingo#plugin#setting#Default(g:IngoLibrary_CmdCompleteDirForAction_Context.mods, 'belowright') 'split' a:fileOptionsAndCommands . a:dirspec . a:filename
endfunction

function! SpecialFileLocations#Yank( dirspec, filename, fileOptionsAndCommands )
    if ! empty(a:fileOptionsAndCommands)
	throw 'Cannot pass ++opt / +cmd!'
    endif

    let l:filespec = ingo#escape#file#fnameunescape(a:dirspec . a:filename)
    call ingo#plugin#register#PutContents('FilePath', l:filespec, 'v', '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
