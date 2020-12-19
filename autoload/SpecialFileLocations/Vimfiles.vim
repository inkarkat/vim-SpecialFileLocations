" SpecialFileLocations/Vimfiles.vim: File locations within Vim configuration.
"
" DEPENDENCIES:
"   - SidTools.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/fs/path/split.vim autoload script
"   - ingo/option.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation from ingocommands.vim

function! SpecialFileLocations#Vimfiles#CompleteProcessing( dirspec, filename, fileOptionsAndCommands )
    if a:filename =~? '^\.g\?vimrc$'
	" Special case: .[g]vimrc lie outside of ~/.vim
	return [a:dirspec, '../' . a:filename, a:fileOptionsAndCommands]
    elseif a:filename =~# '^\d\+$'
	" DWIM: Open script with passed <SID>.
	return ['', ingo#compat#fnameescape(SidTools#SidImpl(str2nr(a:filename), 0)), a:fileOptionsAndCommands]
    else
	return [a:dirspec, a:filename, a:fileOptionsAndCommands]
    endif
endfunction
function! SpecialFileLocations#Vimfiles#Complete( ArgLead, CmdLine, CursorPos )
    if ! empty(a:ArgLead)
	let l:vimrcCompletions = []
	for l:specialFile in ['.vimrc', '.gvimrc']
	    if l:specialFile =~ '\V\^' . escape(a:ArgLead, '\')
		call add(l:vimrcCompletions, ingo#fs#path#Combine('..', l:specialFile))
	    endif
	endfor
	if ! empty(l:vimrcCompletions)
	    return l:vimrcCompletions
	endif
    endif
    return call(g:SpecialFileLocations#Vimfiles#completeVimFunction, [a:ArgLead, a:CmdLine, a:CursorPos])
endfunction

" Resolve the path to my .vim / vimfiles directory without hard-coding it or the
" platform differences.
function! SpecialFileLocations#Vimfiles#GetMyVimRuntime( ... )
    let l:isFnameescape = (a:0 && a:1)

    " Because of the augmentation of 'runtimepath' for old Vim version support,
    " the first directory in 'runtimepath' isn't necessarily my user Vim
    " runtime. Check for the existence of the "doc" subdirectory, too.
    for l:dirspec in ingo#option#Split(&runtimepath)
	if isdirectory(l:dirspec . '/doc')
	    if (l:isFnameescape)
		let l:dirspec = ingo#compat#fnameescape(l:dirspec)
	    endif

	    return (a:0 >= 2 ?
	    \   ingo#fs#path#Combine(l:dirspec, a:2) :
	    \   l:dirspec
	    \)
	endif
    endfor
    return ''
endfunction
function! SpecialFileLocations#Vimfiles#GetMyVimRuntimePaths( ... )
    let l:isFnameescape = (a:0 && a:1)
    let l:myVimRuntime = SpecialFileLocations#Vimfiles#GetMyVimRuntime()
    return map(
    \   [ingo#fs#path#Combine(l:myVimRuntime, '')] + ingo#compat#glob(l:myVimRuntime . '/pack/ingo/start/*/', 0, 1),
    \   (a:0 >= 2 ?
    \       'ingo#fs#path#Combine((l:isFnameescape ? ingo#compat#fnameescape(v:val) : v:val), a:2)' :
    \       '(l:isFnameescape ? ingo#compat#fnameescape(fnamemodify(v:val, ":h")) : fnamemodify(v:val, ":h"))'
    \   )
    \)
endfunction
function! SpecialFileLocations#Vimfiles#GetPackRootDirspecs()
    return map(
    \   ingo#compat#glob(SpecialFileLocations#Vimfiles#GetMyVimRuntime(0, 'pack/*/start/'), 0, 1),
    \   'ingo#fs#path#Combine(v:val, "")'
    \)
endfunction
function! SpecialFileLocations#Vimfiles#GetPackDirspecs()
    return map(
    \   filter(
    \       ingo#option#Split(&runtimepath),
    \       'ingo#fs#path#split#Contains(v:val, "/.vim/pack/") && ! ingo#fs#path#split#EndsWith(v:val, "/.vim/pack")'
    \   ),
    \   'ingo#fs#path#Combine(v:val, "")'
    \)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
