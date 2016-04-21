## Changelog

<!-- NOTE: An entry template is automatically added each time `make version` is called. Fill in changes afterwards. -->

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

