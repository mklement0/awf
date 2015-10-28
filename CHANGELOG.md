## Changelog

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


