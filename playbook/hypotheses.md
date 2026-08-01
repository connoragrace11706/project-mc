# Hypotheses

Things we believe but have not proven. Each needs a stated test and a result
that would falsify it. Once a hypothesis holds across 3 posts it graduates to
`what-works.md`; once it fails clearly it moves to `what-failed.md`.

**These are starting priors, not findings. Do not cite them as evidence.**

---

## BASELINE — 2026-07-31

First real measurement. Everything from here is a delta against these numbers.
Sources: `data/snapshots/2026-07-31/youtube.json` (API) and
`data/manual/tiktok-2026-07-31/` (TikTok export, 60-day + all-time per video).

### YouTube — `@project.mc.racing` (`UCcQsA-i3zAWroB4pRnCU1uA`, "The MC")

| | |
|---|---|
| Subscribers | **25** |
| Total views | **6,219** |
| Videos | 5 live (+2 dead legacy items from a former gaming channel) |
| Long-form | **Zero.** All content is Shorts. |
| Views per Short | **830 – 1,645** (remarkably consistent) |
| View→sub conversion | **~0.4%** |
| Comments | **1 across the entire channel** |
| Cadence | 3 Shorts Jun–Jul 2023, 1 Aug 2024, 1 Jul 2026. Never consistent. |

### TikTok — `@project.mc.racing`

| | |
|---|---|
| Followers | **UNKNOWN** — Connor to supply |
| Videos in export | 10 |
| Best video | **24,344 views** (S1000RR, Feb 11) |
| Median video | ~1,500 views |
| Daily views when not posting | **0–4.** The account is effectively dormant. |
| Post-day spike | ~700–1,000 views, decaying to zero within ~5 days |
| Comments | 0–5 per video |

### The cross-platform pattern

**People watch, they like, and nobody talks.** Comments are near zero on both
platforms. Likes are healthy. That is not a reach problem — it's a
*"nothing here asks me for anything"* problem. No question, no stake, no reason
to reply, no reason to subscribe.

---

## OBSERVATIONS — recorded, not yet hypotheses

Things the baseline shows plainly. Not patterns yet (see the 3-post rule).

### O1 — The motorcycle outperforms the car. Badly.

| Subject | Views | Like rate |
|---|---|---|
| S1000RR — "The First season was just the beginning" (Feb 11) | **24,344** | 6.2% |
| Motorcycle — heartbreak/mental health (Jul 23) | 4,451 | **24.3%** |
| S1000RR — "Pretty in pink" (Feb 26) | 4,128 | **20.3%** |
| S1000RR — "Had to join the s1k family" (Aug 16) | 1,927 | 9.1% |
| **Car** — "I think she hates me" (Feb 24, 33 hashtags) | 2,027 | **1.2%** |
| **Car** — "I am going broke for this car" (Jun 19) | 1,006 | 5.6% |
| **Car** — Apex rear suspension shoutout (Jul 30) | 750 | 5.9% |

The bike beats the car on **both reach and engagement rate.** Every car post
sits at the bottom of the table.

**Caveats that matter before anyone panics:**
- The top bike video rode a trend audio (`#FunkNoCapCut`). That's *borrowed*
  distribution, not an audience — and it did not convert into a following.
- The car posts are the newest, going out to an account that had been dormant
  for months. Cold start, not a fair fight.
- n is tiny. Three car posts is not a verdict.

**But it is a real tension with `brand/profile.md`, which is 100% about the M3
and does not mention the bike at all.** Needs a decision, not avoidance.

### O2 — Hashtag stuffing is not working

The car post with **33 hashtags** ("I think she hates me") has the **lowest like
rate on the account at 1.2%** — roughly 5× worse than posts with a handful.
Cross-platform tags (`#tiktok` on YouTube) do nothing at all.

### O3 — Titles are doing no work

*"Ifykyk."* *"🤫🤫🤫——-"*. *"M3!!! 🤣🤣"* + twelve hashtags. These carry no
information and no curiosity gap. Distribution is already being handed to us
(830–1,645 views per Short with zero promotion) — the loss is at packaging,
not reach. **Cheapest available fix.**

### O4 — There is no bucket to catch anything

Zero long-form. A viewer who likes a Short taps through and finds five
disconnected clips and a dead 2018 gaming livestream. There is nothing to
subscribe *to*. This is the most likely single explanation for the 0.4%
conversion rate.

### O5 — YouTube currently beats TikTok for build content

Same-day comparison, 2026-07-30: the subframe Short did **1,242 views on
YouTube** vs **750 on TikTok** for the suspension post. Small sample, but it
cuts against the assumption that TikTok is the better cold-reach channel here.

---

## H1 — Real cost numbers outperform generic build content
- **Claim:** Posts with a specific dollar figure in the hook beat equivalent
  build posts without one.
- **Why we think so:** Nobody in this niche is honest about money; the
  information is genuinely scarce, and scarcity drives sharing.
- **Test:** 3 posts with a cost hook vs. 3 without, same platform and format.
- **Falsified if:** Cost posts show no median lift, or lower engagement.
- **Data points so far: 1 (weak, does not yet support the claim).**
  *"I am going broke for this car"* (TikTok, Jun 19): 1,006 views, 5.6% like
  rate. Beat the Apex suspension post on engagement (5.9% — effectively a tie)
  but got no distribution lift. It is a *sentiment* about money, not a *number* —
  the real test needs an actual figure in the hook. **Not evidence yet.**

## H2 — Failure content outperforms success content
- **Claim:** "This broke / I got this wrong" beats "look what I finished."
- **Why we think so:** Lower ego threshold for the viewer, higher trust, and a
  built-in curiosity gap.
- **Test:** Tag each post success/failure, compare medians over 6 posts.
- **Falsified if:** Failure posts underperform on retention.
- **Data points so far:** 0. Nothing in the archive is framed as failure.

## H3 — The "normal job" framing is the strongest cold-audience hook
- **Claim:** Leading with the constraint (working full time, no lift, small
  garage) converts cold viewers better than leading with the car.
- **Why we think so:** It's the differentiator. The car alone competes with
  everyone; the constraint competes with almost nobody.
- **Test:** A/B the first 3 seconds on Shorts — car-first vs. constraint-first.
- **Falsified if:** No difference in 3s retention.
- **Data points so far:** 0.

## H4 — Long-form drives followers, shorts drive views, and they don't trade
- **Claim:** Shorts inflate view counts without moving subscribers; long-form
  moves subscribers. Judge them on different metrics.
- **Test:** Track follows-per-1000-views separately by format.
- **Falsified if:** Shorts convert followers at a comparable rate.
- **Data points so far:** 0 for long-form (**none exists**). The Shorts half is
  strongly consistent with the claim — 6,219 views has produced 25 subscribers.
  Cannot be confirmed until at least one long-form video ships. See **O4**.

## H5 — Emotional framing outperforms technical framing on TikTok *(new)*
- **Claim:** Posts built on a feeling ("going broke," heartbreak, "she hates
  me") out-engage posts built on a spec or a part.
- **Why we think so:** The two highest *like rates* on the account (24.3% and
  20.3%) are both emotional/aesthetic, not technical. The suspension-kit
  shoutout — the most technically useful post — sits near the bottom.
- **Test:** Over the next 6 TikToks, tag each emotional / technical and compare
  median like rate.
- **Falsified if:** Technical posts match or beat emotional ones on like rate.
- **Why it matters:** If true, the build content needs an emotional frame
  wrapped around the technical payload rather than leading with the part. That
  is a writing instruction, not a content-strategy change.
- **Data points so far:** 4 (suggestive, not confirmed).

---

## Open question for Connor — not a hypothesis, a decision

**Does the S1000RR belong in the brand?**

It is currently the best-performing content by a wide margin and it appears
nowhere in `brand/profile.md`. Three honest options:

1. **Exclude it.** The M3 is the brand; the bike views came from trend audio and
   converted nothing. Clean, focused, ignores the only thing that has worked.
2. **Include it as "The Life."** Same guy, same money problem, same garage.
   Fits the existing 15% pillar without diluting the build.
3. **Test it deliberately.** Post bike content on a fixed ratio for 6 weeks and
   measure whether it brings followers who then watch car content — or just
   inflates view counts with an audience that leaves.

**Recommendation: 3, then 2 if it holds.** The bike's numbers are real but
unproven as an audience-building mechanism, and guessing either way costs more
than measuring.

---

*Add new hypotheses as they come up. An idea written down and tested is worth
more than an idea acted on because it sounded right.*
