" SpecialFileLocations.vim: Various ways to access files from special locations.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo-library.vim plugin
"
" Copyright: (C) 2010-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	013	13-Dec-2020	Adapt: Move from Dropbox to Nextcloud.
"	012	01-Dec-2020	Also complete newest files first for :Logbook
"				and :LogbookInstall.
"	011	15-Mar-2020	:Vim needs 'isAllowOtherDirs' for ../.[g]vimrc
"				now because it now enforces that the location is
"				inside the base dir.
"	010	04-Mar-2020	FIX: Several FilenameProcessingFunction
"				definitions were missing (especially for :*Drop
"				commands).
"				ENH: Add :*Cd commands.
"	009	01-Mar-2020	Adapt: CommandCompleteDirForAction#setup() has
"				moved into ingo-library.
"	008	25-Oct-2018	Add :Testing... commands for access to files
"				frequently used for testing.
"	007	13-Sep-2018	Consistently define :...Fragment and :...Snip.
"				Add :U... commands for my Unixhome.
"	006	20-Jul-2018	On Windows, default for g:inboxDirspec should
"				consider I:\ (which would be mounted writable)
"				before (readonly) O:\inbox.
"	005	20-May-2018	ENH: Make :Inbox..., :Scratch... and :Temp...
"				accept numbered filename arguments and translate
"				them into the [count]'th newest file.
"	004	18-May-2018	Use new generic ingo#plugin#cmdcomplete#Make()
"				instead of
"				SpecialFileLocations#Inbox#Complete().
"				ENH: Perform newest-first sorting also for
"				:Temp... and :Scratch... commands; it's useful
"				there, too.
"	003	19-Apr-2018	Better default for g:inboxDirspec on Linux.
"	002	02-Mar-2018	Compatibility: Need to explicitly load Funcrefs
"				in Vim 7.0/1.
"	001	30-Oct-2017	file creation from ingocommands.vim

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SpecialFileLocations') || (v:version < 700)
    finish
endif
let g:loaded_SpecialFileLocations = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:tempDirspec')
    let g:tempDirspec = ingo#fs#tempfile#Make('')
endif
if ! exists('g:unixhomeDirspec')
    let g:unixhomeDirspec = ingo#fs#path#Combine($HOME, 'Unixhome')
endif
if ! exists('g:unixhomeFilenameTemplate')
    let g:unixhomeFilenameTemplate = {
    \   'unnamed': 'untitled_%Y%m%d-%H%M%S',
    \   'named': '%%s_%Y%m%d-%H%M%S',
    \   'given': '%%s_%Y%m%d-%H%M%S',
    \}
endif
if ! exists('g:testingDirspec')
    let g:testingDirspec = ingo#fs#path#Combine(g:unixhomeDirspec, 'testing')
endif
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
if ! exists('g:inboxDirspec')
    if ingo#os#IsWinOrDos()
	let g:inboxDirspec = 'I:\'

	if ! isdirectory(g:inboxDirspec)
	    let g:inboxDirspec = 'O:\inbox'
	endif
    else
	let g:inboxDirspec = ingo#fs#path#Combine($HOME, 'public', 'inbox')
    endif

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
if ! exists('g:logbookDirspec')
    let g:logbookDirspec = ingo#fs#path#Combine($HOME, 'cloud', 'logbooks', '')
endif
if ! exists('g:logbookDefaultFilename')
    let g:logbookDefaultFilename = 'personal.txt'
endif


"- commands --------------------------------------------------------------------

if v:version < 702
    " The Funcref doesn't trigger the autoload in older Vim versions.
    runtime autoload/SpecialFileLocations.vim
    runtime autoload/SpecialFileLocations/CdPath.vim
    runtime autoload/SpecialFileLocations/Inbox.vim
    runtime autoload/SpecialFileLocations/Logbook.vim
    runtime autoload/SpecialFileLocations/Root.vim
    runtime autoload/SpecialFileLocations/Scratch.vim
    runtime autoload/SpecialFileLocations/Temp.vim
    runtime autoload/SpecialFileLocations/Vimfiles.vim
endif

call ingo#plugin#cmdcomplete#dirforaction#setup('CCd', '', {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#DirComplete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CEdit', '', {
\   'action': 'edit',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete',
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Csplit', '', {
\   'action': function('SpecialFileLocations#Above'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CSplit', '', {
\   'action': function('SpecialFileLocations#Below'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CDrop', '', {
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CRevert', '', {
\   'action': 'Revert',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CRead', '', {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CReadFragment', '', {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CReadSnip', '', {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CSave', '', {
\   'commandAttributes': '-bang',
\   'action': 'saveas<bang>',
\   'defaultFilename': '%',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('CWrite', '', {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'FilenameProcessingFunction': function('SpecialFileLocations#CdPath#GlobLookup'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#CdPath#Complete'
\})



call ingo#plugin#cmdcomplete#dirforaction#setup('RootCd', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootEdit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Rootsplit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootSplit', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootDrop', function('SpecialFileLocations#Root#Dirspec'), {
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootRevert', function('SpecialFileLocations#Root#Dirspec'), {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootRead', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootReadFragment', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" ingo#fs#path#split#AtBasePath("%", SpecialFileLocations#Root#Dirspec())',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootReadSnip', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" ingo#fs#path#split#AtBasePath("%", SpecialFileLocations#Root#Dirspec())',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootSave', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-bang',
\   'action': 'saveas<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('RootWrite', function('SpecialFileLocations#Root#Dirspec'), {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})



let s:TempCompleteFuncref = SpecialFileLocations#Completions#MakeForNewestFirst(g:tempDirspec)
call ingo#plugin#cmdcomplete#dirforaction#setup('TempCd', g:tempDirspec, {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempEdit', g:tempDirspec, {
\   'action': 'edit',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Tempsplit',g:tempDirspec, {
\   'action': function('SpecialFileLocations#Above'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempSplit',g:tempDirspec, {
\   'action': function('SpecialFileLocations#Below'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempDrop', g:tempDirspec, {
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempRevert',g:tempDirspec, {
\   'action': 'Revert',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempRead', g:tempDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempReadFragment', g:tempDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempReadSnip', g:tempDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TempSave', g:tempDirspec, {
\   'commandAttributes': '-bang',
\   'action': function('SpecialFileLocations#Temp#Save'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#NewestFileProcessing'),
\   'defaultFilename': '',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
" Note: We cannot use SpecialFileLocations#Scratch#Write() here, as there's no way to pass on the
" range. The only bit of functionality that we lose is the clearing of the name
" of an unnamed buffer.
call ingo#plugin#cmdcomplete#dirforaction#setup('TempWrite', g:tempDirspec, {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'defaultFilename': '%',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Temp#Filename'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:TempCompleteFuncref
\})
unlet! s:TempCompleteFuncref



call ingo#plugin#cmdcomplete#dirforaction#setup('TestingCd', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingEdit', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Testingsplit', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingSplit', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingDrop', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingSave', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'commandAttributes': '-bang',
\   'action': 'saveas<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingWrite', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'commandAttributes': '-bang -range=%',
\   'action': '<line1>,<line2>write<bang>',
\   'defaultFilename': '%',
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('TestingYank', ingo#fs#path#Combine(g:testingDirspec, ''), {
\   'action': function('SpecialFileLocations#Yank'),
\   'isIncludeSubdirs': 1
\})



let s:ScratchCompleteFuncref = SpecialFileLocations#Completions#MakeForNewestFirst(g:scratchDirspec, 1)
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchCd', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchEdit', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'edit',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Scratchsplit',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchSplit',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchDrop', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchRevert',ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'Revert',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'postAction': function('SpecialFileLocations#Scratch#MakeScratchy'),
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchRead', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchReadFragment', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchReadSnip', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('ScratchSource', ingo#fs#path#Combine(g:scratchDirspec, ''), {
\   'action': 'source',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Scratch#NewestFileProcessing'),
\   'browsefilter': '*.vim',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:ScratchCompleteFuncref
\})
execute 'command! -bar -count=0          -nargs=? -complete=customlist,' . s:ScratchCompleteFuncref "ScratchNew       if ! SpecialFileLocations#Scratch#New(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif"
execute 'command! -bar -count=0          -nargs=? -complete=customlist,' . s:ScratchCompleteFuncref "ScratchCreate    if ! SpecialFileLocations#Scratch#Create(g:scratchFilenameTemplate, g:scratchDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif"
execute 'command! -bar -bang             -nargs=? -complete=customlist,' . s:ScratchCompleteFuncref "ScratchSave      if ! SpecialFileLocations#Scratch#Save(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif"
execute 'command! -bar -bang    -range=% -nargs=? -complete=customlist,' . s:ScratchCompleteFuncref "ScratchWrite     if ! SpecialFileLocations#Scratch#Write(g:scratchFilenameTemplate, g:scratchDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif"
command! -nargs=* -complete=command ScratchIt if !empty(<q-args>)&&!&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>if ! SpecialFileLocations#Scratch#It(<q-args>) | echoerr ingo#err#Get() | endif
execute 'command! -bar                   -nargs=? -complete=customlist,' . s:ScratchCompleteFuncref 'Unscratch        if ! SpecialFileLocations#Scratch#Unscratch(g:scratchFilenameTemplate, g:scratchDirspec, <q-args>) | echoerr ingo#err#Get() | endif'
unlet! s:ScratchCompleteFuncref



call ingo#plugin#cmdcomplete#dirforaction#setup('UCd', ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('UEdit', ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': 'edit',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Usplit',ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('USplit',ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('UDrop', ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('URevert',ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': 'Revert',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('URead', ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('UReadFragment', g:unixhomeDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('UReadSnip', g:unixhomeDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('USource', ingo#fs#path#Combine(g:unixhomeDirspec, ''), {
\   'action': 'source',
\   'browsefilter': '*.vim',
\   'isIncludeSubdirs': 1,
\})
command! -bar -count=0          -nargs=? UNew   if ! SpecialFileLocations#Scratch#Create(g:unixhomeFilenameTemplate, g:unixhomeDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? USave  if ! SpecialFileLocations#Scratch#Save(g:unixhomeFilenameTemplate, g:unixhomeDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? UWrite if ! SpecialFileLocations#Scratch#Write(g:unixhomeFilenameTemplate, g:unixhomeDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif



let s:InboxCompleteFuncref = SpecialFileLocations#Completions#MakeForNewestFirst(g:inboxDirspec)
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxCd', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'chdir',
\   'isIncludeSubdirs': 1,
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxEdit', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'edit',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Inboxsplit',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': function('SpecialFileLocations#Above'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxSplit',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': function('SpecialFileLocations#Below'),
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxDrop', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxRevert',ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'Revert',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxRead', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxReadFragment', g:inboxDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Fragment" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxReadSnip', g:inboxDirspec, {
\   'commandAttributes': '-range=-1',
\   'action': '<line1>read % | execute "Snip" "%:t"',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('InboxSource', ingo#fs#path#Combine(g:inboxDirspec, ''), {
\   'action': 'source',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Inbox#NewestFileProcessing'),
\   'browsefilter': '*.vim',
\   'isIncludeSubdirs': 1,
\   'overrideCompleteFunction': s:InboxCompleteFuncref
\})
command! -bar -count=0          -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxNew   if ! SpecialFileLocations#Scratch#Create(g:inboxFilenameTemplate, g:inboxDirspec, <count>, ingo#compat#command#Mods('<mods>'), <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang             -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxSave  if ! SpecialFileLocations#Scratch#Save(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang    -range=% -nargs=? -complete=customlist,SpecialFileLocations#Inbox#Complete InboxWrite if ! SpecialFileLocations#Scratch#Write(g:inboxFilenameTemplate, g:inboxDirspec, '<bang>', '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
unlet! s:InboxCompleteFuncref



let s:LogbookCompleteFuncref = SpecialFileLocations#Completions#MakeForNewestFirst(g:logbookDirspec)
call ingo#plugin#cmdcomplete#dirforaction#setup('Logbook', g:logbookDirspec, {
\   'isIncludeSubdirs': 1,
\   'defaultFilename': g:logbookDefaultFilename,
\   'postAction': 'if &l:filetype !=# "logbook" | setfiletype logbook | endif',
\   'browsefilter': '*.txt',
\   'overrideCompleteFunction': s:LogbookCompleteFuncref
\})
let s:LogbookInstallCompleteFuncref = SpecialFileLocations#Completions#MakeForNewestFirst(ingo#fs#path#Combine(g:logbookDirspec, 'install', ''))
call ingo#plugin#cmdcomplete#dirforaction#setup('LogbookInstall', ingo#fs#path#Combine(g:logbookDirspec, 'install', ''), {
\   'isIncludeSubdirs': 0,
\   'defaultFilename': tolower(hostname()) . '.txt',
\   'FilenameProcessingFunction': function('SpecialFileLocations#Logbook#InstallLogbookFilename'),
\   'postAction': 'if &l:filetype !=# "logbook" | setfiletype logbook | endif',
\   'browsefilter': '*.txt',
\   'overrideCompleteFunction': s:LogbookInstallCompleteFuncref
\})



let g:SpecialFileLocations#Vimfiles#completeVimFunction = ingo#plugin#cmdcomplete#dirforaction#setup('Vim',
\   get(filter(['~/Unixhome/.vim/', '~/.vim/', '~/vimfiles/'], 'isdirectory(expand(v:val))'), 0, './'),
\{
\   'isIncludeSubdirs': 1,
\   'isAllowOtherDirs': 1,
\   'overrideCompleteFunction': 'SpecialFileLocations#Vimfiles#Complete',
\   'FilespecProcessingFunction': function('SpecialFileLocations#Vimfiles#CompleteProcessing')
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Pack', function('SpecialFileLocations#Vimfiles#GetPackRootDirspecs'), {
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('Packfile', function('SpecialFileLocations#Vimfiles#GetPackDirspecs'), {
\   'isIncludeSubdirs': 1
\})
call ingo#plugin#cmdcomplete#dirforaction#setup('VimRuntime', ingo#fs#path#Combine($VIMRUNTIME, ''), {
\   'isIncludeSubdirs': 1
\})


" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
