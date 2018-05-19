" SpecialFileLocations/Temp.vim: File locations in temp directory.
"
" DEPENDENCIES:
"   - SpecialFileLocations/Scratch.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape/file.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#Temp#Save( dirspec, filename, fileOptionsAndCommands )
    " By delegating to SpecialFileLocations#Scratch#Save(), we get the handling
    " of special buffers for free. The only downside is that the function
    " doesn't handle a:fileOptionsAndCommands (yet).
    if ! SpecialFileLocations#Scratch#Save(g:scratchFilenameTemplate, ingo#escape#file#fnameunescape(a:dirspec), (g:CommandCompleteDirForAction_Context.bang ? '!' : ''), ingo#escape#file#fnameunescape(a:filename))
	throw ingo#err#Get()
    endif
endfunction
function! SpecialFileLocations#Temp#Filename( filename, fileOptionsAndCommands )
    return [(empty(a:filename) ? strftime(g:scratchFilenameTemplate.unnamed) : a:filename), a:fileOptionsAndCommands]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
