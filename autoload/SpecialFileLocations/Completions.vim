" SpecialFileLocations/Completions.vim: Completions for special file locations.
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
"	002	18-May-2018	Rename and make generic as a factory for
"                               completion functions.
"	001	30-Oct-2017	file creation from ingocommands.vim

function! s:FtimeSort( i1, i2 )
    return -1 * ingo#collections#memoized#Mapsort('getftime(v:val)', a:i1, a:i2, {'cacheTimeInSeconds': 10})
endfunction
function! SpecialFileLocations#Completions#DirspecNewestFilesFirst( dirspec, ArgLead, CmdLine, CursorPos )
    " Complete first files from a:dirspec for the {filename} argument (sorted by
    " file modification date descending), then any path- and filespec from the
    " CWD for {dir} and {filespec}.
    let l:dirspecPrefix = glob(ingo#fs#path#Combine(a:dirspec, ''))
    return
    \	map(
    \	    map(
    \		sort(
    \               ingo#compat#glob(ingo#fs#path#Combine(a:dirspec, a:ArgLead . '*'), 0, 1),
    \               's:FtimeSort'
    \           ),
    \		'strpart(v:val, len(l:dirspecPrefix))'
    \	    ) +
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
