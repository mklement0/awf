[![npm version](https://img.shields.io/npm/v/awf.svg)](https://npmjs.com/package/awf) [![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/mklement0/awf/blob/master/LICENSE.md)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

<!-- !!!!
  AUTOMATIC TOC GENERATION IS CURRENTLY DISABLED, because doctoc incorrectly 
  parses the "Usage" chapter.
  FOR NOW, KEEP THE TOC *MANUALLY* IN SYNC, IF YOU CHANGE THE DOCUMENT STRUCTURE.
!!!  -->

**Contents**

- [awf &mdash; a CLI for managing Alfred workflows](#awf--a-cli-for-managing-alfred-workflows)
    - [Retrieving information about workflows](#retrieving-information-about-workflows)
    - [Locating workflows](#locating-workflows)
    - [Editing workflows](#editing-workflows)
    - [Installing and exporting workflows](#installing-and-exporting-workflows)
    - [Developing workflows](#developing-workflows)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Installation from the npm registry](#installation-from-the-npm-registry)
  - [Manual installation](#manual-installation)
- [Usage](#usage)
- [License](#license)
  - [Acknowledgements](#acknowledgements)
  - [npm dependencies](#npm-dependencies)
- [Changelog](#changelog)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# awf &mdash; a CLI for managing Alfred workflows

`awf` (***A***lfred ***W***ork***f***low) is an OS X CLI for managing and
assisting in the development of [workflows](https://www.alfredapp.com/workflows/) for
command-line launcher [Alfred](http://alfredapp.com) - versions 3 and 2 are supported.

It comes with a broad range of features:

Note: Some features related to `Alfred Preferences.app` involve GUI scripting 
and therefore require that the application running `awf` - typically, `Terminal.app` -
be granted access to accessibility features - you will be prompted for authorization
on first use; for more information, see [Apple's support article on the subject](https://support.apple.com/en-us/HT202802).

## Retrieving information about workflows

* List all workflows or workflows matching a filter, optionally with selectable output fields.
  * `awf list -s i net.same2u. # list matching workflows by bundle ID substring`
* Print information about a given workflow.
  * `awf info net.same2u.speak.awf`

## Locating workflows

* Locate a workflow's installation folder by its bundle ID.
  * `awf which net.same2u.speak.awf # prints installation folder path`
* Reveal a workflow's folder in Finder.
  * `awf reveal net.same2u.speak.awf`
* Trigger a keyword search for workflows in Alfred Preferences.
  * `awf search speak`

## Editing workflows

* Change to a workflow's folder in Terminal.
   * `awf cd net.same2u.speak.awf # opens a tab in a new window`
* Open a workflow in Alfred Preferences for editing.
   * `awf edit net.same2u.speak.awf`
   * `awf edit # from a workflow source folder`

## Installing and exporting workflows

* Install a (copy of a) workflow from a source folder.
   * `awf install .`
* Export a `*.alfredworkflow` archive from a source folder.
   * `awf export . # exports to '*.alfredworkflow' in same folder by default`

## Developing workflows

Note:

* The purpose of the following features is to allow you to store workflows being
developed in a _separate location_ instead of directly among the installed workflows.
A _symlink_ to the dev location placed among the installed folders ensures that 
you can still use and develop the workflow from within Alfred and Alfred Preferences.
* These features move directories, create symlinks, and delete files.
  Care is taken not to accidentally overwrite or delete files, but
  _use these features with caution and always create backups_.

<hr/>

* Symlink a dev folder (source folder) into the folder of installed worklows or remove a dev folder's symlink.
  * `awf link . # effective installation without moving the directory`
  * `awf unlink . # remove a symlink - effective uninstallation`
* Move an existing, regular workflow to a dev folder in a different location and replace the original workflow folder with a symlink to the dev folder.
  * `awf todev net.same2u.speak . # move to current folder and perform 'awf link'`
* Conversely, move a dev folder back to the folder of installed workflows as a regularly installed workflow.
  * `awf fromdev . # adding -k would keep the source folder`
* Manage workflow version numbers via file `version`.
  * `awf version patch # bumps the patch component of the workflow's version number`

The [Usage](#usage) chapter contains the full manual.

## Installation

## Prerequisites

 * macOS (OS X)
 * [Alfred](http://alfredapp.com) version 3 or 2 with its paid [Power Pack](https://www.alfredapp.com/powerpack/) add-on.
 
## Installation from the npm registry

 <sup>Note: Even if you don't use Node.js itself: its package manager, `npm`, works across platforms and is easy to install; try  
 [`curl -L http://git.io/n-install | bash`](https://github.com/mklement0/n-install)</sup>

With [Node.js](http://nodejs.org/) installed, install [the package](https://www.npmjs.com/package/awf) as follows:

    [sudo] npm install -g awf

**Note**:

* Whether you need `sudo` depends on how you installed Node.js and whether you've [changed permissions later](https://docs.npmjs.com/getting-started/fixing-npm-permissions); if you get an `EACCES` error, try again with `sudo`.
* The `-g` ensures [_global_ installation](https://docs.npmjs.com/getting-started/installing-npm-packages-globally) and is needed to put `awf` in your system's `$PATH`.

## Manual installation

* Download [the CLI](https://raw.githubusercontent.com/mklement0/awf/stable/bin/awf) as `awf`.
* Make it executable with `chmod +x awf`.
* Move it or symlink it to a folder in your `$PATH`, such as `/usr/local/bin`.

## Usage

`awf` currently does _not_ have a `man` page, but its manual is accessible
through the `help` sub-command:

* `awf help` (or `awf --help` or `awf -h`) gives a concise overview of all sub-commands.
* `awf help all` additionally prints detailed descriptions of all sub-commands.
* `awf help <sub-command>` prints the detailed description of the specified sub-command;
e.g., `awf help list`

<!-- DO NOT EDIT THE FENCED CODE BLOCK and RETAIN THIS COMMENT: The fenced code block below is updated by `make update-readme/release` with CLI usage information. -->

```nohighlight
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
  awf reveal [-P]     [wfDevFolderOrBundleID | '/']
    Reveals an installed workflow's folder in Finder.
    '/' reveals the root of Alfred's workflow folders.

  awf cd [-P]         [wfFolderOrBundleID | '/']
    Changes to an installed workflow's folder in a new Terminal window.
    '/' changes to the root of Alfred's workflow folders.
  awf edit            [wfFolderOrBundleID]
    Opens a workflow for editing in the Alfred Preferences application.

  awf install         [wfDevFolder]
    Installs a workflow from a dev folder.
  awf export  [-R]    [wfFolderOrBundleID [outFolder]]
    Exports a workflow to an *.alfredworkflow ZIP archive.

  awf link|ln [-f]    [wfDevFolder [symlinkName]]
    Symlinks a dev workflow into the folder of installed workflows.
  awf unlink|unln     [wfFolderOrBundleID]
    Removes a symlink to a dev workflow from the folder of installed ones.
  awf prune
    Removes dead symlinks from the folder of installed workflows.
  awf todev [-R]      [wfInstalledFolderOrBundleID [wfDevFolder]]
    Converts an installed workflow to a dev workflow.
  awf fromdev [-k]    [wfDevFolder]
    Converts a dev workflow to a regular installed workflow.
  awf version [-f] [newVersion|'major|'minor'|'patch' [wfFolderOrBundleId]]
    Prints or assigns a workflow's version number.

  awf help [command | 'all']  # or: awf command -h
    Prints help information.

DESCRIPTION
  Performs various operations related to Alfred workflows.
  (To learn about Alfred, go to http://alfredapp.com)
  Supports Alfred 3 and Alfred 2; if both are installed, pass -2 as the very
  first argument to target Alfred 2.

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

  For license information and more, visit https://github.com/mklement0/awf


---
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
    implied search field(s) literally and in full (except for case).

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

---
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

---
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
    # workflow with bundle ID 'net.same2u.speak.awf':
  awf info -b -o ni net.same2u.speak.awf

---
  awf id              [wfFolder]
    Prints the bundle ID of a workflow.

DESCRIPTION
  Prints the bundle ID of a workflow specified by its folder path.
  Omitting the folder path targets the current folder.

EXAMPLES
    # Print the bundle ID of the workflow in the specified folder:
  awf id ~/Projects/Alfred/StringLength

---
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
  awf which
    # Print the installed location and, if applicable, the underlying
    # dev location of the workflow with the specified bundle ID:
  awf which -l net.same2u.speak.awf

---
  awf reveal [-P]     [wfDevFolderOrBundleID | '/']
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
  awf reveal net.same2u.speak.awf

---
  awf cd [-P]         [wfFolderOrBundleID | '/']
    Changes to an installed workflow's folder in a new Terminal window.

DESCRIPTION
  Opens a new Terminal window and makes the specified workflow's 
  installed folder the current folder.

  As a special case, you may specify '/' to change to the *root* folder of
  all installed workflows.

  -P
    If the workflow is symlinked to a dev folder, the underlying dev folder
    is changed to, not the symlinked path among the installed workflows.
    Note that you can always run `pwd -P` to get a symlinked directory's true
    underlying path.

  Note: Since this script cannot change the current shell's working folder,
        a new shell in a new Terminal window must be opened.

EXAMPLES
    # Open a new Terminal window and change to the folder of the
    # (installed) workflow with the specified bundle ID:
  awf cd net.same2u.speak.awf

---
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

---
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

---
  awf export  [-R]    [wfFolderOrBundleID [outFolder]]
    Exports a workflow to an *.alfredworkflow ZIP archive.

DESCRIPTION
  Exports a workflow by creating an *.alfredworkflow ZIP
  archive for later installation (import).
  By default, the archive is placed in the workflow folder itself.
  The archive filename root is the workflow's bundle ID, if defined.
  Otherwise, it is the workflow folder's name, or, if the workflow's parent 
  folder is an npm-style package, the parent folder's name.
  
  -R
    reveals the resulting archive in Finder.

---
  awf link|ln [-f]    [wfDevFolder [symlinkName]]
    Symlinks a dev workflow into the folder of installed workflows.

DESCRIPTION
  Symlinks a dev workflow folder into Alfred's installed workflows
  so as to allow direct use and modification of an in-development workflow.
  If the workflow has a bundle ID defined (which is recommended), there
  mustn't be an installed workflow with the same bundle ID. However, if
  that installed workflow's folder is the very same symlink about to be
  created, no error is reported and no action is performed.
  The symlink's name will be 'dev.workflow.<symlinkName>'.
  <symlinkName> defaults to the workflow's bundle ID, if defined.
  Otherwise, it is the workflow folder's name, or, if the workflow's parent 
  folder is an npm-style package, the parent folder's name.

  -f 
    Force creation of the symlink: If an installed workflow has the
    same bundle ID *and* its folder is also a symlink, forces replacement
    of the existing symlink.
    Useful after moving the dev folder to a different location or changing
    its name.

---
  awf unlink|unln     [wfFolderOrBundleID]
    Removes a symlink to a dev workflow from the folder of installed ones.

DESCRIPTION
  Removes a symlink to a dev workflow folder from among the installed
  workflow folders.
  The dev workflow may be specified directly as a dev workflow folder,
  indirectly as an installed workflow symlink, or even as a bundle ID.

---
  awf prune
    Removes dead symlinks from the folder of installed workflows.

DESCRIPTION
  Removes dead symlinks to dev workflow folders, if any, from among 
  the installed workflow folders.

---
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

---
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

---
  awf version [-f] [newVersion|'major|'minor'|'patch' [wfFolderOrBundleId]]
    Prints or assigns a workflow's version number.

DESCRIPTION
  Returns or sets a workflow's version number, optionally by incrementing
  a component of the current version number.

  The workflow may be specified by folder path or bundle ID; default is the
  current folder.
  
  Without specifying a new version or when passing an empty string,
  the workflow's current version is output.
  If there is none, the exit code is set to 2, and a warning is printed.

  Valid version numbers have 3 .-separated components, and each component
  must be composed of digits only (pre-release version numbers are not
  supported). The component names are: major, minor, and patch.
  
  As an alternative to directly specifying a new version number, an
  increment specifier may be used.
  Supported increment specifiers are 'major', 'minor', 'patch', which
  increment (by 1) the respective version component of the current
  version number. A missing component is treated as 0.
  Caveat: any 0-padding of components is lost in the process.

  -f
    Forces updating the version number, even if the new version number is
    lower than the current one, or if the current version number is invalid.

  A workflow's version number is by convention stored in a plain-text file
  named 'version' in the workflow's folder. The file must without exception
  contain a version number only, and the file must have 1 line only;
  no whitespace allowed.

EXAMPLES
    # Print version number of the workflow in the current folder:
  awf version
    # Increment the patch component of the version number of the workflow
    # in the current folder (e.g., 0.5.1 -> 0.5.2)
  awf version patch


---
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

<!-- DO NOT EDIT THE NEXT CHAPTER and RETAIN THIS COMMENT: The next chapter is updated by `make update-readme/release` with the contents of 'LICENSE.md'. ALSO, LEAVE AT LEAST 1 BLANK LINE AFTER THIS COMMENT. -->

## License

Copyright (c) 2015-2016 Michael Klement <mklement0@gmail.com> (http://same2u.net), released under the [MIT license](http://opensource.org/licenses/MIT).

### Acknowledgements

This project gratefully depends on the following open-source components, according to the terms of their respective licenses.

[npm](https://www.npmjs.com/) dependencies below have optional suffixes denoting the type of dependency; the absence of a suffix denotes a required run-time dependency: `(D)` denotes a development-time-only dependency, `(O)` an optional dependency, and `(P)` a peer dependency.

<!-- DO NOT EDIT THE NEXT CHAPTER and RETAIN THIS COMMENT: The next chapter is updated by `make update-readme/release` with the dependencies from 'package.json'. ALSO, LEAVE AT LEAST 1 BLANK LINE AFTER THIS COMMENT. -->

### npm dependencies

* [doctoc (D)](https://github.com/thlorenz/doctoc)
* [json (D)](https://github.com/trentm/json)
* [replace (D)](https://github.com/harthur/replace)
* [semver (D)](https://github.com/npm/node-semver#readme)
* [urchin (D)](https://github.com/tlevine/urchin)

<!-- DO NOT EDIT THE NEXT CHAPTER and RETAIN THIS COMMENT: The next chapter is updated by `make update-readme/release` with the contents of 'CHANGELOG.md'. ALSO, LEAVE AT LEAST 1 BLANK LINE AFTER THIS COMMENT. -->

## Changelog

<!-- NOTE: An entry template is automatically added each time `make version` is called. Fill in changes afterwards. -->

* **[v0.3.1](https://github.com/mklement0/awf/compare/v0.3.0...v0.3.1)** (2016-09-15):
  * [doc] Fix: full manual restored.

* **[v0.3.0](https://github.com/mklement0/awf/compare/v0.2.4...v0.3.0)** (2016-09-15):
  * [enhancement] Alfred 3 is now supported as well. If both Alfred 2 and Alfred 3
                  are installed, Alfred 2 can be targeted by passing `-2` as the very
                  first argument.

* **[v0.2.4](https://github.com/mklement0/awf/compare/v0.2.3...v0.2.4)** (2015-11-07):
  * [fix] `edit` sub-command now processes its operand correctly and now fails
          in case a dev folder is specified that isn't currently symlinked as
          an installed folder.
  * [dev] Internal optimizations and stability improvements.

* **[v0.2.3](https://github.com/mklement0/awf/compare/v0.2.2...v0.2.3)** (2015-11-07):
  * [doc] `README.md`: Removed spurious 10.10 requirement; copy-editing.

* **[v0.2.2](https://github.com/mklement0/awf/compare/v0.2.1...v0.2.2)** (2015-11-07):
  * [doc] Typo fixed.
  * [dev] Automatic TOC generation for `README.md` disabled for now, because `doctoc`
          doesn't parse the "Usage" chapter correctly.

* **[v0.2.1](https://github.com/mklement0/awf/compare/v0.2.0...v0.2.1)** (2015-11-07):
  * [doc] TOC added to `README.md`

* **[v0.2.0](https://github.com/mklement0/awf/compare/v0.1.0-3...v0.1.0)** (2015-11-07):
  * First release.
  * [change] `afw version` now expects the version number/increments specifier _before_ the target-folder operand; `''` is now
    needed to explicitly ask to _get_ the current version when also specifying a target-folder operand.
  * [change] `afw export` now uses a workflow's bundle ID as the filename root by default.
  * [change] Options may now be intermingled with operands (though the sub-command must still be the very first argument).
  * [fix] Various small fixes.

* **[v0.1.0-3](https://github.com/mklement0/awf/compare/v0.1.0-2...v0.1.0-3)** (2015-10-28):
  * [fix] `awf export` should now work as advertised (support for output-folder argument, resolution of relative paths).

* **[v0.1.0-2](https://github.com/mklement0/awf/compare/v0.1.0-1...v0.1.0-2)** (2015-10-28):
  * [fix] Using `.` as the target dev folder for `awf link` is now handled correctly.

* **[v0.1.0-1](https://github.com/mklement0/awf/compare/v0.1.0-0...v0.1.0-1)** (2015-10-28):
  * [fix] Using `.` as the target dev folder for `awf todev` is now handled correctly.
  * [enhancement] If the target dev folder for `awf todev` is found to be located
    inside a package project (specifically, if `../package.json` exists), it is
    now the *parent* folder's name that is used to form the symlink name, as it
    is assumed to be project-specific, whereas the subfolder hosting the workflow
    source code may not.

* **v0.1.0-0** (2015-10-28):
  * [doc] CLI help improved.
