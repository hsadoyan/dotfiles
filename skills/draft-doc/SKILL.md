---
name: draft-doc
description: Distill raw material — a conversation, notes, or a diff — into a finished, reader-facing artifact. Use when drafting, writing up, or "turning this into" a design doc, RFC, runbook, 1-pager, spec, ticket (Jira, GitHub, Linear), pull request description, or commit message — including when preparing a PR or commit during a git workflow.
---

# Drafting reader-facing artifacts

Convert raw material (this conversation, notes, a diff) into a distilled artifact: a prose doc,
ticket, PR description, or commit message. The raw material is loose; the artifact is processed
thought, not a transcript. For a PR or commit the raw material includes the diff — and the
artifact's job is what the diff can't show: what behavior changed, and why.

Governs the artifact only — not chat, not code comments.

**Two phases — don't cut too early.** A short artifact (commit, PR, ticket) is a single
distill act: apply the contract directly. A long one (design doc, RFC) is drafted
collaboratively over a session, then finalized. While drafting, the trace, analogies,
alternatives, and hedges are working material — keep them visible; you and the user are still
reasoning from them. The cuts below are the *finalize* pass, run once the thinking has settled.
Distilling a section the user is still working through destroys the material they're using.

Brevity is the soul of wit.

Every line spends the reader's attention. It earns its place only if it tells the reader
something they need in order to act — a decision, a behavior, a consequence, a risk, or where
to look. Noisy lines spend the attention inefficiently, and mask the important content
underneath.

## The contract (every artifact)

Most of drafting is finding the lines that don't earn their place, and cutting them.

- **Be brief.** One sentence beats four. A 5000-word "1-pager" is a failure.
- **Distill before writing.** Reorganize into structured thought first. Heavy em-dash use is
  the tell of tangents and by-the-ways that should have been cut or reorganized.
- **Write for a reader who wasn't in the room.** Cut discussion references ("as we
  discussed"), narration of how you got there ("first I tried X"), and one-person asides. State
  conclusions, not the trace. Test: if a sentence points at the conversation rather than the
  subject, it leaks.
- **Don't report incidental cleanup, or the expected default.** A change bundled in that alters
  no behavior — extracting a constant, a rename, dedup, formatting — is mechanism the diff
  already shows; cut it, even if you did it earlier in this conversation because someone asked.
  Being requested or discussed makes a line *feel* important; it doesn't make it matter to the
  reader. Likewise skip what the reader already assumes (the code compiles, a convention is
  followed). Tell: an "Also …" line tacked onto the real change. **Exception:** state a default
  the change deliberately does *not* meet ("existing rows are not backfilled") — there the
  reader is already wondering.
- **Never invent a reference.** If you don't have a real ticket ID, PR number, link, or name,
  leave it out or ask for it — never emit a placeholder (`JIRA-XXXX`, `#1234`). A fabricated
  reference reads as real and breaks trust the instant the reader follows it. Omitting is
  honest; inventing is not.
- **Drop the scaffolding.** Analogies used to reach agreement ("AWS-style IAM") are modeling
  aids, not the design. Specify the design in its own terms — the reader shouldn't need the
  analogy to follow it, and shouldn't inherit baggage from the reference you didn't mean to
  adopt. Keep a reference only when it genuinely informs the reader, as explicit prior art.
- **Leave the working notes behind.** Confidence tags, a "Method" preamble, and status
  annotations serve the author — cut them, and state what you know plainly. But confidence about
  the known must not paper over the unknown: a load-bearing assumption or a known risk is
  something the reader needs, not scaffolding. Call those out explicitly (assumptions, open
  questions); don't smooth a source's hedge — "lumpy, but fine in practice" — into settled fact.
- **Front-load.** Lead with what the reader needs; push detail down or into an appendix.
- **Say each thing once.** Two sections on one item: pick its home, cross-reference in a line.
- **Use "It's not X, it's Y" sparingly.** This antithesis and its siblings are overused tells.

## Prose docs & tickets

Skeletons (front-loading per type):
- **Ticket:** problem → change → scope / acceptance criteria.
- **Design doc / RFC:** decision or summary → context → non-goals → alternatives & tradeoffs → details.
- **Runbook:** numbered steps in execution order; symptom → action.
- **1-pager:** the ask first, then only its support. <600 words.

Future work and roadmap belong here — state them as structured content. State non-goals
explicitly rather than scattering them across sections, and include only what the material
supports — don't invent scope to fill a section. Keep rejected options as "Alternatives
considered," not narration.

## Pull requests & commits

Informal and brief — short descriptions get read; most PR descriptions are a few sentences.

- **Describe behavior, not mechanism.** The diff shows the mechanism; state the effect it
  produces. Rewrite a line about *how* into one about *what changes for the reader*; cut it if
  nothing changes.
  - ✗ "Adds an `if user.confirmed_at == nil` guard that returns early"
  - ✓ "Unconfirmed users skip the processing flow instead of timing out — fixes the p95 latency"
- **PR shape:** what changed and why → behavior a reviewer must verify → risks / out of scope.
  Descriptive mood ("Trims whitespace from auth tokens"). Drop `## Summary` / `## Test plan`
  headers unless there are multiple distinct changes or a non-obvious test plan.
- **Commit shape:** imperative subject naming the effect ("Trim whitespace from auth tokens");
  body explains *why* — the diff shows *what*. Read out of context (git log, blame): no
  conversational residue or "matches pattern" justifications.
- **No future-work promises.** Phrase gaps as limits of *this* change ("doesn't handle X" ✓,
  "will fix in a follow-up" ✗). Light scope-bounding is fine ("this PR only adds the read
  path"). Commits cut forward-looking mentions entirely.
- **Links.** Link the Jira ticket when one exists. PR backlinks to prior PRs help the reviewer
  ("Followup to #1234") — keep them out of commits.
- **Repro steps, commands, screenshots** — only when they materially help review.

## Examples

**Leak → distilled:**
> ✗ As we discussed, I first leaned toward Redis, but after your cost concern I realized Postgres is fine.
> ✓ Use Postgres for the rate limiter. Redis was rejected: operational cost isn't justified at current volume.

**Mechanism → behavior:**
> ✗ Defines the timeout as a named constant and adds an early return for unconfirmed users.
> ✓ Unconfirmed users skip the processing flow instead of timing out — fixes the p95 latency.

The constant is incidental cleanup (noise); the early return is mechanism. The behavior change
and its reason are what the reviewer needs.

**Scaffolding → standalone:**
> ✗ We'll implement AWS-style IAM, just like AWS does it.
> ✓ Access is via roles; a policy attaches permissions to a principal, and an explicit deny overrides any allow.

**Bloat → brief:**
> ✗ There are a number of factors to consider when thinking about how best to scale the ingestion pipeline…
> ✓ Scaling the ingestion pipeline needs three changes: batching, backpressure, and a read replica.

**Load-bearing, not scaffolding (keep it):**
> A hedge or assumption can look like a by-the-way and get cut. "Holds under ~10k namespaces per
> cell; above that the in-memory index needs rethinking" is not an aside — it's the assumption
> the design rests on and the risk the reader inherits. Keep it, stated as an explicit
> assumption. The cut bias is right by default; over-cutting strips exactly these.

## Process

1. Identify the reader and what they need.
2. Extract conclusions and decisions (for a PR/commit, the behavior change and why); drop the
   path that produced them.
3. Order by importance; shape to the skeleton.
4. Draft.
5. Final pass — cut every line that leaks (points at the conversation) or restates mechanism
   the reader could read themselves. The most-skipped step, and the one that separates a
   distilled artifact from a transcript.
