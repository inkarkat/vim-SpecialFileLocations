SPECIAL FILE LOCATIONS
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin ...

### SOURCE
(Original Vim tip, Stack Overflow answer, ...)

### SEE ALSO
(Plugins offering complementary functionality, or plugins using this library.)

### RELATED WORKS
(Alternatives from other authors, other approaches, references not used here.)

USAGE
------------------------------------------------------------------------------

    :CCd {dir}              Change the current directory to {dir} ...
    :CEdit {file}           Edit {file} ...
    :Csplit {file}          Edit {file} in a split (above) buffer...
    :CSplit {file}          Edit {file} in a split (below) buffer...
    :CDrop {file}           Drop {file} ...
    :CRevert {file}         Revert the current buffer to the contents of {file} ...

    :[line]CRead {file}     Read {file} ...
                            ... from one of the 'cdpath' directories.
    :[line]CReadFragment {file}
                            :CRead and insert fragment formatting around the read
                            contents.
    :[line]CReadSnip {file}
                            :CRead and insert snip formatting around the read
                            contents.
    :CSave[!] [{file}]
    :[range]CWrite[!] [{file}]

    :RootCd {dir}           Change the current directory to project {dir} ...
    :RootEdit {file}        Edit project {file} ...
    :Rootsplit {file}       Edit project {file} in a split (above) buffer...
    :RootSplit {file}       Edit project {file} in a split (below) buffer...
    :RootDrop {file}        Drop project {file} ...
    :RootRevert {file}      Revert the current buffer to the contents of {file} ...

    :[line]RootRead {file}  Read project {file} ...
                            ... from the project root or one of its
                            subdirectories.
    :[line]RootReadFragment {file}
                            :RootRead and insert fragment formatting around the
                            read contents.
    :[line]RootReadSnip {file}
                            :RootRead and insert snip formatting around the
                            read contents.
    :RootSave[!] [{file}]
    :[range]RootWrite[!] [{file}]
                            Persist buffer to the project root or one of its
                            subdirectories.

    :TempCd {dir}           Change the current directory to {dir} ...
    :TempEdit {file}|N      Edit {file} (or the N'th newest file (subdirectories
                            are not counted)) ...
    :Tempsplit {file}|N     Edit {file} in a split (above) buffer...
    :TempSplit {file}|N     Edit {file} in a split (below) buffer...
    :TempDrop {file}|N      Drop {file} ...
    :TempRevert {file}|N    Revert the current buffer to the contents of {file} ...

    :[line]TempRead {file}|N        Read {file} ...
                            ... from the temp directory or one of its
                            subdirectories.
    :[line]TempReadFragment {file}|N
                            :TempRead and insert fragment formatting around the
                            read contents.
    :[line]TempReadSnip {file}|N
                            :TempRead and insert snip formatting around the read
                            contents.
    :TempSave[!] [{file}|N]
    :[range]TempWrite[!] [{file}|N]
                            Persist buffer to the temp directory or one of its
                            subdirectories.

    :Testing Cd {dir}       Change the current directory to testing {dir} ...
    :TestingEdit {file}     Edit testing {file} ...
    :Testingsplit {file}    Edit testing {file} in a split (above) buffer...
    :TestingSplit {file}    Edit testing {file} in a split (below) buffer...
    :TestingDrop {file}     Drop testing {file} ...
                            ... from the testing directory or one of its
                            subdirectories.

    :TestingSave[!] [{file}]
    :[range]TestingWrite[!] [{file}]
                            Persist buffer as a testing file.

    :TestingYank [{file}]   Yank the filespec of testing {file} into both default
                            register and the system clipboard.

    :ScratchCd {dir}        Change the current directory to {dir} ...
    :ScratchEdit {file}|N   Edit {file} (or the N'th newest file (subdirectories
                            are not counted)) ...
    :Scratchsplit {file}|N  Edit {file} in a split (above) buffer...
    :ScratchSplit {file}|N  Edit {file} in a split (below) buffer...
    :ScratchDrop {file}|N   Drop {file} ...
    :ScratchRevert {file}|N Revert the current buffer to the contents of {file} ...
                            ... from the default g:scratchDirspec.

    :[line]ScratchRead {file}|N
                            Read {file} from the default g:scratchDirspec.
    :[line]ScratchReadFragment {file}|N
                            :ScratchRead and insert fragment formatting around the
                            read contents.
    :[line]ScratchReadSnip {file}|N
                            :ScratchRead and insert snip formatting around the
                            read contents.

    :ScratchSource {file}|N Source {file} from the default g:scratchDirspec.
    :[N]ScratchNew [{dir}|{filename} |{filespec}]
                            Create a :new buffer in the default g:scratchDirspec,
                            or passed {dir}, or passed {filename} (in
                            g:scratchDirspec), or passed {filespec}. Any changes
                            won't be persisted and be automatically discarded
                            unless :ScratchWrite is used.
    :[N]ScratchCreate [{dir}|{filename} |{filespec}]
                            Create a :new buffer in the default g:scratchDirspec,
                            or passed {dir}, or passed {filename} (in
                            g:scratchDirspec), or passed {filespec}. This creates
                            a normal buffer where changes have to be persisted
                            with :w or discarded with :bd!.

    :ScratchSave[!]  [{dir}|{filename} |{filespec} |N]
    :[range]ScratchWrite[!] [{dir}|{filename} |{filespec} |N]
                            Persist a (scratch, or any) buffer to the default
                            g:scratchDirspec, or passed {dir} (with the buffer's
                            filename), or passed {filename} (in g:scratchDirspec,
                            unless it's prepended with "./"), or passed {filespec}
                            (if possible, inside g:scratchDirspec).
                            :ScratchSave converts the scratch buffer to a "normal"
                            buffer, which can subsequently be saved via :w.
                            With :ScratchWrite, the scratch buffer keeps its
                            "scratchiness", and can be updated, toggled, ... with
                            the usual commands. Subsequent saves must be done with
                            :ScratchWrite, too.

    :ScratchIt              Turn the current buffer into a scratch buffer; that
                            means any edits need not be persisted when closing the
                            buffer / Vim. :ScratchSave will undo this and persist
                            the buffer.
    :ScratchIt {cmd}        Execute {cmd} and turn the current buffer into a
                            scratch buffer. Useful to :PrettyPrint a buffer and
                            then leave it alone.
    :Unscratch [{dir}|{filename} |{filespec}]
                            Turn a scratch buffer into a "normal" buffer by
                            removing any [Scratch] appendix from the buffer name
                            (or renaming to {filename}), and clearing scratchy
                            buffer options like 'buftype', 'bufhidden', etc.
                            Like :ScratchSave without the saving.

    :UCd {dir}              Change the current directory to {dir} ...
    :UEdit {file}|N         Edit {file} (or the N'th newest file (subdirectories
                            are not counted)) ...
    :Usplit {file}|N        Edit {file} in a split (above) buffer...
    :USplit {file}|N        Edit {file} in a split (below) buffer...
    :UDrop {file}|N         Drop {file} ...
    :URevert {file}|N       Revert the current buffer to the contents of {file}
                            ... from the default g:unixhomeDirspec.

    :[line]URead {file}|N
                            Read {file} from the default g:unixhomeDirspec.
    :[line]UReadFragment {file}|N
                            :URead and insert fragment formatting around the read
                            contents.
    :[line]UReadSnip {file}|N
                            :URead and insert snip formatting around the read
                            contents.
    :USource {file}|N       Source {file} from the default g:unixhomeDirspec.
    :[N]UNew [{dir}|{filename} |{filespec}]
                            Create a :new buffer in the default g:unixhomeDirspec,
                            or passed {dir}, or passed {filename} (in
                            g:unixhomeDirspec), or passed {filespec}.

    :USave[!]  [{dir}|{filename} |{filespec} |N]
    :[range]UWrite[!] [{dir}|{filename} |{filespec} |N]
                            Persist a (Unixhome, or any) buffer to the default
                            g:unixhomeDirspec, or passed {dir} (with the buffer's
                            filename), or passed {filename} (in g:unixhomeDirspec,
                            unless it's prepended with "./"), or passed {filespec}
                            (if possible, inside g:unixhomeDirspec).

    :MediaCd {dir}          Change the current directory to {dir} ...
    :MediaEdit {file}|N     Edit {file} (or the N'th newest file (subdirectories
                            are not counted)) ...
    :Mediasplit {file}|N    Edit {file} in a split (above) buffer...
    :MediaSplit {file}|N    Edit {file} in a split (below) buffer...
    :MediaDrop {file}|N     Drop {file} ...
    :MediaRevert {file}|N   Revert the current buffer to the contents of {file}
                            ... from a mounted medium.

    :[line]MediaRead {file}|N
                            Read {file} from a mounted medium.
    :[line]MediaReadFragment {file}|N
                            :MediaRead and insert fragment formatting around the
                            read contents.
    :[line]MediaReadSnip {file}|N
                            :MediaRead and insert snip formatting around the read
                            contents.
    :MediaSource {file}|N   Source {file} from a mounted medium.

    :InboxCd {dir}          Change the current directory to {dir} ...
    :InboxEdit {file}|N     Edit {file} (or the N'th newest file (subdirectories
                            are not counted)) ...
    :Inboxsplit {file}|N    Edit {file} in a split (above) buffer...
    :InboxSplit {file}|N    Edit {file} in a split (below) buffer...
    :InboxDrop {file}|N     Drop {file} ...
    :InboxRevert {file}|N   Revert the current buffer to the contents of {file}
                            ... from the default g:inboxDirspec.

    :[line]InboxRead {file}|N
                            Read {file} from the default g:inboxDirspec.
    :[line]InboxReadFragment {file}|N
                            :InboxRead and insert fragment formatting around the
                            read contents.
    :[line]InboxReadSnip {file}|N
                            :InboxRead and insert snip formatting around the
                            read contents.
    :InboxSource {file}|N   Source {file} from the default g:inboxDirspec.
    :[N]InboxNew [{dir}|{filename} |{filespec}]
                            Create a :new buffer in the default g:inboxDirspec,
                            or passed {dir}, or passed {filename} (in
                            g:inboxDirspec), or passed {filespec}.

    :InboxSave[!]  [{dir}|{filename} |{filespec} |N]
    :[range]InboxWrite[!] [{dir}|{filename} |{filespec} |N]
                            Persist a (inbox, or any) buffer to the default
                            g:inboxDirspec, or passed {dir} (with the buffer's
                            filename), or passed {filename} (in g:inboxDirspec,
                            unless it's prepended with "./"), or passed {filespec}
                            (if possible, inside g:inboxDirspec).

    :Logbook [{logbook}]    Open a chronological logbook file (ft=logbook) to read
                            or append an entry.
    :LogbookInstall [{hostname}]
                            Open the chronological installation logbook
                            (ft=logbook) for the passed or current host.

    :Vim {vimfile}|{SID}    Quickly edit a ~/.vim/** file, .vimrc or .gvimrc, or
                            the script having {SID}.
    :Pack {package}/{vimfile}
                            Quickly edit a Vimscript from a package
                            (~/.vim/pack/*/start/**).
    :Packfile {vimfile}     Quickly edit a Vimscript from any package
                            (~/.vim/pack/**).
    :VimRuntime {vimfile}   Quickly edit a $VIMRUNTIME/** file.
                            Persist buffer into one of the 'cdpath' directories.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-SpecialFileLocations
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim SpecialFileLocations*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.041 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

The directory location for scratch files.

Template for scratch filenames. It consists of a Dictionary with these keys:

    let g:scratchFilenameTemplate = {
    \   'unnamed': 'untitled_%Y%m%d-%H%M%S',
    \   'named': '%%s',
    \   'given': '%%s',
    \}

The "unnamed" entry is taken for unnamed buffers, the "named" one for buffers
that already have a name, the "given" for when a name is supplied to the
:Scratch... command. Each is first passed to strftime(); the result then to
printf().

The directory location for inbox files.

Template for inbox filenames. See g:scratchFilenameTemplate for details.

The directory location for logbooks.

The default logbook when no arguments are supplied to :Logbook.

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-SpecialFileLocations/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### GOAL
First published version.

##### 0.90    31-Oct-2017
- Split off into separate plugin.

##### 0.01    05-Feb-2010
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2010-2021 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
