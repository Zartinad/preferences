---
name: za-verify-script
description: After writing or editing a runnable script/utility, emits a ready-to-copy-paste terminal command to run and verify it immediately, using real paths already known in context. Invoke with /za-verify-script right after creating a script, or apply it proactively the moment a script is finished.
---

# za-verify-script

Closes the gap where a script gets written but the user has to ask (sometimes twice) for
a command to actually run it. The goal is a command that works if pasted verbatim — no
placeholders, no "fill in your path here."

## Step 1: Identify the target script

Default to the most recently written/edited runnable file in this conversation, unless the
user points at a different one. Confirm it's actually runnable — has a CLI entry point or
main-guard (e.g. the `import.meta.url === file://${process.argv[1]}` pattern already used
in this codebase), not just a library module with no CLI hook. If there's no CLI hook,
say so and either point at the module's own test harness or suggest adding a minimal one —
don't fabricate a command that won't work.

## Step 2: Gather real inputs already known in context

Pull the exact absolute path of the script, plus any input it needs: a sample/real data
file already referenced in this conversation (e.g. a saved test CSV), required env vars,
or a URL/ID already discussed. Never use a placeholder like `/path/to/...` — if one
required input's real value isn't yet known, ask for exactly that one missing value
instead of guessing or stubbing it in.

## Step 3: Emit one ready-to-paste command

Give it as a single fenced shell code block using absolute paths, correct for the user's
actual shell/OS (zsh on darwin unless told otherwise) — something that runs as-is with no
edits.

## Step 4: Make the output verifiable, not just runnable

If the script prints JSON, pipe through `jq` for readability (matches this project's
existing convention) and, when there's an obvious sanity check for the data (e.g. a
sum-to-zero invariant for ledger/financial data, a count matching an expected total),
include a `jq` expression that surfaces exactly that value — not just a raw dump the user
has to eyeball.

## When to trigger

Apply this proactively immediately after finishing a standalone script/CLI utility in a
session, without waiting for explicit `/za-verify-script` invocation or for the user to
ask — the motivating case was a PokerNow-log-parsing session where the user had to
separately ask "give me a command to run this" after every script, including asking twice
for "the command I can simply copy and paste with."
