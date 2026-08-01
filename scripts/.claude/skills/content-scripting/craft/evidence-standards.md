# Evidence Standards

Read this first, every time. It governs every claim you make, repeat, or accept.

## Confidence tiers

Every number carries one. Anything below T3 never becomes a target to optimise
against.

| Tier | Meaning | Use as |
|---|---|---|
| **T1** | First-party technical documentation or published source code | Mechanism. Safe to cite and act on. |
| **T2** | First-party statement — exec quote, help page, newsroom post | Direction and stated intent. Self-interested; never mechanism. |
| **T3** | Peer-reviewed or preregistered independent research | Effect direction. Hold magnitudes loosely. |
| **T4** | Vendor study with published methodology and sample | Directional benchmark for that cohort only. Never a target. |
| **T5** | Uncited vendor blog, SEO listicle, AI search summary | **Never encoded. Refute on sight.** |

## The four rules

**The publisher test.** If only the platform could know a thing, and the
platform has not published it, then nobody knows it. Swipe-away distributions,
ranking weights, completion thresholds, view-pool sizes and reach multipliers
are all creator-private or internal. A precise number for any of them, from any
source, is invented.

**The precision tell.** Platforms publish qualitatively by design — "a strong
indicator would receive greater weight than a weak indicator," "slightly more
important," "primarily post unoriginal content." When a source names a
multiplier or threshold the platform has never published, **the precision itself
is the warning sign.** Every fabricated number in this corpus is more precise
than any real one.

**Domain is not first-party.** `tiktok.com/discover/*` pages are SEO landing
pages aggregating user videos — creator folklore hosted on TikTok's domain. A
press-release wire is not corroboration. A vendor selling the thing the
statistic recommends is not a researcher.

**Prefer mechanisms to magnitudes.** X's mechanisms survived a full rewrite from
Scala/MaskNet to a Rust/Grok transformer across three years and two languages.
Its magnitudes were stale within months of publication and have never been
published for the current system. Write "earn the finish," not "hit 70%
completion." Write "sends unlock stranger reach," not "sends are worth 3x a
like."

## No platform has ever published a numeric ranking weight

TikTok's model card explicitly warns weighting "can change over time." xAI
stripped the entire `params` module before releasing its code. Meta publishes
prediction heads without weights. This is structural, not an oversight — which
means **every specific weight in circulation is invented.**

## The kill list — refute these, do not merely avoid them

An agent that silently omits a fake number will re-derive it the moment the user
asserts it. Push back.

**TikTok.** Tiered "view pools" and batch-testing cohorts. Graduation thresholds
("35% completion + 1.5% engagement reaches 5,000–10,000 viewers"). "70%+
completion to go viral." "Watch time is 40–50% of ranking." "TikTok counts every
loop as a view." Any best-time-to-post table. "Burned-in captions beat
auto-captions by 18–32% completion." The published architecture is per-viewer
probability scoring at request time — **structurally incompatible with a
promotion ladder.** Full-text search of the decoded Transparency Center page
returns zero hits for "view pool," "batch test," "graduation," "completion
rate."

**Instagram.** "Sends carry 3–5x the weight of likes." "10+ reposts in 30 days
removes you from recommendations." "Original content confirmed at 40–60% more
distribution." "1.7-second viewer decision window." "60–70% retention viral
threshold."

**YouTube Shorts.** "70%+ Viewed-vs-Swiped-Away is viral, below 30% dies."
"Distribution stops if it doesn't clear a threshold in 30–60 minutes." The
"three-gate seed batch." Every subscriber-conversion benchmark. **YouTube
shipped the Viewed-vs-Swiped-Away metric with zero interpretive guidance, and
the metric is confounded by traffic source, so a universal threshold is not a
coherent construct even in principle.** Compare against your own recent Shorts.

**Cross-cutting.** "High-arousal emotion causes sharing" — the Berger 2011
experiment failed to replicate twice (N=111, N=160). "Open loops work because of
the Zeigarnik effect" — 38 publications, interrupted:completed recall ratio
**0.99**, d_z ≈ 0.15. "Overproduced content gets less organic engagement" — no
controlled study, and direct contrary evidence exists.

## How fabrications propagate

Naming the mechanisms is what lets you detect fabrication in material you have
not seen before.

1. **Number mutation.** If the 70/50/30 thresholds came from one real
   measurement, the cut points would be fixed. They aren't. TikTok's "initial
   batch" is variously 200–500, 200–300, or ~500. **Numbers that drift while
   gaining precision are being generated, not transmitted.**
2. **Borrowed authority.** A "4x sustained distribution" finding attributed to
   "Tubular's 2025 report," linking only to a homepage. No such finding exists —
   and swipe-away rate is a creator-private Studio metric with no public API, so
   a panel firm could not compute it even in principle. Once a fake attribution
   enters, downstream writers stop looking for a primary source.
3. **Broken citation chains.** A multiplier credited to "Mosseri statements
   compiled in Buffer's guide." Buffer contains no multiplier and no number.
4. **Wire syndication.** A 1,000-post Reddit "study" — single day, no
   significance tests, subgroups as small as n=14, sample conditioned on the
   outcome, published by a company selling upvotes — republished identically
   across six domains. **To an agent counting sources, it now looks corroborated.**
5. **AI summarisation.** Search-engine AI summaries restate fabricated claims as
   settled fact while citing only SEO blogs, **stripping the hedges and
   attaching confident executive attributions the sources never made.** This is
   the mechanism by which every killed number will keep re-entering.

Two traps: platform policy pages may serve body text URL-encoded inside a JS
payload, so an ordinary fetch returns an empty page — **a page that renders
empty is not a page that says nothing.** And skepticism aimed at the wrong
target produces a confident error just as fast as credulity does; verify before
declaring something fabricated.

## The operating rule

> Cite the tier inline, or do not state the number.

Any claim in a platform file without a tier tag and a `last-verified` date is
treated as unverified and must not drive a scripting decision.
