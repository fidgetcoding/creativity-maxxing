# Quality gates — pre-ship checklist

Run on every draft before returning copy. Every gate is binary: pass or fail. No scales. No maybes.

## Ship rubric

- All 7 proofreading gates pass (`proofreading.md`). Run these FIRST.
- All 10 non-negotiable gates pass.
- All 5 voice gates pass.
- All 5 craft gates pass.
- At least 3 of 5 psychology gates pass.

Any proofreading fail → fix immediately, re-run.
Any non-negotiable fail → rewrite.
Voice or craft fail → rewrite.
< 3 psychology gates pass → tighten.

## 10 non-negotiable gates

### Gate 1 — Banned-word scan
- [ ] Zero AI-tell verbs: elevate, unlock, harness, leverage, empower, revolutionize, transform (puffed), delve, streamline.
- [ ] Zero AI-tell adjectives: seamless, robust, cutting-edge, next-gen, best-in-class, world-class, game-changing, transformative, holistic, comprehensive (filler), innovative (filler), passionate (self-claim).
- [ ] Zero AI-tell phrases: "in today's", "it goes without saying", "let's dive in", "we believe", "at the intersection of", "more than just".

Run via grep on the output. Zero hits = pass.

### Gate 2 — Em-dash count
- [ ] Em-dashes ≤ 1 per 200 words.
- [ ] No em-dash chains (2+ em-dashes in one paragraph).

Remedy: replace with period, colon, or parentheses.

### Gate 3 — Corporate hedge scan
- [ ] Zero: "help to", "work to", "strive to", "seek to", "aim to", "endeavor to", "committed to", "dedicated to", "passionate about", "look to".

Remedy: cut the hedge. "We help to build" → "We build."

### Gate 4 — Filler opener ban
- [ ] No opening with: "In today's...", "In the modern era...", "In a world where...", "Imagine a...", "Now more than ever...", "It goes without saying...", "Needless to say...", "Let's dive in...", "Let's explore...".

Remedy: open with a noun, verb, or named subject that earns the read.

### Gate 5 — Tri-colon rhythm check
- [ ] Fewer than 30% of sentences follow "A, B, and C" three-item pattern.

Count rule-of-three sentences. If > 30%, vary list lengths (2, 4, or single-item emphasis).

### Gate 6 — Rhythm variance check
- [ ] Sentence-word-count standard deviation > 4.

Measure: word count per sentence, compute stdev. Rhythm should be jagged (3, 18, 8, 14, 2, 21, 6 — stdev ~7), not flat (14, 15, 13, 16, 14 — stdev ~1).

### Gate 7 — Read-aloud test
- [ ] Would a human say this at a bar?
- [ ] Do you stumble anywhere reading aloud?
- [ ] Could you text this to a friend without embarrassment?

Any "no" = rewrite the stumbling section.

### Gate 8 — Compression check
- [ ] Final word count is 40-60% less than the hot draft.
- [ ] Every word earns its place on the 2x test (can you cut half and keep meaning?).

### Gate 9 — Specificity check
- [ ] At least one concrete number, named reference, or dated outcome per 150 words.
- [ ] No vague claims ("significant", "meaningful", "substantial") without specifics attached.

### Gate 10 — Strip-brand test
- [ ] Swap the brand name for a competitor's. The copy no longer fits.

If it still fits, the copy is generic. Rewrite with brand-owned specificity.

## 5 voice gates

### V1 — Voice declared
- [ ] Voice picked from `voice-library.md` (cluster file pulled).
- [ ] Register declared (formal / casual / dry / warm / urgent).
- [ ] POV declared (you-dominant / brand-we / third-person).
- [ ] Cadence declared (flat hammer / conversational / rhythmic punch / whisper / direct pitch).

If you can't state these four before drafting, you're not ready to write.

### V2 — Voice consistency
- [ ] The copy reads as one master, not blended. No mid-paragraph voice swap.

### V3 — No anonymous prose
- [ ] If you strip the brand and the copy, you can still identify which master voice it was written in.

### V4 — Cadence on the page
- [ ] Sentence-length variance reflects the declared cadence.

### V5 — Read-aloud signature
- [ ] The copy sounds the way it looks. No silent prose.

## 5 craft gates

### C1 — Headline earns the read
- [ ] 3-10 words.
- [ ] First word is load-bearing (verb or named subject).
- [ ] Strip-brand test passes.

### C2 — Framework declared and visible
- [ ] Framework picked from `frameworks.md` cluster.
- [ ] The structure is visible in the beat count and word weighting.

### C3 — Specificity stack
- [ ] At least 3 concrete proofs (numbers, names, dates) per long-form piece.

### C4 — No throat-clearing
- [ ] No paragraph opens with a transition word ("However," "Therefore," "Additionally").
- [ ] No sentence whose only job is to introduce the next sentence.

### C5 — One offer, one ask
- [ ] One CTA per page or section.
- [ ] Singular next step. Specific, low-friction.

## 5 psychology gates (3 of 5 must pass)

### P1 — Awareness state match
- [ ] Reader's awareness state identified before drafting.
- [ ] Lead matches the state (Unaware → story; Most-Aware → just the offer).

### P2 — Cialdini stack (3+)
- [ ] Reciprocity, commitment, social proof, liking, authority, scarcity, or unity — at least 3 visible in the copy.

### P3 — Risk reversal
- [ ] A guarantee, free trial, money-back, or low-commitment first step appears in the copy.

### P4 — Real scarcity (or none)
- [ ] If urgency appears, it's tied to a specific number, name, or date.
- [ ] No "limited time only," "act now," "don't miss out."

### P5 — Life Force 8 hit
- [ ] The offer connects to at least one of the 8 hardwired desires (survival, comfort, status, social approval, etc.).

## Final ship rule

If all proofreading gates pass AND 10/10 non-negotiables pass AND 5/5 voice pass AND 5/5 craft pass AND 3+/5 psychology pass — ship.

Otherwise rewrite the failing beats.
