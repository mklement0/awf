[![npm version](https://img.shields.io/npm/v/awf.svg)](https://npmjs.com/package/awf) [![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/mklement0/awf/blob/master/LICENSE.md)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

<!-- !!!!
  AUTOMATIC TOC GENERATION IS CURRENTLY DISABLED, because doctoc incorrectly 
  parses the "Usage" chapter.
  FOR NOW, KEEP THE TOC *MANUALLY* IN SYNC, IF YOU CHANGE THE DOCUMENT STRUCTURE.
!!!  -->

**Contents**

- [awf &mdash; a CLI for managing Alfred workflows](#awf-&mdash-a-cli-for-managing-alfred-workflows)
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
  * `awf fromdev . # -k keeps the source folder`
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

* `awf help` (or `awf -h`) gives a concise overview of all sub-commands.
* `awf help all` additionally prints detailed descriptions of all sub-commands.
* `awf help <sub-command>` prints the detailed description of the specified sub-command;
e.g., `awf help list`

<!-- DO NOT EDIT THE FENCED CODE BLOCK and RETAIN THIS COMMENT: The fenced code block below is updated by `make update-readme/release` with CLI usage information. -->

```nohighlight
$ awf --help

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
