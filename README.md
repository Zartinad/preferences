# preferences

Version-controlled Claude Code configuration for this account.

## Contents

- `skills/` — personal Claude Code skills (`za-explain`, `za-reflect`, `za-start`, `za-capture-design`, `za-verify-script`, `za-sync-preferences`)
- `CLAUDE.md` — global personal preferences, auto-loaded into every Claude Code session
- `settings.json` — global Claude Code settings
- `scripts/scan.sh` — deterministic secret / privacy scan (see below)
- `.githooks/pre-commit` — runs `scan.sh` before every commit

## Setup on a new machine

```sh
git clone https://github.com/Zartinad/preferences.git ~/dev/preferences
cd ~/dev/preferences && git config core.hooksPath .githooks   # enable the pre-commit scan

# back up anything already there, then symlink
mv ~/.claude/skills ~/.claude/skills.bak 2>/dev/null || true
mv ~/.claude/settings.json ~/.claude/settings.json.bak 2>/dev/null || true
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak 2>/dev/null || true

ln -s ~/dev/preferences/skills ~/.claude/skills
ln -s ~/dev/preferences/settings.json ~/.claude/settings.json
ln -s ~/dev/preferences/CLAUDE.md ~/.claude/CLAUDE.md
```

The live `~/.claude/skills`, `~/.claude/settings.json`, and `~/.claude/CLAUDE.md` are
symlinks into this repo, so edits made through Claude Code are tracked here directly.

## Secret / privacy scan

This repo is shareable, so nothing private should land in it. `scripts/scan.sh` checks
every shareable file (tracked + staged + untracked, honoring `.gitignore`) against a fixed
pattern set — API tokens, private keys, JWTs, `key=value` secret assignments, the account
email, `/Users/<name>/` path leaks, and disallowed filenames (`.env`, `*.pem`, `*.key`,
machine-local dirs). It's deterministic: same files in, same result out. If `gitleaks` is
on `PATH` it runs as a second pass.

```sh
bash scripts/scan.sh          # exits non-zero on any finding
```

With the hook enabled (`git config core.hooksPath .githooks`) this runs automatically and
blocks the commit on a finding. To allow one deliberate, non-secret match, add a
`scan:allow` comment marker to that exact line. Never weaken a pattern to get past it.
