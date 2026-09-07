---
name: za-explain
description: Explains or brainstorms an idea in depth — a concept, design, mechanism, tradeoff, or "how would this work" question — without writing or changing code. Leans on diagrams (ASCII/mermaid), concrete examples, and structure. Invoke with /za-explain <idea or question>.
---

# za-explain

Pure thinking-out-loud mode. The user wants understanding or a brainstorm, not an
implementation. Do not edit files, do not open a PR, do not "just quickly try it" — the
deliverable is the explanation itself.

## Step 1: Pin down what's actually being asked

Restate the idea/question in one line so the user can catch a misread early. If the prompt
is genuinely ambiguous between two very different readings, ask one clarifying question;
otherwise pick the most useful reading, say which one you picked, and go.

## Step 2: Explain or brainstorm

Pick the mode that fits:

- **Explain** (a thing that already exists / is well-defined): start from the core idea in
  plain terms, then layer in mechanism, then edge cases and gotchas. Ground it in this
  codebase's real files/flows when the idea lives here — reference `file:line`.
- **Brainstorm** (open-ended "how might we" / "what are the options"): lay out 2-4
  distinct approaches, each with its shape, what it's good for, and where it breaks. Give a
  recommendation at the end, not just a menu.

Keep it concrete — use a real example, real values, a real walked-through scenario rather
than staying abstract.

## Step 3: Draw it

Include at least one diagram whenever the idea has structure, flow, or moving parts
(almost always). Use whichever fits:

- **Flow / sequence / state** — ASCII boxes-and-arrows, or a mermaid `flowchart` /
  `sequenceDiagram` / `stateDiagram`.
- **Data shape / hierarchy / relationships** — a tree, an ER-style sketch, or a nested
  block.
- **Comparison** — a plain table (approach × property).
- **Timeline / ordering** — a horizontal ASCII timeline.

Prefer ASCII for anything small (renders everywhere in the terminal); reach for mermaid
when the graph is big enough that hand-drawn ASCII gets messy. The diagram should carry
real weight, not just restate a sentence.

## Step 4: Close with the takeaway

End with the 1-3 sentence "so what" — the key insight, the recommended direction, or the
open question that most needs the user's input. If there's an obvious next step (a
spike, a doc, a decision to make), name it — but don't start doing it.

## When to trigger

On explicit `/za-explain`. Also fair to apply proactively when the user clearly wants to
understand or noodle on something ("how does X work", "what's the best way to think about
Y", "walk me through Z") and hasn't asked for a code change.
