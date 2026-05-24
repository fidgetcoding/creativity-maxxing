# Crypto copywriting compliance — generic core

Advisory baseline for **any** crypto/web3/token copy where there's no binding client contract. When a client has a signed marketing agreement, its profile in `profiles/` overrides this where stricter (e.g. LAVA).

Not legal advice — securities counsel governs. This is risk-reduction for marketing copy.

## Why this exists — the Howey inference
In the US (and many jurisdictions), an asset is a **security** if people put money in **expecting profit derived from the efforts of others**. Token marketing is the evidence regulators read. A tweet, whitepaper, or video that frames the token as a way to make money — directly (price up) or indirectly (the team's roadmap will make it valuable) — can be used to argue the token is an unregistered security. Consequences: enforcement, fines, delistings, shutdown.

So the copy goal: present a **product you use**, not an **asset you profit from**.

## The one-line test
> Does this make the token look like something you buy to make money? If yes → it fails.

## Banned / high-risk signals
| Category | Examples |
|---|---|
| Profit | profit, gains, returns, ROI, earnings, "passive income," "make money," "yield" (as income) |
| Investment | investment, investor, "invest in," portfolio, "deploy capital," "fund" |
| Price/appreciation | "price will rise," "to the moon," "100x," "undervalued," "store of value," "number go up," "buy the dip," "$X target," "ath" |
| Scarcity→value | "capped supply means value up," "deflationary," "demand drives price" |
| Guarantees | "guaranteed," "risk-free," "can't lose," "safe bet" |

## Do instead
- Frame by **function**: what the token does — utility, access, gas/fees, governance, staking mechanics, rewards for participation, network role.
- Call people **users / community / participants / holders / members** — never "investors."
- **Imagery:** protocol diagrams, product UI, network/architecture art, community/culture content. Never rockets, cash, $, up-charts, lambos, gold.
- **Risk language:** where required, add disclaimers ("not financial advice," jurisdiction notes); never promise outcomes.
- **Meme coins / culture tokens:** humour and community are fine and even protective (clearly not an investment pitch) — but the same price/profit lines are still banned. "Funny" doesn't exempt "buy now, 100x."
- **Stablecoins:** avoid "yield," "earn," "returns" on holdings; frame as payments/settlement/utility. Peg-stability claims carry their own regulatory risk — keep factual, no guarantees.

## Run protocol (generic)
1. Lexicon scan → list hits with line.
2. Vocabulary → people/token framed by use not profit?
3. Imagery → wealth/price imagery?
4. Spirit → does the whole piece read "buy to profit" even without banned words?
5. Verdict: PASS / FLAG (fixable, show swap) / FAIL (don't ship, flag to client).

## Output format
```
PROFILE: generic
VERDICT: PASS | FLAG | FAIL
Lexicon: [word — line/context] …
Vocabulary: [issues] …
Imagery: [issues] …
Spirit: [note]
Fix: [rewritten line(s)]
```

## Escalation
Generic clients: flag the risk to the client/their counsel before publishing. Binding-profile clients: follow that profile's escalation (LAVA → contact Lava management, post nothing).
