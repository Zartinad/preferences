---
name: za-start
description: Starts implementation of a plan, design, or idea. Before any code is written it settles where the work happens — by default a fresh worktree pool slot on its own branch (via `wt claim`) unless you've already said otherwise — then works the plan incrementally. Invoke with /za-start [what to build].
---

# za-start

Kicks off implementation of a plan or idea. Its one job before any code gets written: get
the working location right. By default that means a fresh worktree pool slot on its own
branch — not the current checkout — matching the worktree-centric flow. Then it works the
plan.

Do not create or edit files until Step 2 is resolved.

## Step 1: Pin down what's being implemented

Source, in order:
- the `/za-start <text>` argument, if given
- an approved plan from the preceding turn (ExitPlanMode), a design doc, or a
  `/za-explain` brainstorm earlier in this conversation
- the user's most recent described idea

Restate it in one line. If the scope is genuinely ambiguous, ask once before proceeding —
otherwise pick the most reasonable reading, say which, and continue.

## Step 2: Settle the working location

Default: a **new worktree pool slot** on a dedicated branch (`wt claim`), leaving the
current checkout untouched.

Skip the question and honor an explicit instruction when the user has already said:
- "here" / "in this branch" / "no worktree" → current checkout
- "in a worktree" / "on branch az/x" / a specific slot → that
- you're already inside a pool slot or dedicated worktree for this work → stay put

Otherwise ask once, as multiple choice:
- **New pool worktree** (recommended) — `wt claim az/<name>` — isolated branch + slot,
  keeps this checkout clean
- **Current checkout** — work on the branch checked out here now

Propose a branch name derived from the plan: short, kebab-case, `az/` prefix. Put it in
the option text so the user can veto it in the same step.

## Step 3: Enter the worktree (if chosen)

- Base: the repo's default branch, unless the plan clearly builds on another branch — then
  pass it explicitly.
- Run `wt claim az/<name> [base]`. It creates the branch if new, takes or creates a pool
  slot, runs the bootstrap chain, and cd's in.
- If `wt` isn't defined (not this machine / not set up), fall back to
  `git worktree add "$WT_HOME/<repo>/<name>" -b az/<name> <base>`; failing that, say so and
  proceed in the current checkout.
- Confirm the landing spot — path + branch — in one line before writing anything.

If "current checkout" was chosen and it has uncommitted changes, surface that before
starting.

## Step 4: Implement

Work the plan top to bottom. Build incrementally — one capability at a time — and run or
verify as you go rather than only at the end. From here it's a normal implementation
session; this skill's role was to start it in the right place.

## When to trigger

On explicit `/za-start`. Also reasonable when the user says "let's build it" / "start
implementing" / "go ahead" right after a plan or design has been laid out and no working
location has been established.
