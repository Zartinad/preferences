# preferences

Version-controlled Claude Code configuration for this account.

## Contents

- `skills/` — personal Claude Code skills (`za-explain`, `za-reflect`, `za-verify-script`)
- `settings.json` — global Claude Code settings

## Setup on a new machine

```sh
git clone https://github.com/Zartinad/preferences.git ~/dev/preferences

# back up anything already there, then symlink
mv ~/.claude/skills ~/.claude/skills.bak 2>/dev/null || true
mv ~/.claude/settings.json ~/.claude/settings.json.bak 2>/dev/null || true

ln -s ~/dev/preferences/skills ~/.claude/skills
ln -s ~/dev/preferences/settings.json ~/.claude/settings.json
```

The live `~/.claude/skills` and `~/.claude/settings.json` are symlinks into this
repo, so edits made through Claude Code are tracked here directly.
