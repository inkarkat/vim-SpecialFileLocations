" SpecialFileLocations/Completions.vim: Completions (and counted file access) for special file locations.
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
"	007	03-Mar-2020	FIX:
"				SpecialFileLocations#Completions#MakeForNewestFirst()
"				always resolves other absolute directories, but
"				not all special file locations support this
"				(only scratch does, inbox and temp do not). Add
"				optional a:isAllowOtherDirs argument and pass on
"				to completion implementation.
"	006	15-Jul-2019	BUG: Newest file is also mistakenly used when
"                               the passed {filespec} starts with a number.
"                               Forgot anchoring to end.
"	005	28-May-2019	BUG: Forgot to replace s:FtimeSort() with
"                               ingo-library function.
"	004	13-May-2019	Move s:FtimeSort() into ingo-library for reuse.
"	003	20-May-2018	FIX: Indicate completed directories from
"                               a:dirspec with trailing path separator.
"                               ENH: Add
"                               SpecialFileLocations#Completions#GetNewestFile()
"                               to access a [count] newest file (skipping
"                               directories), which is similar to the completion
"                               done here. Add
"                               SpecialFileLocations#Completions#NewestFileProcessing()
"                               which can be used to accept numbered filename
"                               arguments and translate them into the [count]'th
"                               newest file.
"	002	18-May-2018	Rename and make generic as a factory for
"                               completion functions.
"                               Don't append a:ArgLead to a:dirspec if it
"                               contains (the beginning of) an absolute
"                               filespec. Seen this in the (otherwise identical,
"                               except for the sorting)
"                               SpecialFileLocations#Scratch#Complete().
"	001	30-Oct-2017	file creation from ingocommands.vim
let s:save_cpo = &cpo
set cpo&vim

function! SpecialFileLocations#Completions#DirspecNewestFilesFirst( dirspec, isAllowOtherDirs, ArgLead, CmdLine, CursorPos )
    " Complete first files from a:dirspec for the {filename} argument (sorted by
    " file modification date descending), then any path- and filespec from the
    " CWD for {dir} and {filespec}.
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    let l:filespecs = []
    if empty(a:ArgLead) || ! ingo#fs#path#IsAbsolute(a:ArgLead)
	let l:filespecs += map(
	\   sort(
	\       ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, a:ArgLead . '*'), 0, 1),
	\       'ingo#collections#FileModificationTimeSort'
	\   ),
	\   'strpart(isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val, len(l:dirspecPrefix))'
	\)
    endif
    if a:isAllowOtherDirs
	let l:filespecs += map(
	\   ingo#compat#glob(a:ArgLead . '*', 0, 1),
	\   'isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val'
	\)
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

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
