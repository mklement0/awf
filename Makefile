	# Since we rely on paths relative to the Makefile location, abort if make isn't being run from there.
$(if $(findstring /,$(MAKEFILE_LIST)),$(error Please only invoke this makefile from the directory it resides in))
	# Run all shell commands with bash.
SHELL := bash
	# Add the local npm packages' bin folder to the PATH, so that `make` can find them even when invoked directly (not via npm).
	# !! Note that this extended path only takes effect in (a) recipe commands that are (b) true shell commands (not optimized away) - when in doubt, simply append ';'
	# !! To also use the extended path in $(shell ...) function calls, use $(shell PATH="$(PATH)" ...),
export PATH := ./node_modules/.bin:$(PATH)
	# Sanity-check to make sure dev dependencies (and npm) are installed.
$(if $(shell [[ -d ./node_modules/semver ]] && echo 'ok'),,$(error Did you forget to run `npm install` after cloning the repo (Node.js must be installed)? At least one of the required dev dependencies not found))
	# Determine the editor to use for modal editing. Use the same as for git, if configured; otherwise $EDITOR, then fall back to vi (which may be vim).
EDITOR := $(shell git config --global --get core.editor || echo "$${EDITOR:-vi}")


	# Default target (by virtue of being the first non '.'-prefixed target in the file).
.PHONY: _no-target-specified
_no-target-specified:
	$(error Please specify the target to make - `make list` shows targets. Alternatively, use `npm test` to run the default tests; `npm run` shows all commands)

# Lists all targets defined in this makefile.
.PHONY: list
list:
	@$(MAKE) -pRrn -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

.PHONY: _ensure-master-branch
	[[ `git symbolic-ref --short HEAD` == 'master' ]] && { echo 'Please release from the master branch only' >&2; exit 2; }

# Ensures that the git workspace is clean or contains only *staged* changes (and no untracked files).
.PHONY: _ensure-clean-or-staged-changes-only
_ensure-clean-or-staged-changes-only:
	@[[ -z $$(git status --porcelain | awk -F'\0' '$$2 != " " { print $$2 }') ]] || { echo "Workspace must either be clean or contain only staged changes; please commit or at least stage changes first." >&2; exit 2; }

# If NEW is *not* specified: reports the current version number - both as defined by the latest git tag and by package.json
# If NEW *is* specified: sets the version number in source files and package.json; incrementing from the latest git tag
.PHONY: version
version:
ifndef NEW
	@printf 'Current version:\n\tv%s (from package.json)\n\t%s (from git tag)\n' `json -f package.json version` `git describe --abbrev=0 --match 'v[0-9]*.[0-9]*.[0-9]*' 2>/dev/null || echo 'v0.0.0'`
	@printf 'Note:\tTo increment the version number or make a release, run:\n\t\tmake version NEW=<new-version>\n\t\tmake release NEW=<new-version>\n\twhere <new-version> is either an increment specifier (patch, minor, major,\n\tprepatch, preminor, premajor, prerelease), or an explicit <major>.<minor>.<patch> version number.\n'
else
	@$(MAKE) -f $(lastword $(MAKEFILE_LIST)) _ensure-clean-or-staged-changes-only || exit; \
	 oldVer=`git tag | xargs semver | tail -n 1 | sed 's/^v//'`; oldVer=$${oldVer:-0.0.0}; \
	 newVer=`echo "$(NEW)" | sed 's/^v//'`; \
	 if printf "$$newVer" | grep -q '^[0-9]'; then \
	   semver "$$newVer" >/dev/null || { echo 'Invalid semver version number specified: $(NEW)' >&2; exit 2; }; \
	   semver -r "> $$oldVer" "$$newVer" >/dev/null || { echo 'Invalid version number specified: $(NEW) - must be HIGHER than $$oldVer.' >&2; exit 2; } \
	 else \
	   newVer=`semver -i "$$newVer" "$$oldVer"` || { echo 'Invalid version-increment specifier: $(NEW)' >&2; exit 2; } \
	 fi; \
	 printf "=== About to BUMP VERSION:\n\t$$oldVer -> **$$newVer**\n===\nYou'll also be prompted to provide a changelog entry.\nProceed (y/N)?: " && read response && [[ "$$response" =~ [yY] ]] || { echo 'Aborted.' >&2; exit 2; };  \
	 replace --silent --recursive --exclude='.git,node_modules,test,Makefile' "v$${oldVer//./\\.}" "v$${newVer}" . || exit; \
	 [[ `json -f package.json version` == $$newVer ]] || npm version $$newVer --no-git-tag-version >/dev/null || exit; \
	 fgrep -q "v$$newVer" CHANGELOG.md || replace --silent '^## Changelog$$' $$'$$&\n\n* **v'"$$newVer"$$'** ('"`date +'%Y-%m-%d'`"$$'):\n\t* ???' CHANGELOG.md; \
	 git add --update . || exit; \
	 echo "-- Version bumped to v$$newVer in source files and package.json."
endif	

# Increments the version number, then commits and tags, pushes to origin, prompts to publish to the npm-registry.
.PHONY: release
release: _ensure-master-branch version
ifdef NEW
	@newVer=`json -f package.json version` || exit; \
	 $(EDITOR) CHANGELOG.md; \
	 { fgrep -q "v$$newVer" CHANGELOG.md && ! fgrep -q '???' CHANGELOG.md } || { echo "ABORTED: No changelog entries provided for new version v$$newVer." >&2; exit 2; }; \
	 $(MAKE) -f $(lastword $(MAKEFILE_LIST)) update-readme || exit; \
	 echo git commit -m "v$$newVer" || exit; \
	 echo "-- v$$newVer committed."; \
	 echo git tag -a -m "v$$newVer" "v$$newVer" || exit; \
	 echo "-- v$$newVer tagged."; \
	 echo git push origin master || exit; \
	 echo "-- v$$newVer pushed."; \
	 if [[ `json -f package.json private` != 'true'  ]]; then \
	 		printf "=== About to PUBLISH TO NPM as:\n\t**`json -f package.json name`@$$newVer**\n===\nType 'publish' to proceed; anything else to abort: " && read response && [[ "$$response" == 'publish' ]] || { echo 'Aborted.' >&2; exit 2; };  \
	 		echo npm publish || exit; \
	 		echo "-- Published to npm."; \
	 else \
	 		echo "-- (Package marked as private; not publishing to npm.)"; \
	 fi; \
	 echo "-- Done."
endif

.PHONY: update-readme
update-readme:
	@CLI_HELP_CMD=( bin/`json -f package.json name` help all ); \
	 CLI_HELP_CMD_DISPLAY=( "$${CLI_HELP_CMD[@]}" ); CLI_HELP_CMD_DISPLAY[0]=$${CLI_HELP_CMD##*/}; CLI_HELP_CMD_DISPLAY[0]=$${CLI_HELP_CMD_DISPLAY[0]%.*}; \
	 newText=$$'```\n$$ '"$${CLI_HELP_CMD_DISPLAY[@]}"$$'\n\n'"$$( "$${CLI_HELP_CMD[@]}" )"$$'\n```' || exit; \
	 replace --count --quiet --multiline=false '(^|\n)(## Usage\n\n)[\s\S]+?(\n(\s*<!-- .+? -->\s*\n)?#|$$)' $$'$$1$$2'"$$newText"$$'$$3' README.md | fgrep -q ' (1)' || { echo "Failed to update read-me chapter: usage." >&2; exit 1; }; \
	 newText=$$(tail -n +3 CHANGELOG.md); \
	 replace --count --quiet --multiline=false '(^|\n)(## Changelog\n\n)[\s\S]+?(\n(\s*<!-- .+? -->\s*\n)?#|$$)' $$'$$1$$2'"$$newText"$$'\n$$3' README.md | fgrep -q ' (1)' || { echo "Failed to update read-me chapter: changelog." >&2; exit 1; }; \
	 doctoc README.md >/dev/null || { echo "Failed to update read-me TOC." >&2; exit 1; }; \
	 replace --count --quiet '^\*\*Table of Contents\*\*.*$$' '**Contents**' README.md | { fgrep -q ' (1)' || { echo "Failed to update heading of read-me TOC." >&2; exit 1; } }
