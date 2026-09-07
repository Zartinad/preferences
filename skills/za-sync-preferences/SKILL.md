---
name: za-sync-preferences
description: Shows pending changes in the version-controlled Claude config repo(s) that ~/.claude symlinks into (skills, settings, CLAUDE.md), scans them for secrets and private/identifying content, then commits and pushes on confirm. Invoke with /za-sync-preferences after editing a personal skill or config, or apply it proactively at the end of a session that changed one.
---

# za-sync-preferences

`~/.claude/skills` and `~/.claude/settings.json` are symlinks into a checked-out repo
(currently `~/dev/preferences`), so edits made through Claude Code during a session land
in that repo as uncommitted changes and then sit there. This skill surfaces those changes
and gets them committed + pushed, instead of leaving the repo dirty and the remote stale.

## Step 1: Find the config repo(s)

Resolve the real paths behind the symlinked config entries and find the git repo each
lives in:

```sh
for p in ~/.claude/skills ~/.claude/settings.json ~/.claude/CLAUDE.md; do
  [ -e "$p" ] && git -C "$(dirname "$(readlink -f "$p")")" rev-parse --show-toplevel 2>/dev/null
done | sort -u
```

Operate on each repo returned (usually just one, `~/dev/preferences`). If none resolve to
a git repo, the config isn't version-controlled yet — say so and point at the repo's
README setup steps (or offer to wire it up); don't try to init anything here.

## Step 2: Show what changed

For each repo, from its toplevel:
- `git status --short` and `git diff` (include staged: `git diff --staged`) so the user
  sees the actual content, not just filenames.
- Note untracked files explicitly — a newly added skill directory shows up only as
  untracked.
- Check whether local is already ahead of `origin` (`git log --oneline @{u}..` ) so an
  earlier commit that never got pushed still gets caught.

Summarize in a sentence or two what the change is (e.g. "new skill `za-sync-preferences`",
"tightened `za-reflect` Step 4"). If the working tree is clean *and* nothing is unpushed,
say there's nothing to sync and stop.

## Step 3: Scan for anything private or sensitive

This repo is shareable (it may be made public or have outside collaborators added), so
before committing, review everything that would go up — staged + unstaged + untracked
content, not just filenames. Get the full picture with:

```sh
git -C <toplevel> add -A -n            # list what would be staged, including untracked
git -C <toplevel> diff --staged        # after a real `git add -A`, or use `git diff HEAD`
```

**Run the repo's deterministic scanner — this is a hard gate:**

```sh
bash <toplevel>/scripts/scan.sh
```

It checks every shareable file (tracked + staged + untracked, honoring `.gitignore`)
against a fixed pattern set — GitHub/OpenAI/AWS/Slack/Google tokens, private-key blocks,
JWTs, `key=value` secret assignments, the user's email, `/Users/<name>/` and `/home/<name>/`
path leaks, and disallowed filenames (`.env`, `*.pem`, `*.key`, `id_rsa`, and machine-local
dirs like `sessions/`, `backups/`). Same input → same output. If `gitleaks` is installed it
runs as a second pass.

**If `scan.sh` exits non-zero, stop.** Show the user the reported `file:line` matches and
have them redact, or — only for a deliberate, non-secret match — add a `scan:allow` comment
marker to that exact line and re-run. Do not commit while the scanner fails. Do not weaken
or bypass a pattern to get past it. For a file that should never be tracked, add it to
`.gitignore` (and `git rm --cached` if already tracked).

Then also eyeball the diff for things a regex won't catch — employer / client / internal
project names, non-public URLs or hostnames, real names or addresses in prose — and raise
those with the user the same way.

## Step 4: Confirm, then commit and push

Show the summary and ask once whether to commit + push all of it, a subset, or skip. On
confirm, per repo:

```sh
git -C <toplevel> add -A
git -C <toplevel> commit -m "<message>"
git -C <toplevel> push
```

Write a real commit message describing the change (imitate the repo's existing history —
short imperative subject). End the commit message with the trailer:

```
Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
```

If the user asked for a subset, stage just those paths (`git add <paths>`) instead of
`-A`. Report the resulting commit hash and that the push succeeded.

## When to trigger

Apply proactively at the end of a session that created or edited anything under
`~/.claude/skills/`, changed `~/.claude/settings.json`, or edited the `CLAUDE.md` that
lives in one of these repos — don't wait for an explicit `/za-sync-preferences`. The
motivating case: a session that built the `preferences` repo and immediately started
adding skills to it, where each skill edit would otherwise be left uncommitted and
unpushed.
