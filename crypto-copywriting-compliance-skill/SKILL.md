---
name: crypto-copywriting-compliance
description: Securities-compliance gate for ALL crypto / web3 / token copywriting. Run any token-related copy through this before it ships — tweets, threads, video scripts/subtitles, captions, whitepaper text, landing-page copy, decks, Discord/Telegram/AMA replies, image concepts. Emits a PASS / FLAG / FAIL verdict with line-level findings and fixes, on the US securities-inference standard (don't imply a token is bought for profit → avoids it being argued a security). Triggers whenever copy is written or reviewed for anything crypto, blockchain, Ethereum, web3, token, meme coin, stablecoin, DeFi, NFT, DAO, staking, airdrop, RPC/node, L1/L2, or a named crypto project. LAVA / <ORG-E> / Lava Foundation / lavanet.xyz / @Lavanetxyz is a HARD trigger and loads the binding LAVA contract profile (a signed-agreement, disciplinary/termination matter). NOT for non-crypto copy (use copywriting), and NOT for general crypto chat that isn't producing or reviewing copy.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# crypto-copywriting-compliance — securities gate for web3 copy

Output is **concise** (per `/concise`): verdict + line-level findings + the fix. No preamble, no praise, no restating the input.

## When this fires
Any time copy is being **written or reviewed** for a crypto/web3/token context — crypto, blockchain, Ethereum, web3, token, meme coin, stablecoin, DeFi, NFT, DAO, staking, airdrop, RPC/node, L1/L2, or a named project. Not for general crypto conversation, not for non-crypto copy.

Two enforcement levels:
- **Generic (advisory)** — any crypto client without a binding contract. US securities-inference best practice. See `references/compliance-core.md`.
- **Profile (binding)** — a client with a signed marketing agreement. Loads that client's profile and enforces it as hard rules. **LAVA is binding** → `references/profiles/lava.md`. When the copy is for Lava / <ORG-E> / Lava Foundation, load that profile and apply it verbatim — it overrides generic guidance where stricter.

## The one-line test
> Does this copy make the token look like something you buy to make money — directly (price goes up) or indirectly (the team's work makes it go up)? If yes → it fails.

This is the Howey-inference core: a token marketed as a profit expectation derived from others' efforts reads as a security. Lead with **use/utility**, never with price/return.

## Generic banned signals (FLAG → fix; FAIL if a binding profile lists them)
- Profit framing: profit, gains, returns, ROI, yield-as-income, "make money," "passive income."
- Investment framing: investment, investor, "invest in," portfolio, "deploy capital."
- Price/appreciation: "price will rise," "to the moon," "100x," "undervalued," "store of value," "number go up," "buy the dip," "$X target."
- Scarcity-as-appreciation: "capped supply / deflationary → value up," "demand will drive price."
- Guarantees: "guaranteed," "risk-free," "can't lose."
- Imagery: rocket ships, money/cash, dollar signs, up-charts, lambos, gold.

## Generic do-instead
- Frame the token by **what it does**: utility, access, governance, staking mechanics, rewards-for-participation.
- Refer to people as users / community / participants / holders — not "investors."
- Use product/protocol/architecture imagery, not wealth imagery.
- Add risk disclaimers where the jurisdiction/client requires; never promise outcomes.

## Run protocol
1. **Profile check** — is this for a binding-profile client (LAVA)? If yes, load the profile and use its exact lexicon/vocab/imagery rules (stricter, hard-fail).
2. **Lexicon scan** — list every hit with its line.
3. **Vocabulary** — people + token framed by use, not profit? Stray label → FLAG + fix. (Binding profile = closed sets, hard-fail.)
4. **Imagery** — wealth/price imagery → FAIL.
5. **Spirit** — even with zero banned words, does the whole piece read "buy to profit"? → FLAG.
6. **Verdict.**

## Output format
```
PROFILE: <generic | lava | …>
VERDICT: PASS | FLAG | FAIL
Lexicon: [word — line/context] …
Vocabulary: [issues] …
Imagery: [issues] …
Spirit: [note]
Fix: [rewritten line(s)]
```

## Escalation
Binding-profile FAIL, a banned concept you can't cleanly swap, or unsure → for LAVA, **contact Lava management; post nothing** ("until you're sure, it's better to say nothing at all"). For generic clients, flag the risk to the client before publishing. None of this is legal advice — securities counsel governs.

## References
- `references/compliance-core.md` — generic US securities-inference rules, do/don't, Howey explainer.
- `references/profiles/lava.md` — **binding** LAVA contract gate: exact banned lexicon, closed vocab (Consumers/Developers/Validators/Providers), imagery, source examples, escalation. Backed by `01-Projects/<ORG-E>/compliance/`.
- Add `references/profiles/<client>.md` per signed crypto client.
