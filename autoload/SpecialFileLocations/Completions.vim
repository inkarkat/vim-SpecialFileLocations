" SpecialFileLocations/Completions.vim: Completions (and counted file access) for special file locations.
"
" DEPENDENCIES:
"   - ingo/collections/memoized.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/plugin/cmdcomplete.vim autoload script
"
" Copyright: (C) 2017-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
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

function! s:FtimeSort( i1, i2 )
    return -1 * ingo#collections#memoized#Mapsort('getftime(v:val)', a:i1, a:i2, {'cacheTimeInSeconds': 10})
endfunction
function! SpecialFileLocations#Completions#DirspecNewestFilesFirst( dirspec, ArgLead, CmdLine, CursorPos )
    " Complete first files from a:dirspec for the {filename} argument (sorted by
    " file modification date descending), then any path- and filespec from the
    " CWD for {dir} and {filespec}.
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    return
    \   map(
    \       (! empty(a:ArgLead) && ingo#fs#path#IsAbsolute(a:ArgLead) ?
    \           [] :
    \           map(
    \               sort(
    \                   ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, a:ArgLead . '*'), 0, 1),
    \                   's:FtimeSort'
    \               ),
    \               'strpart(isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val, len(l:dirspecPrefix))'
    \           )
    \       ) +
    \       map(
    \           ingo#compat#glob(a:ArgLead . '*', 0, 1),
    \           'isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val'
    \       ),
    \       'ingo#compat#fnameescape(v:val)'
    \   )
endfunction
function! SpecialFileLocations#Completions#MakeForNewestFirst( dirspec )
    return ingo#plugin#cmdcomplete#MakeCompleteFunc(
    \   printf('return SpecialFileLocations#Completions#DirspecNewestFilesFirst(%s, a:ArgLead, a:CmdLine, a:CursorPos)', string(a:dirspec))
    \)
endfunction

function! SpecialFileLocations#Completions#GetNewestFile( dirspec, count )
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    let l:filesByFtime =
    \   map(
    \       filter(
    \           sort(
    \               ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, '*'), 0, 1),
    \               's:FtimeSort'
    \           ),
    \           '! isdirectory(v:val)'
    \       ),
    \       'strpart(v:val, len(l:dirspecPrefix))'
    \   )

    return get(l:filesByFtime, a:count - 1, '')
endfunction
function! SpecialFileLocations#Completions#NewestFileProcessing( dirspec, filename, fileOptionsAndCommands )
    return [(a:filename =~# '^\d\+' ?
    \   SpecialFileLocations#Completions#GetNewestFile(a:dirspec, str2nr(a:filename)) :
    \   a:filename
    \), a:fileOptionsAndCommands]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
