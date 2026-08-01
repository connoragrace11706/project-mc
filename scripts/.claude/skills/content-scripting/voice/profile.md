# Sam's profile

**The agent reads this before every script.** Fields marked REQUIRED have no
default. If one is unfilled, the agent stops and asks rather than guessing —
each blank produces a specific, predictable failure, noted inline.

---

## REQUIRED — Tribe

<!-- Pick ONE primary. A secondary is allowed only if Sam is genuinely native to
both; otherwise leave blank. See niche/tribes.md. -->

**Primary tribe:** `[UNFILLED]`

Car: JDM/tuner · stance/fitment · track/time-attack · classic/restoration ·
truck/overland · Euro/VAG · American muscle · EV/tech · exotic/lifestyle ·
consumer-buyer
Moto: sportbike · cruiser/Harley · ADV · dirt/supermoto · touring · vintage/café

**Secondary (optional):** `[UNFILLED]`

> **Failure if blank:** the agent writes vocabulary from three tribes into one
> script, which is the loudest possible tourist signal. It also cannot tell
> which archetypes are hostile — **stance is structurally excluded by nearly
> every archetype in this skill**, and cruiser audiences reject the
> contrarian-critic register outright.

---

## REQUIRED — Market register

**Market:** `[UNFILLED]` — US / UK / CA / AU / EU

> **Failure if blank:** "the bonnet" in a US script. See the register table in
> `niche/tribes.md`.

---

## REQUIRED — Powertrain scope

**ICE / EV / both:** `[UNFILLED]`

> **Failure if blank:** the agent offers sound-led archetypes for an EV, where
> the sound payload does not exist. If EV is in scope, `niche/archetypes.md` §Q
> applies instead.

---

## REQUIRED — The purity tests

The agent gates archetypes on these. Answer honestly; a wrong answer here
produces content that gets Sam mocked by his own audience.

| Question | Answer | Gates |
|---|---|---|
| Does Sam wrench on his own vehicles, and at what level? | `[UNFILLED]` | Hands-in-frame — the cheapest credential in the niche |
| Is Sam visibly in full gear on camera, and is his riding competent on camera? | `[UNFILLED]` | **Judgment invitation (Archetype L).** A creator filmed in a hoodie cannot run this format at all — it inverts into a hypocrisy pile-on |
| Is Sam spending his own money on the vehicles shown? | `[UNFILLED]` | Receipts / real-cost (Archetype G) |
| Does Sam have documentation for any grievance content? | `[UNFILLED]` | Named-business content. See defamation in `niche/risk.md` |

---

## REQUIRED — Vehicles and provenance

For each vehicle likely to appear. Provenance ladder: **owned → borrowed →
press fleet → rented → someone else's.**

| Vehicle | Provenance | Notes |
|---|---|---|
| `[UNFILLED]` | | |

> **Failure if blank:** the agent implies ownership Sam does not have, or writes
> a receipts script about a borrowed car. Provenance also triggers FTC/ASA
> disclosure obligations.

---

## REQUIRED — On-camera comfort and audience equity

**On camera:** `[UNFILLED]` — comfortable / hands-only / voiceover only / mixed
per idea

**Current following, per platform:** `[UNFILLED]`

> **Failure if blank:** the agent offers **persona-dependent formats** to a cold
> account. Wordless aesthetic B-roll, caption-only meme gags and
> self-introductions all require audience recognition to work. On a cold account
> the same footage needs a text card that states a claim, and the same caption
> is just a stale meme.

---

## Footage

**Is any third-party footage in use?** `[UNFILLED]`

If yes, every clip needs a licence ID or a written grant explicitly covering
YouTube, TikTok **and** Instagram publication. Not Reddit rips, not "found on
X." See item 6 in `niche/risk.md`.

**Helmet-cam or in-car footage jurisdiction:** `[UNFILLED]`

**Any third-party audio captured in a two-party-consent state** (FL, CA, IL, PA,
WA, MA, MD)? `[UNFILLED]`

---

## Optional but useful

**Topics Sam will not touch:** `[UNFILLED]`

**Cadence:** `[UNFILLED]` — scheduled rhythm, or opportunistic when he has
something to say?

> Note: opportunistic is more defensible against the genericness gate, because a
> schedule creates pressure to publish with no particular. Also relevant:
> Instagram's rolling 30-day originality window means a stretch of reposts costs
> recommendation eligibility account-wide.

**Will performance data be logged?** `[UNFILLED]` — yes / no

> If no, delete `data/posts.json`, `scripts/log_post.py`, `scripts/perf_digest.py`
> and the `perf-analyst` agent rather than shipping dead scaffolding. The
> reflection-from-edits loop in `data/learned-rules.md` then becomes the only
> learning mechanism.
