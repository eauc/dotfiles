



# Aliases


```sh
[alias]
```


## Diff


Basic configuration:
- ignore all white space, even when whitespaces were added where no whitespace before.
- show a word diff.
- detect file rename with 75% similarity threshold.
```sh
  d = diff --ignore-all-space --color-words --find-renames=75
  dt = difftool
  dc = show --ignore-all-space --color-words --find-renames=75
  dtc = "!diffCommit() { git dt "$1~" "$1"; }; diffCommit"
  dch = "!git dc HEAD"
  dth = "!git dtc HEAD"
```

Diff between staging > working:
```sh
  dsw = "!git d"
```

Diff between HEAD > working:
```sh
  dhw = "!git d HEAD"
```

Diff between HEAD > staging:
```sh
  dhs = "!git d --cached"
```

Diffs including submodules:
```sh
  dsm = "!git d; git submodule foreach 'git d'"
  dsmsw = "!git dsw; git submodule foreach 'git dsw'"
  dsmhs = "!git dhs; git submodule foreach 'git dhs'"
  dsmhw = "!git dhw; git submodule foreach 'git dhw'"
```


## Logs


Basic format:
- abbreviated commit hash :: %h yellow.
- ref names :: %d green.
- subject :: %s white.
- author date, relative :: %ar magenta.
- author name :: %an blue.
```sh
  log-format = log --format=format:"%C(yellow)%h%C(bold\\ green)%d%C(reset)\\ %s\\ %C(magenta)%ar\\ %C(blue)%an"
```

Basic graph log:
```sh
  l = "!git log-format --graph"
```

Log all refs:
```sh
  la = "!git l --all"
```

With diffstat:
```sh
  ll = "!git la --stat"
```

Log my commits:
- author :: author name pattern filter

```sh
  lam = "!git la --author=Auclair"
  llm = "!git ll --author=Auclair"
```

Log only HEAD:
```sh
  lh = "!git log-format -n 1"
  llh = "!git lh --stat"
```

Order by author date:
```sh
  ld = "!git l --author-date-order"
  lad = "!git ld --all"
```

Log one file's history:
```sh
  lf = "!git la --follow"
```

Find commit introducing/removing string (regexp):
- pickaxe-regex :: consider argument is a regex;
```sh
  li = "!logintro() { git log-format -S$1 --pickaxe-regex; }; logintro"
```

Find commit with diff containing a string (regexp):
```sh
  lm = "!logmod() { git log-format -G$1; }; logmod"
```


## Stash


Stash only working:
- --patch :: chunked stash, implies =--keep-index=
```sh
  st = stash save --patch
  stw = "!git st"
```

Stash staging + working:
-we need to reset =--keep-index= flag implied by =--patch= option
```sh
  stsw = "!git st --no-keep-index"
```

Apply & pop, restoring index:
```sh
  sta = stash apply --index
  stp = stash pop --index
```

Inspect stashes:
```sh
  sts = stash show
```

Inspect stashes diff:
```sh
  stdiff = stash show --patch
```


## Commit


Shortcuts for lazy people:
- --patch :: chunked add
- -v :: add diff to message draft for inspection
- --amend :: add modifications to previous commit
- --no-edit :: use previous commit message without change
```sh
  ap = add --patch
  c = commit -v
  ca = "!git c --amend"
  oops = "!git ca --no-edit"
```

Unstage changes:
- --patch :: chunked unstage
```sh
  us = reset HEAD
  usi = reset --patch HEAD
```

Add file deletions:
```sh
  addrm = "!git rm $(git ls-files --deleted)"
```


## Merges


Shorcuts for lazy people:
```sh
  mt = mergetool
```

Prefer no-fast-forward merges:
```sh
  m = merge --no-ff
```

Explicit fast-forward:
```sh
  ff = merge --no-commit
```

Fix another commit:
```sh
  fix = "!fixcommit() { git commit --fixup=$1; }; fixcommit"
```

Squashperform a merge but do not create a merge commit.
Allows to get the modifications from another branch, like a merge, but without actually performing the merge.
```sh
  ms = merge --squash
```


## Reset


Reset HEAD / Keep changes in staging + working:
```sh
  rh = reset --soft
```

Reset HEAD + staging / Keep changes in working / Update working with commit:
```sh
  rhs = reset --merge
```

Reset HEAD + staging + working:
```sh
  ra = reset --hard
```


## Cleanup


Discard changes in working / Keep untracked:
- --patch :: chunked discard
```sh
  discard = checkout --
  dis = "!git discard"
  disi = checkout --patch --
```

Clean untracked:
- remove untracked directories (-d).
```sh
  cl = clean -d -f
```

Clean untracked + ignored:
- remove untracked directories (-d).
- remove ignored files (-x).
```sh
  purge = clean -x -d -f
```


## Branches


Shortcuts for lazy people:
```sh
  b = branch
  bd = branch -d
```

Show the current branch name:
- --short :: show shorten branch name (=refs/heads/master -> master=)
```sh
  bh = symbolic-ref --short HEAD
```

List all local branches:
- -v :: show branches commit
- -vv :: show the differences between local/remote branches
```sh
  bl = "!git f && git branch -vv"
```

List all branches, including remotes:
- --allshow all local/remote branches
```sh
  ba = "!git bl --all"
```

Create branch on commit:
```sh
  bc = checkout -b
```


## Rebase


Shortcuts for leazy people:
```sh
  rbc = "!git rebase --continue"
  rba = "!git rebase --abort"
```

Rebase:
- --interactive :: interactive by default
```sh
  rb = rebase --interactive
```

Rebase on updated origin/master:
```sh
  rbm = "!git fetch && git rb origin/master"
  rbfm = "!git fetch && git rb origin/refonte-master"
```

Rebase exec:
- --exec cmd :: run a command after each rebased commit
```sh
  rbx = "!git rb --exec"
```


## Files


Grep pattern in tracked files:
- ignore binary files :: -I.
- empty line between different files :: --break.
```sh
  g = grep -I --break
```

Grep all working, also untracked files:
```sh
  gw = "!git g --untracked"
```

Grep staging:
```sh
  gs = "!git g --cached"
```


## Remote


Shortcuts for lazy people:
```sh
  p = push
  oopf = "!git oops && git pf"
```

Clone:
- always checkout submodules.
```sh
  clone = clone --recursive
```

Basic fetch:
- remote tags.
- remove remote-tracking branches that do not exists on remote.
```sh
  f = fetch --prune --tags
```

Synchronize tags with remote:
```sh
  ft = fetch -p origin +refs/tags/*:refs/tags/*
```

Push force, respects new changes in remote:
```sh
  pf = push --force-with-lease
```

Set remote-tracking branch:
```sh
  pup = push --set-upstream
  pub = "!git pup origin `git bh`"
```

Check that new commits in submodules have been pushed to their remote:
```sh
  purc= push --recurse-submodules=check
```

Push new commits in submodules when necessary:
```sh
  purd= push --recurse-submodules=on-demand
```


## Submodules


Shortcuts for lazy people:
```sh
  sms = submodule status
```

Show commits between last registered commit (HEAD) in super project, and current commit (Working) in submodule:
```sh
  smhw = submodule summary
```

Show commits between last registered commit (HEAD) in super project, and commit staged (Staging) for submodule:
```sh
  smhs = submodule summary --cached -- HEAD
```

Show commits between commit staged (Staging) in super project, and current commit (Working) in submodule:
```sh
  smsw = submodule summary --files
```

Execute a command in each submodule, continue on fail.
```sh
  smf = "!foreach() { git submodule foreach \"$1 || true\"; }; foreach"
```

Update submodules to commits registered in HEAD of super project:
```sh
  smu = submodule update
```

Update modules to last commit of remote-tracked branch defined in .gitmodules:
```sh
  smur = submodule update --remote
```


## Miscellaneous


Shortcuts for lazy people:
```sh
  s = status
  co = checkout
```

List all aliases:
```sh
  lal = "!git config -l | grep alias | cut -c 7-"
```

Search an alias:
```sh
  sal = "!search_alias() { git lal | grep -i --color \"$1\"; }; search_alias"
```

Display last tag name in commit history:
```sh
  lasttag = describe --tags --abbrev=0
```

Toggle ignore local modification on path:
```sh
  changed = update-index --no-assume-unchanged
  unchanged = update-index --assume-unchanged
```

Retry a Git command every 2s until it succeeds:
```sh
  bourrin = "!retry() { until $(git $1); do sleep 2; echo "Retrying"; date; done; }; retry"
```

Retrieve standard ignore files for a language:
```sh
  ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi"
```

Get/Set the project's git-hooks directory:
```sh
  hooks = config core.hooksPath
```


# User Info


```sh
[user]
  name = Auclair Emmanuel
  email = auclair.emmanuel@gmail.com
```


# Pretty diff


Pretty diff pager:
- `npm install -g diff-so-fancy`
- one tab = 2 spaces.
- raw control chars :: -R.
- quit if one screen :: -F.
- no init :: -X.
```sh
[pager]
  diff = diff-so-fancy | less --tabs=2 -RFX
  difftool = true
  show = diff-so-fancy | less --tabs=2 -RFX
[interactive]
  diffFilter = "less --tabs=2 -RFX"
```

- show submodules commit logs in super projet diffs.
- use `icdiff` as a diff tool for side-by-side comparison.
```sh
[diff]
  submodule = log
  tool = difftastic
[difftool]
  prompt = false
[difftool "difftastic"]
  cmd = difft "$MERGED" "$LOCAL" "$REMOTE"
[difftool "icdiff"]
  cmd = icdiff --line-numbers $LOCAL $REMOTE
```


# Colors


```sh
[color]
  ui = true
[color "diff"]
  meta = "yellow bold"
  commit = "green bold"
  frag = "magenta bold"
  old = "red bold"
  new = "green bold"
  whitespace = "red reverse"
[color "diff-highlight"]
  oldNormal = "red bold"
  oldHighlight = "red bold 52"
  newNormal = "green bold"
  newHighlight = "green bold 22"
[color "branch"]
  current = "green reverse"
  local = green
  remote = yellow
[color "status"]
  added = green
  changed = red
  untracked = cyan
  unmerged = magenta
```


# Miscellaneous


Grep:
- display lines numbers in results
```sh
[grep]
  lineNumber = true
```

Push:
- push to origin/upstream, or other/current
```sh
[push]
  default = simple
```

Blame:
- display relative dates
```sh
[blame]
  date = relative
```

Help:
- auto correct git command and execute after 1x 0.1s
```sh
[help]
  autocorrect = 1
```

Interactive:
- don't need to type enter after single-key shortcuts in interactive commands.
```sh
[interactive]
  singleKey = true
```

Pull:
- use rebase strategie to merge
```sh
[pull]
  rebase = true
```

Rebase:
- auto stash local modifs before/after rebase
- auto fix/squash commit with message starting with =!fixup= or =!squash=
```sh
[rebase]
  autostash = true
  autosquash = true
  missingCommitsCheck = ignore
```

Credentials
- remember credentials in local store
```sh
[credential]
  helper = store
```

Merge:
- use `kdiff3` as mergetool
- do not keep `.orig` backup files after successful merge
```sh
[merge]
  tool = kdiff3
  conflictstyle = diff3
[mergetool]
  keepBackup = false
```

Remember conflicts resolutions
```sh
[rerere]
  enabled = true
```
