" SpecialFileLocations/Temp.vim: File locations in temp directory.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2017-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! SpecialFileLocations#Temp#Save( dirspec, filename, fileOptionsAndCommands )
    " By delegating to SpecialFileLocations#Scratch#Save(), we get the handling
    " of special buffers for free. The only downside is that the function
    " doesn't handle a:fileOptionsAndCommands (yet).
    if ! SpecialFileLocations#Scratch#Save(g:scratchFilenameTemplate, ingo#escape#file#fnameunescape(a:dirspec), (g:IngoLibrary_CmdCompleteDirForAction_Context.bang ? '!' : ''), ingo#escape#file#fnameunescape(a:filename))
	throw ingo#err#Get()
    endif
endfunction
function! SpecialFileLocations#Temp#NewestFileProcessing( filename, fileOptionsAndCommands )
    return SpecialFileLocations#Completions#NewestFileProcessing(g:tempDirspec, a:filename, a:fileOptionsAndCommands)
endfunction
function! SpecialFileLocations#Temp#Filename( filename, fileOptionsAndCommands )
    return (empty(a:filename) ?
    \   [strftime(g:scratchFilenameTemplate.unnamed), a:fileOptionsAndCommands] :
    \   SpecialFileLocations#Temp#NewestFileProcessing(a:filename, a:fileOptionsAndCommands)
    \)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
