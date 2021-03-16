" SpecialFileLocations/Completions.vim: Completions (and counted file access) for special file locations.
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

function! SpecialFileLocations#Completions#DirspecNewestFilesFirst( dirspec, isAllowOtherDirs, ArgLead, CmdLine, CursorPos )
    " Complete first files from a:dirspec for the {filename} argument (sorted by
    " file modification date descending), then any path- and filespec from the
    " CWD for {dir} and {filespec}.
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    let l:hasAbsoluteArgLead = (! empty(a:ArgLead) && ingo#fs#path#IsAbsolute(a:ArgLead))

    if ! l:hasAbsoluteArgLead
	let l:filespecs = map(
	\   sort(
	\       ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, a:ArgLead . '*'), 0, 1),
	\       'ingo#collections#FileModificationTimeSort'
	\   ),
	\   'strpart(isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val, len(l:dirspecPrefix))'
	\)
    elseif a:isAllowOtherDirs
	let l:filespecs = map(
	\   ingo#compat#glob(a:ArgLead . '*', 0, 1),
	\   'isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val'
	\)
    else
	let l:filespecs = []
    endif
    return map(l:filespecs, 'ingo#compat#fnameescape(v:val)')
endfunction
function! SpecialFileLocations#Completions#MakeForNewestFirst( dirspec, ... )
    let l:isAllowOtherDirs = (a:0 && a:1)
    return ingo#plugin#cmdcomplete#MakeCompleteFunc(
    \   printf('return SpecialFileLocations#Completions#DirspecNewestFilesFirst(%s, %d, a:ArgLead, a:CmdLine, a:CursorPos)', string(a:dirspec), l:isAllowOtherDirs)
    \)
endfunction

function! SpecialFileLocations#Completions#GetNewestFile( dirspec, count )
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    let l:filesByFtime =
    \   map(
    \       filter(
    \           sort(
    \               ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, '*'), 0, 1),
    \               'ingo#collections#FileModificationTimeSort'
    \           ),
    \           '! isdirectory(v:val)'
    \       ),
    \       'strpart(v:val, len(l:dirspecPrefix))'
    \   )

    return get(l:filesByFtime, a:count - 1, '')
endfunction
function! SpecialFileLocations#Completions#NewestFileProcessing( dirspec, filename, fileOptionsAndCommands )
    return [(a:filename =~# '^\d\+$' ?
    \   SpecialFileLocations#Completions#GetNewestFile(a:dirspec, str2nr(a:filename)) :
    \   a:filename
    \), a:fileOptionsAndCommands]
endfunction


function! s:IsEmptyMediaDirectory( filespec ) abort
    if ! isdirectory(a:filespec)
	return 0
    endif

    let l:subdir = ingo#fs#path#split#AtBasePath(a:filespec, g:mediaDirspec)
    let [l:path, l:name] = ingo#fs#path#split#PathAndName(l:subdir, 0)
    if empty(l:name)
	" Original subdir had trailing slash, now do the real splitting.
	let [l:path, l:name] = ingo#fs#path#split#PathAndName(l:path, 0)
    endif
    if l:path !=# '.'
	" This isn't a first-level subdirectory.
	return 0
    endif

    return empty(ingo#compat#glob(ingo#fs#path#Combine(a:filespec, '*'), 1, 1))
endfunction
function! SpecialFileLocations#Completions#NonEmptyMediaDirectoryHook( filespecs ) abort
    return filter(a:filespecs, '! s:IsEmptyMediaDirectory(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
