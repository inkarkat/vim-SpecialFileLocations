" SpecialFileLocations/Inbox.vim: File locations in inbox directory.
"
" DEPENDENCIES:
"   - ingo/collections/memoized.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/fs/path.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation from ingocommands.vim

function! s:FtimeSort( i1, i2 )
    return -1 * ingo#collections#memoized#Mapsort('getftime(v:val)', a:i1, a:i2, {'cacheTimeInSeconds': 10})
endfunction
function! SpecialFileLocations#Inbox#Complete( ArgLead, CmdLine, CursorPos )
    " Complete first files from g:inboxDirspec for the {filename} argument
    " (sorted by file modification date descending), then any path- and filespec
    " from the CWD for {dir} and {filespec}.
    let l:scratchDirspecPrefix = glob(ingo#fs#path#Combine(g:inboxDirspec, ''))
    return
    \	map(
    \	    map(
    \		sort(
    \               ingo#compat#glob(ingo#fs#path#Combine(g:inboxDirspec, a:ArgLead . '*'), 0, 1),
    \               's:FtimeSort'
    \           ),
    \		'strpart(v:val, len(l:scratchDirspecPrefix))'
    \	    ) +
    \       map(
    \           ingo#compat#glob(a:ArgLead . '*', 0, 1),
    \           'isdirectory(v:val) ? ingo#fs#path#Combine(v:val, "") : v:val'
    \       ),
    \       'ingo#compat#fnameescape(v:val)'
    \   )
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
