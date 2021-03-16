" SpecialFileLocations/Scratch.vim: File locations in scratch directory.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2017-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! s:InsertTimeAndFormat( template, filespec )
    let l:filename = fnamemodify(a:filespec, ':r')
    let l:extension = fnamemodify(a:filespec, ':e')

    return printf(strftime(a:template), l:filename) . (empty(l:extension) ? '' : '.') . l:extension
endfunction
function! s:ScratchFilespec( scratchFilenameTemplate, scratchDirspec, scratchBufferName, filespec )
    if empty(a:scratchBufferName) || a:scratchBufferName =~# '^\[No file \d\+\]$'
	" Use a generic filename with timestamp in case the buffer hasn't been
	" named.
	let l:scratchFilespec = strftime(a:scratchFilenameTemplate.unnamed)
    else
	" Use the scratch buffer name, removing the customary [Scratch]
	" appendix.
	let l:scratchFilespec = s:InsertTimeAndFormat(a:scratchFilenameTemplate.named, substitute(a:scratchBufferName, '\C \[Scratch\d*\]$', '', ''))
    endif

    if empty(a:filespec)
	return ingo#compat#fnameescape(ingo#fs#path#Combine(a:scratchDirspec, l:scratchFilespec))
    elseif isdirectory(a:filespec)
	return ingo#fs#path#Combine(a:filespec, ingo#compat#fnameescape(l:scratchFilespec))
    elseif ingo#fs#path#Normalize(a:filespec, '/') !~# '^\./' && (fnamemodify(a:filespec, ':h') ==# '.' || isdirectory(ingo#fs#path#Combine(a:scratchDirspec, fnamemodify(a:filespec, ':h'))))
	return ingo#fs#path#Combine(ingo#compat#fnameescape(a:scratchDirspec), s:InsertTimeAndFormat(a:scratchFilenameTemplate.given, a:filespec))
    else
	return a:filespec
    endif
endfunction
function! SpecialFileLocations#Scratch#MakeScratchy()
    setlocal buftype=nowrite readonly
endfunction
function! SpecialFileLocations#Scratch#New( scratchFilenameTemplate, scratchDirspec, count, mods, filespec )
    if SpecialFileLocations#Scratch#Create(a:scratchFilenameTemplate, a:scratchDirspec, a:count, a:mods, a:filespec)
	call SpecialFileLocations#Scratch#MakeScratchy()
	return 1
    endif
    return 0
endfunction
function! SpecialFileLocations#Scratch#Create( scratchFilenameTemplate, scratchDirspec, count, mods, filespec )
    try
	execute a:mods . ' ' . (a:count ? a:count : '') . 'new' s:ScratchFilespec(a:scratchFilenameTemplate, a:scratchDirspec, '', a:filespec)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! SpecialFileLocations#Scratch#Write( scratchFilenameTemplate, scratchDirspec, bang, range, filespec )
    let l:isUnnamedBuffer = empty(expand('%'))
    let l:filespec = SpecialFileLocations#Completions#NewestFileProcessing(a:scratchDirspec, a:filespec, '')[0]
    try
	execute 'keepalt' a:range . 'write' . a:bang s:ScratchFilespec(a:scratchFilenameTemplate, a:scratchDirspec, expand('%:t'), l:filespec)

	if l:isUnnamedBuffer
	    " The :write command sets the buffer name of an unnamed buffer. We
	    " don't want this for the :ScratchWrite command, so undo it.
	    silent! keepalt 0file
	endif
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

function! SpecialFileLocations#Scratch#Save( scratchFilenameTemplate, scratchDirspec, bang, filespec )
    let l:bang = a:bang
    let l:filespec = SpecialFileLocations#Completions#NewestFileProcessing(a:scratchDirspec, a:filespec, '')[0]
    if &l:buftype ==# 'nowrite' && &l:readonly && (empty(l:filespec) || ingo#fs#path#Equals(l:filespec, expand('%:p')))
	" Vim will complain with "E13: File exists (add ! to override)" if a
	" non-persistable buffer is written. DWIM and don't force the user to
	" use ! if the current scratch file should be written to its original
	" location (e.g. if it was opened via :ScratchEdit).
	let l:bang = '!'
    endif

    return s:UnscratchWithCommand('keepalt saveas' . l:bang, a:scratchFilenameTemplate, a:scratchDirspec, l:filespec)
endfunction
function! SpecialFileLocations#Scratch#Unscratch( scratchFilenameTemplate, scratchDirspec, filespec )
    return s:UnscratchWithCommand('keepalt file', a:scratchFilenameTemplate, a:scratchDirspec, a:filespec)
endfunction
function! s:UnscratchWithCommand( command, scratchFilenameTemplate, scratchDirspec, filespec )
    let l:save_bufsettings = 'setlocal ' . ingo#plugin#setting#BooleanToStringValue('modifiable') . ' '  . ingo#plugin#setting#BooleanToStringValue('readonly') . ' buftype=' . &l:buftype . ' bufhidden=' . &l:bufhidden . ' ' . ingo#plugin#setting#BooleanToStringValue('buflisted')
    let l:save_bufname = expand('%')
    setlocal noreadonly buftype= bufhidden= buflisted
    try
	execute a:command s:ScratchFilespec(a:scratchFilenameTemplate, a:scratchDirspec, expand('%:t'), a:filespec)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	" Restore scratch buffer name and scratch settings.
	execute 'silent! keepalt file' ingo#compat#fnameescape(l:save_bufname)
	"setlocal buftype=nowrite bufhidden=wipe nobuflisted
	execute l:save_bufsettings

	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

function! SpecialFileLocations#Scratch#NewestFileProcessing( filename, fileOptionsAndCommands )
    return SpecialFileLocations#Completions#NewestFileProcessing(g:scratchDirspec, a:filename, a:fileOptionsAndCommands)
endfunction



function! SpecialFileLocations#Scratch#It( cmd )
    try
	execute a:cmd
	call SpecialFileLocations#Scratch#MakeScratchy()
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
