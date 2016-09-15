# Test scope

The tests do NOT comprise features that require GUI scripting of `Alfred Preferences.app`.
Specifically, the following subcommands are NOT tested:

* `search`
* `edit`
* `install`
* `reveal`

To avoid changing existing workflows, `awf` is made to operate on a test folder 
of workflows, with the regular location overridden via environment variable
`AWF_TEST_WFSROOTFOLDER`.

