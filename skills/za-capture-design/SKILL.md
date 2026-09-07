---
name: za-capture-design
description: Writes the design worked out in the current conversation into a structured markdown doc (problem → reverse-engineered model → architecture → storage → scope → first spike). Invoke with /za-capture-design [path] after a brainstorm/explain thread has settled, or when asked to "write the design into <file>".
---

# za-capture-design

The brainstorm already happened in this thread. This skill is the "now commit it to a
doc" step — turn the scattered Q&A into one clean design doc someone could read cold.
It is the counterpart to `/za-explain` (which deliberately writes no files).

Do not re-open the design or add new ideas the conversation didn't reach. Capture what was
decided, mark what's still open, and stop.

## Step 1: Locate the target doc

- If the user gave a path, use it.
- Else if the repo has a `design/` directory, write `design/<topic>.md`.
- Else default to `design/structure.md`, creating `design/` if needed.
- If the file exists and is non-empty, read it first and merge — replace stale sections,
  keep anything still accurate, don't append a second copy of the same material.

State the path you chose in one line before writing.

## Step 2: Mine the whole thread, not just the last message

Pull from the entire conversation:
- The problem being solved and any existing system being replaced.
- Anything reverse-engineered (a spreadsheet's formulas, legacy code's behaviour) —
  including the worked example / ground-truth number used to confirm the model.
- Every design decision the user steered (their pushback is the spec — e.g. "just use
  Google Drive", "only local for now").
- Questions raised but not resolved.
- Any "first thing to build" the thread landed on.

## Step 3: Write the doc

Use this skeleton, dropping sections that genuinely don't apply:

```
# <Topic> — Design

<one-line framing>  + status line (draft / agreed) + scope-of-v1 line

## 1. <What exists today / the problem>
   - what the current system does, as a table mapping old artifact -> new concept
   - key realizations (the insights that reframe the problem)
   - reverse-engineered logic with a WORKED EXAMPLE that reproduces a real value
   - open product decisions (bulleted questions)

## 2. Architecture
   - stack, with one-line justification each
   - data model (as a readable block, not prose)
   - the derived views / queries
   - primary user flow(s), screen map

## 3. Storage & backup / <the concern the thread drilled into most>
   - decisions, diagrams (ASCII/mermaid), code sketches as discussed

## 4. Scope
   - v1 cut line (bulleted)
   - Later (bulleted)
   - First spike: the one concrete task that proves the model
```

Keep the prose terse. Preserve diagrams, tables, and worked numbers from the conversation
rather than re-deriving them. Follow any doc conventions in `~/.claude/CLAUDE.md`.

## Step 4: Report

Show the path written and a 3-6 line summary of the sections. Note any open decisions the
doc records as still needing the user's input. Don't start implementing — if the thread
named a first spike, point at it as the next step.

## When to trigger

On explicit `/za-capture-design`, or when the user says "write the design into <file>" /
"put this in the design doc" after a substantive design discussion.
