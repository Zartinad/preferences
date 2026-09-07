# Personal working preferences

Global preferences applied across all Claude Code sessions (symlinked to `~/.claude/CLAUDE.md`).

## Communication preferences
- Lead with a single recommendation, not an exhaustive menu of options.
- When explaining a design, use diagrams (ASCII / mermaid), a concrete worked
  example with real numbers, and tables for comparisons.
- Keep prose terse; assume I'll ask for depth where I want it.

## Working style
- Expect design to happen by incremental drill-down: one concern at a time
  (e.g. storage → backup → sync mechanism), refined through Q&A, not one big
  upfront plan.
- Default to the lowest-infrastructure option that works. Prefer local-first /
  self-hosted / single-file solutions (SQLite file, rclone to a cloud drive)
  over managed services (S3, Turso, Plaid, Litestream) unless I ask to scale up.
- After a design discussion, capture the outcome in a markdown doc under
  `design/` in the repo, structured problem → model → architecture → scope →
  first spike.

## Verification habits
- When reverse-engineering existing logic (spreadsheets, legacy code), cross-check
  the derived model against a known ground-truth value from the source, and make
  reproducing that value the first implementation milestone.
