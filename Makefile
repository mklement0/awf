	# Add the local npm packages' bin folder to the PATH, so that `make` can find them even when invoked directly (not via npm).
	# !! Note that this extended path only takes effect in (a) recipe commands that are (b) true shell commands (not optimized away) - when in doubt, simply append ';'
	# !! To use the extended path in $(shell ...) function calls, use $(shell PATH="$(PATH)" ...),
export PATH := ./node_modules/.bin:$(PATH)
	# Sanity check to make sure supporting utilites (and npm) are installed.
UTILS := replace semver json urchin
$(if $(shell PATH="$(PATH)" which $(UTILS) >/dev/null && echo 'ok'),,$(error Did you forget to run `npm install` after cloning the repo (Node.js must be installed)? At least one of the required supporting utilities not found: $(UTILS)))
	# Since we rely on paths relative to the Makefile location, abort if make isn't being run from there.
$(if $(findstring /,$(MAKEFILE_LIST)),$(error Please only invoke this makefile from the directory it resides in))


	# Default target (by virtue of being the first non '.'-prefixed target in the file).
.PHONY: _no-target-specified
_no-target-specified:
	$(error Please specify the target to make - `make list` shows targets. Alternatively, use `npm test` to run the default tests; `npm run` shows all tests)

# Lists all targets defined in this makefile.
.PHONY: list
list:
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

# Ensures that the git workspace is clean.
.PHONY: _ensure-clean
_ensure-clean:
ifdef VERSION
	@[ -z "$$(git status --porcelain || echo err)" ] || { echo "Workspace is not clean; please commit changes first." >&2; exit 2; }
endif

# Increments the version number, commits the changes and creates an annotated tag with the version number.
.PHONY: version
version: _ensure-clean
ifndef VERSION
	@json -f package.json version;	# output the current version
	@printf 'Note:\tTo increment the version number and commit & tag, ensure that the workspace is clean, then run:\n\t\tmake version VERSION=<new-version>\n\twhere <new-version> is either an increment specifier (patch, minor, major,\n\tprepatch, preminor, premajor, prerelease), or an explicit <major>.<minor>.<patch> version number.\n'
else
	@oldVer=`json -f package.json version` || exit; \
	 newVer=`echo "$(VERSION)" | sed 's/^v//'`; \
	 if printf "$$newVer" | grep -q '^[0-9]'; then \
	   semver "$$newVer" >/dev/null || { echo 'Invalid version number specified: $(VERSION) - must be major.minor.patch' >&2; exit 2; }; \
	   semver -r "> $$oldVer" "$$newVer" >/dev/null || { echo 'Invalid version number specified: $(VERSION) - must be HIGHER than $$oldVer.' >&2; exit 2; } \
	 else \
	   newVer=`semver -i "$$newVer" "$$oldVer"` || { echo 'Invalid version-increment specifier: $(VERSION)' >&2; exit 2; } \
	 fi; \
	 printf "=== ABOUT TO BUMP VERSION:\n\t**$$oldVer** -> **$$newVer**\n=== before COMMITTING AND TAGGING.\nType 'proceed' to proceed, anything else to abort: " && read response && [ "$$response" = 'proceed' ] || { echo 'Aborted.' >&2; exit 2; };  \
   npm version $$newVer --no-git-tag-version >/dev/null || exit; \
	 replace --silent '^(THIS_VERSION=).*$$' '$$1'$$newVer bin/awf || exit; \
	 newTag=v$$newVer; \
	 echo git commit -a -m "$$newTag" && echo git tag -a -m "$$newTag" "$$newTag" || exit; \
	 echo "Version bumped to $$newVer; changes committed and tagged $$newTag."
endif	
