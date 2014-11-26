<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

- [awf - a CLI for managing Alfred workflows](#awf---a-cli-for-managing-alfred-workflows)
  - [Installation](#installation)
    - [Manual Installation](#manual-installation)
  - [Usage](#usage)
  - [Changelog](#changelog)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# awf - a CLI for managing Alfred workflows

`awf` (*A*lfred *W*ork*f*low) is a helper CLI for OS X users who frequently develop workflows for command-line launcher [Alfred](http://alfredapp.com).

## Installation

### Manual Installation

* Clone this repository locally.
* Copy `bin/awf` to a folder in your `$PATH`, e.g.:

        cp bin/awf /usr/local/bin/

## Usage

```shell
$ awf help all

SYNOPSIS
  awf list|ls [-b] [-o fieldIdChars] [[-s fieldIdChars] [-x|-r] searchTerm]
    Lists installed workflows, optionally with custom output and filtering.
  awf search          [searchTerm]
    Searches for workflows in the Alfred Preferences application.

  awf info [-b] [-o fieldIdChars] [wfFolderOrBundleID]
    Prints a workflow's metadata, optionally with selectable output fields.
  awf id              [wfFolder]
    Prints the bundle ID of a workflow.
  awf which [-l|-P] [-R]          [wfDevFolderOrBundleID]
    Prints the full path to an installed workflow's folder.    
  awf reveal [-P]     [wfDevFolderOrBundleID]
    Reveals an installed workflow's folder in Finder.

  awf cd [-P]         [wfFolderOrBundleID]
    Changes to an installed workflow's folder in a new Terminal window.
  awf edit            [wfFolderOrBundleID]
    Opens a workflow for editing in the Alfred Preferences application.

  awf install         [wfDevFolder]
    Installs a workflow from a dev folder.
  awf export  [-R]    [wfFolder [outFolder]]
    Exports a workflow to an *.alfredworkflow ZIP archive.

  awf link|ln [-f]    [wfDevFolder]
    Symlinks a dev workflow into the folder of installed workflows.
  awf unlink|unln     [wfFolderOrBundleID]
    Removes a symlink to a dev workflow from the folder of installed ones.
  awf prune
    Removes dead symlinks from the folder of installed workflows.
  awf todev [-R]      [wfInstalledFolderOrBundleID [wfDevFolder]]
    Converts an installed workflow to a dev workflow.
  awf fromdev [-k]    [wfDevFolder]
    Converts a dev workflow to a regular installed workflow.
  awf version [-f] [wfFolderOrBundleId [newVersion|'major|'minor'|'patch']]
    Prints or assigns a workflow's version number.

  awf help [command | 'all']  # or: awf command -h
    Prints help information.

DESCRIPTION
  Performs various operations related to Alfred 2 workflows.
  (To learn about Alfred, go to http://alfredapp.com)

  To get help for a specific command, use `awf help <command>`
  or `awf <command> -h`.
  
  WFDEVFOLDER is a folder path containing an Alfred workflow
   *dev* (development) project, in a *separate location* from and
   and typically symlinked into the folder hosting all installed
   workflows.
  
  WFINSTALLEDFOLDER is a path to a workflow folder among the
   *installed* workflows.
  
  WFFOLDER can be either a dev or an installed workflow folder.
  
  Generally, not specifying a folder (or bundle ID) defaults to the current
  folder.

  In commands where a bundle ID can be specified to target a workflow, only
  *installed* workflows are searched for said bundle ID.


~~~
  awf list|ls [-b] [-o fieldIdChars] [[-s fieldIdChars] [-x|-r] searchTerm]
    Lists installed workflows, optionally with custom output and filtering.

DESCRIPTION
  Lists metadata for *installed* workflows.

  To override the default output fields, use -o with a string of
  field-identifier characters (see below).
  Default output field IDs are:
    nic
  
  Sorting is invariably based on the first output field.
  Note: Due to limitations in OS X's `sort` utility, the current
        locale is ignored (the "C" locale is used).

  Unless you specify -b, a header is printed and an attempt is made to
  align columns using spaces; note, however, that due to unpredictable
  field lengths the alignment will not always work as intended.

  You can filter the output by specifying a search term:
  Scope:
    By default, only the name field is searched.
    Use -s with field IDs to determine what field(s) to search instead.
    Search fields do not have to be output fields too.
  Method:
    By default, literal substring matching is used - see options below
    for alternative methods.
  Case:
    Matching is case-INsensitive, regardless of matching method.

  -b
    Bare output; suppresses the header and separates output fields by a
    tab each, suitable for automated processing.

  -o outputFieldIdChars
  -s searchFieldIdChars
    Selects the desired output/searchs fields in order, using the following
    single-character identifiers in any order, with no separator:
    id  field name      comment
    --  ----------      -------
    p   installpath     # path where installed
    l   devpath         # dev path (linked-to)
    a   disabled        # workflow currently disabled?
    i   bundleid        
    n   name            
    d   description     
    c   category        
    b   createdby       
    w   webaddress      
    r   readme          # single-line, with escapes

  -x
    Exact matching; the search term must match (one of) the specified or
    implied search field(s) literally and in full.

  -r
    Regex matching; the search term is interpreted as an extended
    regular expressions; to match (one of) the field(s) in full, anchor with
    '^...$'

EXAMPLES
    # List all installed workflows:
  awf ls
    # List all installed workflows whose name contains 'chrome'
    # by name and description:
  awf ls -o nd chrome
      # List all disabled workflows by name:
  awf ls -o n -s a true
    # List name and bundle ID of workflows whose bundle ID starts with
    # 'net.same2u.':
  awf ls -o ni -s i -r '^net\.same2u\.'

~~~
  awf search          [searchTerm]
    Searches for workflows in the Alfred Preferences application.

DESCRIPTION
  Searches for workflows by opening the Workflows tab in the
  Alfred Preferences application and pasting the search term there.

  NOTE: Since this command uses GUI scripting, the application executing
  this utility - typically Terminal.app - must be authorized for assistive
  access (System Preferences > Security & Privacy > Privacy > Accessibility).

  The search term can be:
   - the prefix of a word or phrase contained in workflow names
   - the prefix of workflows' keywords
   - a substring of a hotkey representation
  Matching is always case-INsensitive.

  To match a hotkey representation, you must use the correct modifier-key
  symbols:
    ⌃ ... Control
    ⌥ ... Option
    ⌘ ... Command
    ⇧ ... Shift
  Caveat: Only exact substrings of the hotkey representations can be
          be matched, so that ⌥⌘V can be found via ⌘V, but not ⌥V.

EXAMPLES
    # Search for workflows containing 'vm'
  awf search vm
    # Search for workflows whose hotkey representations contain
    # the key combination Command-C
  awf search ⌘c

~~~
  awf info [-b] [-o fieldIdChars] [wfFolderOrBundleID]
    Prints a workflow's metadata, optionally with selectable output fields.

DESCRIPTION
  Prints information (metadata) about a workflow, mostly extracted from the
  Info.plist file. The workflow can be specified either by bundle ID
  or folder path.

  Each field value is printed on its own line, preceded by the field name.
  To suppress the field name, use -b.
  
  To override the default output fields, use -o with a string of
  field-identifier characters (see below).
  Default output field IDs are:
    plaindcbwr

  -b
    Bare output; omits the field names.

  -o fieldIdChars
    Selects the desired output fields in order using the following
    single-character identifiers in any order, with no separator:
    id  field name      comment
    --  ----------      -------
    p   installpath     # path where installed
    l   devpath         # dev path (linked-to)
    a   disabled        # workflow currently disabled?
    i   bundleid        
    n   name            
    d   description     
    c   category        
    b   createdby       
    w   webaddress      
    r   readme          # single-line, with escapes

EXAMPLES
    # Print metadata for workflow in current folder:
  awf info  
    # Print name and bundleID fields without field names for
    # workflow with bundle ID 'net.same2u.alfw.StringLength':
  awf info -b -o ni net.same2u.alfw.StringLength

~~~
  awf id              [wfFolder]
    Prints the bundle ID of a workflow.

DESCRIPTION
  Prints the bundle ID of a workflow specified by its folder path.
  Omitting the folder path targets the current folder.

EXAMPLES
    # Print the bundle ID of the workflow in the specified folder:
  awf id ~/Projects/Alfred/StringLength

~~~
  awf which [-l|-P] [-R]          [wfDevFolderOrBundleID]
    Prints the full path to an installed workflow's folder.    

DESCRIPTION
  Prints the full path to the specified workflow's folder among the
  *installed* workflows by default; the workflow can be specified either
  by bundle ID or [dev] folder path.

  As a special case, you may specify '/' to print the *root* folder of
  all installed workflows.

  -l
    If the installed-workflow folder is a symlink - i.e., has an underlying
    dev folder - the symlink's target is also printed, `ls -l`-style
    ('a@ -> b')

  -P
    If the installed-workflow folder is a symlink - i.e., has an underlying
    dev folder - only the dev folder's path is printed.

  -R
    In addition to printing its path, reveals the folder in Finder.

EXAMPLES
    # Print the installed location (only) of the dev workflow stored
    # in the current folder:
  awf which -b
    # Print the installed location and, if applicable, the underlying
    # dev location of the workflow with the specified bundle ID:
  awf which net.same2u.alfw.StringLength

~~~
  awf reveal [-P]     [wfDevFolderOrBundleID]
    Reveals an installed workflow's folder in Finder.

DESCRIPTION
  Reveals the specified workflow's folder in Finder among the *installed*
  workflows; the workflow can be specified either by bundle ID or
  dev folder path.

  As a special case, you may specify '/' to reveal the *root* folder of
  all installed workflows.

  This is effectively a shortcut to `awf which -R`, except that the folder path
  is not also printed to stdout.  

EXAMPLES
    # Reveal the location of the workflow with the specified bundle ID
    # in Finder:
  awf reveal net.same2u.alfw.StringLength

~~~
  awf cd [-P]         [wfFolderOrBundleID]
    Changes to an installed workflow's folder in a new Terminal window.

DESCRIPTION
  Opens a new Terminal window and makes the specified workflow's 
  installed folder the current folder.

  As a special case, you may specify '/' to change to the *root* folder of
  all installed workflows.

  -P
    If the workflow is symlinked to a dev folder, the underlying dev folder
    is changed to, not the symlinked path among the installed workflows.

  Note: Since this script cannot change the current shell's working folder,
        a new shell in a new Terminal window must be opened.

EXAMPLES
    # Open a new Terminal window and change to the folder of the
    # (installed) workflow with the specified bundle ID:
  awf cd net.same2u.alfw.StringLength

~~~
  awf edit            [wfFolderOrBundleID]
    Opens a workflow for editing in the Alfred Preferences application.

DESCRIPTION
  Opens a workflow specified by folder path or bundle ID for editing in
  the Alfred Preferences application.

  As a special case you can specify '/' to merely open the Alfred
  Preferences application to the Workflows tab.

  NOTE: Since this command uses GUI scripting, the application executing
  this utility - typically Terminal.app - must be authorized for assistive
  access (System Preferences > Security & Privacy > Privacy > Accessibility).

  The workflow must be an installed one. While you may specify the path
  to a *dev* workflow, that workflow must currently be symlinked into
  Alfred's installed workflows.

  Note: For technical reasons, the target workflow must be located by
  its *name* in Alfred's Preferences, and names are not guaranteed to be
  unique. Thus, multiple workflows may match, and while the target workflow
  will be among them, it may not be the one that is the current selection
  in the UI.

~~~
  awf install         [wfDevFolder]
    Installs a workflow from a dev folder.

DESCRIPTION
  Installs (imports into Alfred) the specified dev workflow.
  Unlike the `link` command, this installs an independent copy
  of the dev workflow, and Alfred will strip hotkeys.
  Note that Alfred will display a GUI confirmation prompt.
  
  Behind the scenes, the target folder's contents are archived
  to a temporary *.alfredworkflow ZIP file and then opened in Alfred,
  triggering the installation (import).

  Note: Files matching the following patterns are excluded from
  the resulting archive:
    .* *.alfredworkflow

~~~
  awf export  [-R]    [wfFolder [outFolder]]
    Exports a workflow to an *.alfredworkflow ZIP archive.

DESCRIPTION
  Exports a workflow by creating an *.alfredworkflow ZIP
  archive for later installation (import).
  The archive is always created with the folder's name as the
  filename root of the archive, and placed in the workflow folder itself
  by default.

  -R
    reveals the resulting archive in Finder.

~~~
  awf link|ln [-f]    [wfDevFolder]
    Symlinks a dev workflow into the folder of installed workflows.

DESCRIPTION
  Symlinks a dev workflow folder into Alfred's installed workflows
  so as to allow direct use and modification of an in-development workflow.
  If the workflow has a bundle ID defined (which is recommended), there
  mustn't be an installed workflow with the same bundle ID. However, if
  that installed workflow's folder is the very same symlink about to be
  created, no error is reported and no action is performed.

  -f 
    Force creation of the symlink: If an installed workflow has the
    same bundle ID *and* its folder is also a symlink, forces replacement
    of the existing symlink.
    Useful after moving the dev folder to a different location or changing
    its name.

~~~
  awf unlink|unln     [wfFolderOrBundleID]
    Removes a symlink to a dev workflow from the folder of installed ones.

DESCRIPTION
  Removes a symlink to a dev workflow folder from among the installed
  workflow folders.
  The dev workflow may be specified directly as a dev workflow folder,
  indirectly as an installed workflow symlink, or even as a bundle ID.

~~~
  awf prune
    Removes dead symlinks from the folder of installed workflows.

DESCRIPTION
  Removes dead symlinks to dev workflow folders, if any, from among 
  the installed workflow folders.

~~~
  awf todev [-R]      [wfInstalledFolderOrBundleID [wfDevFolder]]
    Converts an installed workflow to a dev workflow.

DESCRIPTION
  Converts an installed workflow folder into a dev project
  by moving its contents to a dev folder, removing the installed folder,
  and then symlinking the dev folder into the folder of installed workflows,
  as with the `link` command.

  The workflow must be an installed, non-symlinked workflow - specified
  either by path or bundle ID - and the dev folder must either not exist
  yet (it is created on demand) or be empty.
  
  Not specifying a dev folder presents a GUI prompt for its creation.

  -R
    Reveals the newly created symlink in Finder.

~~~
  awf fromdev [-k]    [wfDevFolder]
    Converts a dev workflow to a regular installed workflow.

DESCRIPTION
  Converts a dev workflow to a regular installed workflow by
  moving its contents to a new folder among the installed workflows.

  Just like Alfred-created workflow folders, the new folder will be
  named 'user.workflow.{UUID}', i.e., its name will contain a randomly
  chosen unique component.

  -k
    Keeps the dev workflow folder; i.e., instead of *moving* its contents
    and then removing the folder, its contents is *copied*, and the folder
    and its contents are retained as is.
    Note that this will render the dev workflow folder a detached,
    independent copy of the newly installed workflow.

~~~
  awf version [-f] [wfFolderOrBundleId [newVersion|'major|'minor'|'patch']]
    Prints or assigns a workflow's version number.

DESCRIPTION
  Returns or sets a workflow's version number, optionally by inrementing
  a component of the current version number.

  The workflow may be specified by folder path or bundle ID; defaults is the
  current folder.
  
  Without specifying a new version, the workflow's current version is output.
  If there is none, the exit code is set to 2, and a warning is printed.

  Valid version numbers have 1-3 .-separated components, and each component
  must be composed of digits only. The component names are:
  major, minor, and patch.
  
  As an alternative to directly specifying a new version number, an
  increment specifier may be used.
  Supported increment specifiers are 'major', 'minor', 'patch', which
  increment (by 1) the respective version component of the current
  version number. A missing component is treated as 0.
  Any lower components are set as follows: the minor component is set to 0,
  the patch component is omitted.
  Caveat: any 0-padding of components is lost in the process.

  -f
    Forces updating the version number, even if the new version number is
    lower than the current one, or the current version number is invalid.

  A workflow's version number is by convention stored in a plain-text file
  named 'version' in the workflow's folder. The file must without exception
  contain a version number only, and the file must have 1 line only; no whitespace allowed.

EXAMPLES
    # Print version of the workflow in the current folder:
  awf version
    # Increment the patch component of the version number of the workflow
    # in the current folder (e.g., 0.5.1 -> 0.5.2)
  awf version . patch


~~~
  awf help [command | 'all']  # or: awf command -h
    Prints help information.

DESCRIPTION
  If no argument is specified: prints a brief overview of all commands and
  general information.

  If a command name is specified: prints detailed help specific to that 
  command.

  If 'all' is specified: prints both an overview and detailed help for
  ALL commands.

EXAMPLES
    # Print help overview only:
  awf help
    # Print help overview, followed by detailed help for all commands:
  awf help all
    # Print detailed help for the 'info' command.
  awf help info
  awf info -h  # same as above
```

## Changelog
<!-- DO NOT CHANGE THE LINE ABOVE - `make` tasks rely on it to update README.md -->

* **v0.0.2** (2014-11-07)
    * some fix

* **v0.0.1** (2014-11-06):
    * Initial release.
    * how??

