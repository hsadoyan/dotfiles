---
name: draft-doc
description: Distill a conversation or stream-of-thought into a structured written document or ticket. Use when the user asks to write up, draft, author, or "turn this into" a design doc, RFC, runbook, 1-pager, spec, or ticket (Jira, GitHub issue, Linear) — typically after a discussion that now needs to be organized into a finished, reader-facing artifact.
---

# Drafting docs & tickets

You are converting raw material (this conversation, a stream of thought, notes) into a
**distilled artifact**: a prose doc (design doc, RFC, runbook, 1-pager) or a ticket.

The conversation that produced this can be loose and stream-of-consciousness. The artifact
cannot. A document is the distilled, reorganized form of that thinking, not a transcript of
it. Reorganize into structured thought before you write.

This guide governs the artifact only — not chat, not commits/PRs, not code comments.

## Rules

Brevity is the soul of wit. The rest is how.

- **Be brief.** One sentence beats four. Cut repetition and tangents; reader time is
  valuable. A 5000-word "1-pager" is a failure.

- **Distill before writing.** A finished doc is processed thought, not a live conversation.
  Heavy em-dash use is the tell of tangents and by-the-ways that should have been cut or reorganized.

- **Write for a reader who wasn't in the room.** Cut what only makes sense to someone who
  was: references to the discussion ("as we discussed," "to your point"), narration of how
  you reached an idea ("first I tried X, then realized Y"), and asides aimed at one person.
  State conclusions, not the trace that produced them. When the reasoning itself matters
  (rejected alternatives, tradeoffs), keep it as structured content ("Alternatives
  considered"), not as narration.
  - Test: does the sentence point at the conversation, or at the subject? If it points at
    the conversation, it leaks.

- **Drop the scaffolding.** Reference examples and analogies used to reach shared
  understanding ("AWS-style IAM," "like the Stripe model") are modeling aids, not the design.
  Specify the design in its own terms — the reader shouldn't need the analogy to follow it,
  and shouldn't inherit baggage from the reference you didn't mean to adopt. Keep a reference
  only when it genuinely informs the reader, as explicit prior art.

- **Leave the working notes behind.** Investigation apparatus — per-claim confidence tags
  (verified/inferred), a "Method" preamble, status annotations — serves the author, not the
  reader. A finished doc treats its claims as established and calls out only the exceptions
  (open questions, assumptions). Tell: a notation scheme the doc defines but barely uses is
  un-distilled carryover.

- **Front-load and keep it scannable.** Lead with what the reader needs; push supporting or
  reference detail lower, or into an appendix. 

- **Say each thing once.** If two sections cover the same item, pick its canonical home and
  cross-reference from the other in a line — don't restate it. Watch for partially-overlapping
  sections (a "Risks" list and a "Work" list describing the same fixes); that overlap is the tell.

- **Use "It's not X, it's Y" sparingly.** This antithesis and its siblings ("X isn't just
  Y, it's Z," "Rather than X, Y") are overused AI tells. Reserve them for genuine emphasis.

## Match structure to the artifact

Front-loading looks different per type. Use the skeleton the reader expects:

- **Ticket / issue:** problem → proposed change → scope / acceptance criteria. No appendix; demote detail to the bottom.
- **Design doc / RFC:** decision or summary first → context → alternatives & tradeoffs → details.
- **Runbook:** numbered steps in execution order; symptom → action.
- **1-pager:** the ask or decision first, then only the support it needs.

## Examples

**Leak → distilled.** The conversational residue is the problem, not the content.

Before:
> As we discussed, I first leaned toward Redis for the rate limiter, but after you raised the
> cost concern I realized Postgres is fine for now — so to your point, let's go with Postgres.

After:
> Use Postgres for the rate limiter. Redis was considered but rejected: the added operational
> cost isn't justified at current request volume.

The rejected alternative survives as structured rationale; the narration ("first I leaned… then realized") and the addressee asides ("as we discussed," "to your point") are gone.

**Scaffolding reference → standalone.** A reference used to build shared understanding isn't part of the design.

Before:
> We'll implement AWS-style IAM: roles and policies attached to principals, with
> explicit-deny-wins evaluation, just like AWS does it.

After:
> Access is granted through roles. A policy attaches permissions to a principal; when two
> policies conflict, an explicit deny overrides any allow.

The AWS comparison helped us agree on the model, but the reader needs the rules themselves, not an analogy they have to already know and diff against.

**Bloat → brief.** Same information, a quarter the words.

Before:
> There are a number of factors we might want to take into consideration when thinking about how
> best to approach the problem of scaling the ingestion pipeline, and one thing that came up was…

After:
> Scaling the ingestion pipeline needs three changes: batching, backpressure, and a read replica.

## Process

1. Identify the reader and what they need from this doc.
2. Extract the conclusions and decisions; drop the journey that produced them.
3. Order by importance, then shape to the artifact's skeleton above.
4. Draft.
5. Final pass: read every sentence against the leak test and cut what points at the conversation rather than the subject. This is the step most often skipped, and the one that most separates a distilled doc from a transcript.
