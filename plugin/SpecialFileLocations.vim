" SpecialFileLocations.vim: Various ways to access files from special locations.
"
" DEPENDENCIES:
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SpecialFileLocations') || (v:version < 700)
    finish
endif
let g:loaded_SpecialFileLocations = 1


":CEdit {file}		Edit {file} ...
":Csplit {file}		Edit {file} in a split (above) buffer...
":CSplit {file}		Edit {file} in a split (below) buffer...
":CDrop {file}		Drop {file} ...
":CRevert {file}	Revert the current buffer to the contents of {file} ...
":[line]CRead {file}	Read {file} ...
"			... from one of the 'cdpath' directories.
"
":[line]CReadFragment {file}
"			:CRead and insert fragment formatting around the read
"			contents.
":CSave[!] [{file}]
":[range]CWrite[!] [{file}]
"			Persist buffer into one of the 'cdpath' directories.
call CommandCompleteDirForAction#setup('CEdit', '', {
\   'action': 'edit',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup')
\})
call CommandCompleteDirForAction#setup('Csplit', '', {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CSplit', '', {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CDrop', '', {
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CRevert', '', {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CRead', '', {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CReadFragment', '', {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CSave', '', {
\   'commandAttributes': '-bang',
\   'action': 'saveas<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call CommandCompleteDirForAction#setup('CWrite', '', {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})

":RootEdit {file}	Edit project {file} ...
":Rootsplit {file}	Edit project {file} in a split (above) buffer...
":RootSplit {file}	Edit project {file} in a split (below) buffer...
":RootDrop {file}	Drop project {file} ...
":RootRevert {file}	Revert the current buffer to the contents of {file} ...
":[line]RootRead {file}	Read project {file} ...
"			... from the project root or one of its
"			subdirectories.
"
":[line]RootReadFragment {file}
"			:RootRead and insert fragment formatting around the read
"			contents.
":RootSave[!] [{file}]
":[range]RootWrite[!] [{file}]
"			Persist buffer to the project root or one of its
"			subdirectories.
call CommandCompleteDirForAction#setup('RootEdit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('Rootsplit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootSplit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootDrop', function('SpecialFileLocations#Root#Dirspec'), {
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootRevert', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootRead', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootReadFragment', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" ingo#fs#path#split#AtBasePath("%", SpecialFileLocations#Root#Dirspec())',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootSave', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-bang',
\   'action': 'saveas<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('RootWrite', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})


":TempEdit {file}	Edit {file} ...
":Tempsplit {file}	Edit {file} in a split (above) buffer...
":TempSplit {file}	Edit {file} in a split (below) buffer...
":TempDrop {file}	Drop {file} ...
":TempRevert {file}	Revert the current buffer to the contents of {file} ...
":[line]TempRead {file}	Read {file} ...
"			... from the temp directory or one of its
"			subdirectories.
":[line]TempReadFragment {file}
"			:TempRead and insert fragment formatting around the read
"			contents.
":[line]TempReadSnip {file}
"			:TempRead and insert snip formatting around the read
"			contents.
":TempSave[!] [{file}]
":[range]TempWrite[!] [{file}]
"			Persist buffer to the temp directory or one of its
"			subdirectories.
call CommandCompleteDirForAction#setup('TempEdit', ingo#fs#tempfile#Make(''), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('Tempsplit',ingo#fs#tempfile#Make(''), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempSplit',ingo#fs#tempfile#Make(''), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempDrop', ingo#fs#tempfile#Make(''), {
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempRevert',ingo#fs#tempfile#Make(''), {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempRead', ingo#fs#tempfile#Make(''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempReadFragment', ingo#fs#tempfile#Make(''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempReadSnip', ingo#fs#tempfile#Make(''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('TempSave', ingo#fs#tempfile#Make(''), {
\   'commandAttributes': '-bang',
\   'action': function('SpecialFileLocations#Temp#Save'),
\   'defaultFilename': '',
\   'isIncludeSubdirs': 1
\})
" Note: We cannot use s:SpecialFileLocations#Scratch#Write() here, as there's no way to pass on the
" range. The only bit of functionality that we lose is the clearing of the name
" of an unnamed buffer.
call CommandCompleteDirForAction#setup('TempWrite', ingo#fs#tempfile#Make(''), {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'defaultFilename': '%',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#Filename'),
\   'isIncludeSubdirs': 1
\})


if ! exists('g:scratchDirspec')
    let g:scratchDirspec = ingo#fs#path#Combine($HOME, 'scratch')
endif
if ! exists('g:scratchFilenameTemplate')
    let g:scratchFilenameTemplate = {
    \   'unnamed': 'untitled_%Y%m%d-%H%M%S',
    \   'named': '%%s',
    \   'given': '%%s',
    \}
endif
":ScratchEdit {file}	Edit {file} from the default g:scratchDirspec.
":Scratchsplit {file}	Edit {file} in a split (above) buffer.
":ScratchSplit {file}	Edit {file} in a split (below) buffer.
":ScratchDrop {file}	Drop {file} from the default g:scratchDirspec.
":ScratchRevert {file}	Revert the current buffer to the contents of {file}
"			from the default g:scratchDirspec.
":[line]ScratchRead {file}
"			Read {file} from the default g:scratchDirspec.
":[line]ScratchReadFragment {file}
"			:ScratchRead and insert fragment formatting around the
"			read contents.
":[line]ScratchReadSnip {file}
"			:ScratchRead and insert snip formatting around the read
"			contents.
":ScratchSource {file}	Source {file} from the default g:scratchDirspec.
call CommandCompleteDirForAction#setup('ScratchEdit', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'edit',
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\})
call CommandCompleteDirForAction#setup('Scratchsplit',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\})
call CommandCompleteDirForAction#setup('ScratchSplit',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\})
call CommandCompleteDirForAction#setup('ScratchDrop', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\})
call CommandCompleteDirForAction#setup('ScratchRevert',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'Revert',
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\})
call CommandCompleteDirForAction#setup('ScratchRead', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('ScratchReadFragment', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('ScratchReadSnip', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('ScratchSource', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'source',
\   'browsefilter': '*.vim',
\   'isIncludeSubdirs': 1
\})
":[N]ScratchNew [{dir}|{filename} |{filespec}]
"			Create a |:new| buffer in the default g:scratchDirspec,
"			or passed {dir}, or passed {filename} (in
"			g:scratchDirspec), or passed {filespec}. Any changes
"			won't be persisted and be automatically discarded unless
"			|:ScratchWrite| is used.
":[N]ScratchCreate [{dir}|{filename} |{filespec}]
"			Create a |:new| buffer in the default g:scratchDirspec,
"			or passed {dir}, or passed {filename} (in
"			g:scratchDirspec), or passed {filespec}. This creates a
"			normal buffer where changes have to be persisted with
"			|:w| or discarded with |:bd|!.
":ScratchSave[!]  [{dir}|{filename} |{filespec}]
":[range]ScratchWrite[!] [{dir}|{filename} |{filespec}]
"			Persist a (scratch, or any) buffer to the default
"			g:scratchDirspec, or passed {dir} (with the buffer's
"			filename), or passed {filename} (in g:scratchDirspec),
"			or passed {filespec} (if possible, inside
"			g:scratchDirspec).
"			:ScratchSave converts the scratch buffer to a "normal"
"			buffer, which can subsequently be saved via :w.
"			With :ScratchWrite, the scratch buffer keeps its
"			"scratchiness", and can be updated, toggled, ... with
"			the usual commands. Subsequent saves must be done with
"			:ScratchWrite, too.
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchNew       if ! SpecialFileLocations#Scratch#New(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchCreate    if ! SpecialFileLocations#Scratch#Create(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchSave      if ! SpecialFileLocations#Scratch#Save(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchWrite     if ! SpecialFileLocations#Scratch#Write(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
":ScratchIt		Turn the current buffer into a scratch buffer; that
"			means any edits need not be persisted when closing the
"			buffer / Vim. :ScratchSave will undo this and persist
"			the buffer.
":ScratchIt {cmd}	Execute {cmd} and turn the current buffer into a scratch
"			buffer. Useful to :PrettyPrint a buffer and then leave
"			it alone.
command! -nargs=* -complete=command ScratchIt if !empty(<q-args>)&&!&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>if ! SpecialFileLocations#Scratch#It(<q-args>) | echoerr ingo#err#Get() | endif


if ! exists('g:inboxDirspec')
    let g:inboxDirspec = 'O:\inbox'
    if ! isdirectory(g:inboxDirspec)
	let g:inboxDirspec = ingo#fs#path#Combine($HOME, 'inbox')
    endif
endif
if ! exists('g:inboxFilenameTemplate')
    let g:inboxFilenameTemplate = {
    \   'unnamed': 'untitled_%Y%m%d-%H%M%S',
    \   'named': '%%s_%Y%m%d-%H%M%S',
    \   'given': '%%s_%Y%m%d-%H%M%S',
    \}
endif
":InboxEdit {file}	Edit {file} from the default g:inboxDirspec.
":Inboxsplit {file}	Edit {file} in a split (above) buffer.
":InboxSplit {file}	Edit {file} in a split (below) buffer.
":InboxDrop {file}	Drop {file} from the default g:inboxDirspec.
":InboxRevert {file}	Revert the current buffer to the contents of {file}
"			from the default g:inboxDirspec.
":[line]InboxRead {file}
"			Read {file} from the default g:inboxDirspec.
":InboxSource {file}	Source {file} from the default g:inboxDirspec.
call CommandCompleteDirForAction#setup('InboxEdit', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('Inboxsplit',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('InboxSplit',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('InboxDrop', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('InboxRevert',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('InboxRead', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
call CommandCompleteDirForAction#setup('InboxSource', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'source',
\   'browsefilter': '*.vim',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Inbox#Complete'
\})
":[N]InboxNew [{dir}|{filename} |{filespec}]
"			Create a |:new| buffer in the default g:inboxDirspec,
"			or passed {dir}, or passed {filename} (in
"			g:inboxDirspec), or passed {filespec}.
":InboxSave[!]  [{dir}|{filename} |{filespec}]
":[range]InboxWrite[!] [{dir}|{filename} |{filespec}]
"			Persist a (inbox, or any) buffer to the default
"			g:inboxDirspec, or passed {dir} (with the buffer's
"			filename), or passed {filename} (in g:inboxDirspec),
"			or passed {filespec} (if possible, inside
"			g:inboxDirspec).
"			:InboxSave converts a scratch buffer to a "normal"
"			buffer, which can subsequently be saved via :w.
"			With :InboxWrite, the buffer keeps any potential
"			"scratchiness", and can be updated, toggled, ... with
"			the usual commands. Subsequent saves must be done with
"			:InboxWrite, too.
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxNew   if ! SpecialFileLocations#Scratch#Create(g:inboxFilenameTemplate, g:inboxDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxSave  if ! SpecialFileLocations#Scratch#Save(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxWrite if ! SpecialFileLocations#Scratch#Write(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif

":Logbook [{logbook}]	Open a chronological logbook file (ft=logbook) to read
"			or append an entry.
if ! exists('g:logbookDirspec')
    let g:logbookDirspec = ingo#fs#path#Combine($HOME, 'Dropbox', 'logbooks', '')
endif
if ! exists('g:logbookDefaultFilename')
    let g:logbookDefaultFilename = 'personal.txt'
endif
call CommandCompleteDirForAction#setup('Logbook', g:logbookDirspec, {
\   'isIncludeSubdirs': 1,
\   'defaultFilename': g:logbookDefaultFilename,
\   'postAction': 'if &l:filetype !=# "logbook" | setfiletype logbook | endif',
\   'browsefilter': '*.txt'
\})
":LogbookInstall [{hostname}]
"			Open the chronological installation logbook (ft=logbook)
"			for the passed or current host.
call CommandCompleteDirForAction#setup('LogbookInstall', ingo#fs#path#Combine(g:logbookDirspec, 'install', ''), {
\   'isIncludeSubdirs': 0,
\   'defaultFilename': tolower(hostname()) . '.txt',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Logbook#InstallLogbookFilename'),
\   'postAction': 'if &l:filetype !=# "logbook" | setfiletype logbook | endif',
\   'browsefilter': '*.txt'
\})

":Vim {vimfile}|{SID}	Quickly edit a ~/.vim/** file, .vimrc or .gvimrc, or the
"			script having {SID}.
let s:completeVimFunction = CommandCompleteDirForAction#setup('Vim',
\   get(filter(['~/Unixhome/.vim/', '~/.vim/', '~/vimfiles/'], 'isdirectory(expand(v:val))'), 0, './'),
\{
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Vimfiles#Complete',
\   'FilespecProcessingFunction': function('SpecialFileLocations#Vimfiles#CompleteProcessing')
\})

":Pack {package}/{vimfile}
"			Quickly edit a Vimscript from a package
"			(~/.vim/pack/*/start/**).
call CommandCompleteDirForAction#setup('Pack', function('SpecialFileLocations#Vimfiles#GetPackRootDirspecs'), {
\   'isIncludeSubdirs': 1
\})

":Packfile {vimfile}	Quickly edit a Vimscript from any package
"			(~/.vim/pack/**).
call CommandCompleteDirForAction#setup('Packfile', function('SpecialFileLocations#Vimfiles#GetPackDirspecs'), {
\   'isIncludeSubdirs': 1
\})

":VimRuntime {vimfile}	Quickly edit a $VIMRUNTIME/** file.
call CommandCompleteDirForAction#setup('VimRuntime', ingo#fs#path#Combine($VIMRUNTIME, ''), {
\   'isIncludeSubdirs': 1
\})


" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
