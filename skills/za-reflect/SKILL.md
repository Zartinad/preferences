---
name: za-reflect
description: Reflects on the current conversation to propose updates to the user's personal ~/.claude/CLAUDE.md preferences file and suggest new Claude Code skills based on observed habits. Invoke with /za-reflect at the end of a session or work stretch worth learning from.
---

# za-reflect

Turns the current conversation into two concrete outputs: (1) a proposed diff to the
user's personal `~/.claude/CLAUDE.md` preferences file, and (2) a short list of new skills
worth building, both grounded in things actually observed in this session — not generic
advice.

## Step 1: Locate the preferences file

The target is `~/.claude/CLAUDE.md` — the global personal-preferences file Claude Code
auto-loads into every session. It is normally a symlink into the version-controlled
config repo (`~/dev/preferences/CLAUDE.md`); edit it through the symlink.

If it doesn't exist yet, say so up front and treat `~/.claude/CLAUDE.md` as the target to
be created fresh — don't ask the user to pick a path. (Do not use the name `cursor.md`;
that was an earlier convention borrowed from the Cursor editor and is no longer used.)

## Step 2: Mine the conversation for signal

Re-read the conversation transcript (not just the last message) and pull out patterns that
are *specific and repeated*, not one-off asks. Good signal looks like:

- **Corrections** — anywhere the user said "no, do X instead" or pushed back on an
  approach. These are the highest-value signal; capture the correction and the underlying
  reason, not just the surface complaint.
- **Repeated requests** — the same kind of ask showing up more than once (e.g. asking
  twice for "a command I can copy and paste with," preferring real file paths over
  placeholders, wanting terminal verification steps for every deliverable).
- **Working-style tells** — how the user likes work validated (e.g. cross-checking against
  a ground-truth source, zero-sum/invariant checks, iterating through debug scripts rather
  than accepting a first answer), how much explanation they want, whether they prefer
  terse or thorough responses.
- **Domain/tooling preferences** — recurring stack choices, conventions the user pointed
  out in the existing codebase that should be matched going forward.

Ignore anything that's a one-off, project-specific detail with no generalizable habit
behind it (that belongs in the project's own `CLAUDE.md`, not the personal one).

## Step 3: Draft the `CLAUDE.md` diff

Organize proposed additions/edits under short headings (e.g. `## Working style`,
`## Verification habits`, `## Communication preferences`). For each proposed line:
- State it as a direct, actionable instruction (imitate how `CLAUDE.md` files read).
- Keep a mental note of *why* (the transcript evidence) so you can justify it if asked,
  but don't pad the file itself with rationale — keep entries terse.
- Prefer editing/tightening an existing line over piling on a near-duplicate one, if
  `~/.claude/CLAUDE.md` already has content.

## Step 4: Suggest new skills

Propose 2-4 candidate skills, each tied to a concrete, recurring pattern from Step 2 —
not a generic "here's what Claude Code can do" list. Every proposed skill name must start
with a `za` prefix (e.g. `/za-verify-script`, `/za-zero-sum-check`), matching this skill's
own naming — this marks them as part of the user's personal skill set rather than a
project-specific one. For each: the `/za-name`, one sentence on what it would automate or
enforce, and the specific moment(s) in this conversation (or past sessions, if recalled
via memory) that motivated it.

Before proposing a skill, check whether it already exists under `~/.claude/skills/` — if
so, don't pitch it as new; either drop it or list it under a short "run this" note. In
particular, if this session created or edited anything under `~/.claude/skills/`, changed
`~/.claude/settings.json`, or edited the version-controlled `CLAUDE.md`, remind the user to
run `/za-sync-preferences` to commit and push those changes — including when applying the
`CLAUDE.md` diff from this reflection would itself dirty that repo.

## Step 5: Present, don't silently apply

Show the user the proposed `CLAUDE.md` diff and the skill suggestions as a review — do
not write the file yet. Ask (a single round, not per-line) whether to apply the diff as-is,
apply a subset, or skip. Only write to `~/.claude/CLAUDE.md` (creating it if it doesn't
exist) once the user confirms. If the user also wants one of the suggested skills built,
build it the same way this skill itself was built: a `SKILL.md` with frontmatter under
`~/.claude/skills/<name>/` for a personal/cross-project skill, or `.claude/skills/<name>/`
in the repo for a project-specific one.
