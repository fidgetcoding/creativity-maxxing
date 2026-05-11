---
name: copywriting
description: Master-level copywriting for headlines, hero copy, body copy, manifestos, proposal docs, sales letters, landing pages, ads, and brand voice. Trained on Bernbach, Hegarty, Abbott, Trott, Wieden, Sugarman, Sackheim, Schwartz, Bencivenga, Gossage, Krone, McElligott. Use when the user asks for copy, headline, tagline, ad copy, body copy, hero, CTA, button microcopy, manifesto, proposal copy, pitch copy, landing page, brand voice, naming, positioning, value prop, "make this sound better", "rewrite this paragraph", or anti-AI-slop rewrite. Suspended by `/concise` for chat — this skill takes over when the deliverable lands with a human audience.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# Copywriting

Write like a human. Sell without begging. Every word earns its place.

## The 5 laws (non-negotiable)

1. **Every word earns its place.** If you can cut it without losing meaning, cut it.
2. **Human first.** Read aloud. If it sounds like a robot, rewrite.
3. **One idea per line.** Break rhythm on purpose.
4. **Specific beats vague.** A number, a name, a date — always.
5. **The reader is a genius.** Write up, never down.

## The process (run in order)

1. **Diagnose awareness state.** Schwartz's 5: Unaware → Problem-Aware → Solution-Aware → Product-Aware → Most-Aware. The lead changes per state. See `references/psych-triggers.md`.
2. **Pick the voice.** One master from the picker below. Pull the cluster file.
3. **Pick the framework.** One structure from the picker below. Pull the cluster file.
4. **Draft hot.** Write too long on purpose. Don't edit yet.
5. **Compress 40-60%.** Rules in `references/compression.md`.
6. **Humanize.** Strip AI-tells. Rules in `references/humanization.md`.
7. **Proofread.** The 7 scans in `references/proofreading.md`.
8. **Run quality gates.** The binary checklist in `references/gates.md`.

## Voice picker

| Brand type / brief | Voice | Cluster file |
|--------------------|-------|--------------|
| B2B advisory, direct, fast | Trott / Bencivenga / Wieden | `voices-punch.md` |
| Luxury, heritage, editorial | Abbott / Krone | `voices-restraint.md` |
| Founder letter, mission, challenger trust | Bernbach / Gossage | `voices-honesty.md` |
| DTC, sales letters, awareness work | Sugarman / Sackheim / Schwartz | `voices-dtc.md` |
| Challenger brand, zag-when-zigs | Hegarty / McElligott | `voices-challenger.md` |

## Framework picker

| Copy task | Framework | Cluster file |
|-----------|-----------|--------------|
| Landing page, hero | AIDA | `frameworks-attention.md` |
| Problem-led, paid ad | PAS | `frameworks-attention.md` |
| Transformation pitch | BAB | `frameworks-attention.md` |
| Section-level, proposal section | 4Ps | `frameworks-sales.md` |
| Product detail, feature | FAB | `frameworks-sales.md` |
| Cold sales letter | AIDCA | `frameworks-sales.md` |
| Long-form sales letter | Schwartz 5-stage | `frameworks-awareness.md` |
| Long narrative, email body | Slippery Slide | `frameworks-awareness.md` |
| Executive memo, consultative pitch | SCQA | `frameworks-awareness.md` |

## Inline non-negotiables (enforced every output)

**Banned AI-tells (zero tolerance):** elevate, unlock, harness, leverage, empower, seamless, robust, cutting-edge, best-in-class, world-class, game-changing, revolutionize, transformative, holistic, synergy, ecosystem, journey (metaphor), delve, dive deep, passionate (self-claim), comprehensive (filler), innovative (filler), SaaS (use "software" / name the category), flywheel (use "engine" / "loop").

**Banned phrases:** "In today's...", "In a world where...", "Imagine a...", "Let's dive in", "We believe", "At the intersection of", "More than just", "It's not just X, it's Y" (as default), "Move the needle", "Actionable insights", "Thought leadership", "Meaningful impact".

**Banned hedges:** "help to", "work to", "strive to", "seek to", "aim to", "committed to", "dedicated to", "passionate about", "look to". Cut the hedge — just say the verb.

**Punctuation:**
- Em-dashes ≤ 1 per 200 words. No em-dash chains.
- Exclamation marks: zero on proposal docs; max 1 per 2,000 words elsewhere.
- Always smart quotes. Never straight.

**Rhythm:**
- Sentence-length stdev > 4. AI writes flat (14, 15, 13, 16). Humans write jagged (3, 18, 8, 14, 2, 21, 6).
- Tri-colon rule-of-three < 30% of sentences.
- Contractions on (don't, we're, it's). Uncontracted only for rare emphasis or specific register.

**Pronoun discipline:**
- "You" dominates. Never "the user," "the customer," "the individual," "one."
- "We" only on commitments and stance.
- Vague "they" banned — name the group on first mention.

## Compression targets

| Format | Target |
|--------|--------|
| Headline | 3-10 words |
| Hero body | 15-60 words |
| Section body | 40-120 words |
| CTA button | 2-5 words |
| Proposal doc | 500-900 words |
| Landing page (short / long) | 250-450 / 800-2,000 words |

Draft hot → cut 40-60% → target.

## Output format

For substantial copy work:
```
CONTEXT
Voice: [master], Framework: [name], Awareness: [stage], Cadence: [type]

COPY
[the actual output]

WHY
[2-3 sentences naming the specific moves]

ALTERNATIVES
1. [variant]
2. [variant]
3. [variant]
```

For short asks (single headline, single CTA): drop CONTEXT block, just deliver Copy + Why + 2-3 alternatives.

## Reference map (pull on demand)

- `references/voice-library.md` — picker. Pull when starting any draft.
- `references/voices-*.md` — pull the cluster that matches the picked voice.
- `references/frameworks.md` — picker. Pull when starting any draft over 50 words.
- `references/frameworks-*.md` — pull the cluster that matches the picked framework.
- `references/headlines.md` — pull for hero, subject line, tagline work.
- `references/body-copy.md` — pull for prose sections over 60 words.
- `references/cta-patterns.md` — pull for any button or close-line.
- `references/proposal-patterns.md` — pull for pitch docs / proposals only.
- `references/psych-triggers.md` — pull when awareness state needs to be resolved or when stacking persuasion levers.
- `references/compression.md` — pull during the cut pass.
- `references/humanization.md` — pull during the AI-detox pass.
- `references/proofreading.md` — pull before quality gates, every draft.
- `references/gates.md` — pull as final check before shipping.

## When in doubt

- Honesty needed → Bernbach.
- Energy needed → Wieden.
- Restraint needed → Abbott.
- Proof needed → Bencivenga.
- Speed/B2B → Trott.

And cut another 20%.

## Hierarchy

In-turn instruction supreme. Override any rule above when the user explicitly asks for something different. Hard rules persist (no AI-tells, no fake names, no UTC, no claude-flow coauthor).
