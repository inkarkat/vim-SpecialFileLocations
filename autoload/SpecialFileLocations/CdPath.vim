" SpecialFileLocations/CdPath.vim: File locations based on 'cdpath'.
"
" DEPENDENCIES:
"   - ingoaliases.vim plugin
"
" Copyright: (C) 2017-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	04-Mar-2020	Add SpecialFileLocations#CdPath#DirComplete()
"				for new :CCd command.
"	001	30-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#CdPath#Glob( ArgLead )
    let l:nameGlob = (empty(a:ArgLead) ? '' : a:ArgLead . '*')
    return ingo#compat#globpath(call('ingo#option#Append', [&cdpath] + values(g:ExtraCdPath)), ingo#fs#path#Combine('**', l:nameGlob), 0, 1)
endfunction
function! SpecialFileLocations#CdPath#Complete( ArgLead, CmdLine, CursorPos )
    let l:result = ingoaliases#CdPathComplete(0, a:ArgLead)
    if empty(l:result)
	let l:result = SpecialFileLocations#CdPath#Glob(a:ArgLead)
    endif
    return l:result
endfunction
function! SpecialFileLocations#CdPath#DirComplete( ArgLead, CmdLine, CursorPos )
    return ingoaliases#CdPathComplete(1, a:ArgLead)
endfunction
function! SpecialFileLocations#CdPath#GlobLookup( filespec, fileOptionsAndCommands )
    return [
    \   (filereadable(a:filespec) ?
    \       a:filespec :
    \       get(SpecialFileLocations#CdPath#Glob(a:filespec), 0, a:filespec)
    \   ),
    \   a:fileOptionsAndCommands
    \]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
