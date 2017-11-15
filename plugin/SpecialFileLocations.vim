" SpecialFileLocations.vim: Various ways to access files from special locations.
"
" DEPENDENCIES:
"   - CommandCompleteDirForAction.vim autoload script
"   - SpecialFileLocations/*.vim autoload scripts
"   - ingo/compat/command.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/fs/path/split.vim autoload script
"   - ingo/fs/tempfile.vim autoload script
"
" Copyright: (C) 2010-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	30-Oct-2017	file creation from ingocommands.vim

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SpecialFileLocations') || (v:version < 700)
    finish
endif
let g:loaded_SpecialFileLocations = 1


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
" Note: We cannot use SpecialFileLocations#Scratch#Write() here, as there's no way to pass on the
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
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchNew       if ! SpecialFileLocations#Scratch#New(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchCreate    if ! SpecialFileLocations#Scratch#Create(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchSave      if ! SpecialFileLocations#Scratch#Save(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? -complete=customlist,SpecialFileLocations#Scratch#Complete ScratchWrite     if ! SpecialFileLocations#Scratch#Write(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
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
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxNew   if ! SpecialFileLocations#Scratch#Create(g:inboxFilenameTemplate, g:inboxDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxSave  if ! SpecialFileLocations#Scratch#Save(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxWrite if ! SpecialFileLocations#Scratch#Write(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif



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
call CommandCompleteDirForAction#setup('LogbookInstall', ingo#fs#path#Combine(g:logbookDirspec, 'install', ''), {
\   'isIncludeSubdirs': 0,
\   'defaultFilename': tolower(hostname()) . '.txt',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Logbook#InstallLogbookFilename'),
\   'postAction': 'if &l:filetype !=# "logbook" | setfiletype logbook | endif',
\   'browsefilter': '*.txt'
\})



let SpecialFileLocations#Vimfiles#completeVimFunction = CommandCompleteDirForAction#setup('Vim',
\   get(filter(['~/Unixhome/.vim/', '~/.vim/', '~/vimfiles/'], 'isdirectory(expand(v:val))'), 0, './'),
\{
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Vimfiles#Complete',
\   'FilespecProcessingFunction': function('SpecialFileLocations#Vimfiles#CompleteProcessing')
\})
call CommandCompleteDirForAction#setup('Pack', function('SpecialFileLocations#Vimfiles#GetPackRootDirspecs'), {
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('Packfile', function('SpecialFileLocations#Vimfiles#GetPackDirspecs'), {
\   'isIncludeSubdirs': 1
\})
call CommandCompleteDirForAction#setup('VimRuntime', ingo#fs#path#Combine($VIMRUNTIME, ''), {
\   'isIncludeSubdirs': 1
\})


" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
