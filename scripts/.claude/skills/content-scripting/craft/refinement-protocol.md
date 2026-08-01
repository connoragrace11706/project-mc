# The eight-pass pipeline

Each pass has one job, one input, one output.

**Full** (1–8) for anything Sam will actually produce.
**Quick** (1, 2, 3, 6a, 8) for throwaway ideas and variations.

---

## Pass 1 — Intake

Establish four things and refuse to proceed without them.

1. **Platform and surface.** Not "TikTok" but TikTok For You vs Search vs Local
   — TikTok publishes different dominant factors for each [T1]. Not "Instagram"
   but Reel-for-strangers vs carousel-for-followers.
2. **Goal, expressed as a modelled action.** Reach strangers → sends (Reels),
   search retrieval (TikTok). Deepen followers → likes, saves, comments. Route
   to long-form → the Related Video handoff (Shorts). **If the goal cannot be
   expressed as an action the platform separately models, the goal is wrong.**
3. **The particular. Hard gate.** At least one thing that could only come from
   Sam: a number, a part, a first-hand observation, a cost, a mistake, a stake.
   Without it, return **"no particular — what actually happened?"** rather than
   a draft. Genericness is what platforms police and audiences detect, and craft
   does not compensate for it.
4. **Provenance and commercial status.** Owned / borrowed / press fleet / rented
   / someone else's — this decides which archetypes are available and what must
   be disclosed. Over-60s if TikTok monetisation matters. Disclosure toggle if
   commercial.

Also confirm from `voice/profile.md`: **tribe** and **market register**. Both are
hard fields with no default.

Reads: `platforms/$platform.md`, `voice/profile.md`, `voice/taste.md`,
`niche/tribes.md`.

---

## Pass 2 — Angle selection

Choose *what claim this makes*, before any wording exists. Generate 3–5 angles
and score each:

- **Does the target viewer have a foothold?** A gap opened where they have no
  purchase produces indifference, not curiosity.
- **Which Loewenstein trigger?** Named explicitly. Prefer 2 (anticipated
  resolution) or 3 (expectation violation). Trigger 2 upgrades to a force
  multiplier if the script can make the viewer *predict*.
- **Does it survive the send test?** "This is for the person who ___."
  Mandatory for Reels, strong for TikTok, ignorable for Shorts.
- **Which archetype from `niche/archetypes.md`?** Check it against the tribe —
  the archetype set is not tribe-neutral.
- **Practical value and interest are first-class**, not consolation prizes. The
  field data puts them level with awe and above anxiety, and the top-performing
  automotive Shorts corpus is overwhelmingly instructional.
- **Is there a searchable phrasing?** On TikTok, search value is a paid
  monetisation metric with a content-gap tool [T1]. This is the cheapest
  structural lever available.

Output: one angle, plus a one-line statement of **the gap it opens and the
trigger it uses**, carried forward as a constraint on every later pass.

Reads: `craft/attention.md`, `craft/share-psychology.md`,
`niche/archetypes.md`.

---

## Pass 3 — Hook generation

Produce 5–8 candidates as **foothold-then-gap structures**, per
`craft/hooks.md`. Every candidate names both beats separately, plus its trigger,
concreteness band, and muted version.

Platform first-beat constraints — read from the platform file, do not recall:

| Platform | The first beat must |
|---|---|
| TikTok | Show the situation already in progress. Skip is an explicitly modelled negative [T1] — throat-clearing trains it. |
| Reels | Survive a 2-second skip (a named prediction head, T1). Most concrete visual or sharpest line. |
| Shorts | Read as a complete proposition on a **muted, thumbnail-sized frame.** One of YouTube's three named devices: a question, a surprising fact, or a visually captivating moment [T1]. |

Niche timing budget, measured: **faceless/voiceover starts speaking by
0.9–1.7s** (no face means no grace period); **on-camera up to ~2.2s.** Past 2.5s
you need brand equity carrying it.

Then run the Scroller pass on frame 1 alone before proceeding.

Reads: `craft/hooks.md`, `craft/attention.md`, `niche/archetypes.md`,
`platforms/$platform.md`.

---

## Pass 4 — Script body

Lay out the **curiosity-debt schedule** before writing a word. Then write.

Also in this pass:

- **The comment hook. Exactly one, deliberate.** An omission, a contestable
  ranking, a visible mistake left in, or a genuine open question. **One, not
  three.** Stacked hooks read as bait, and on TikTok engagement bait is an
  eligibility problem, not a taste problem.
- **The sound-off layer and the sound-on layer as separate deliverables.**
  Burned-in text carries full meaning alone; audio adds a *distinct* reward.
  Never a transcript of the other. See the mute contract in
  `niche/archetypes.md`.
- **The close.** Loop seam or hard stop for TikTok. CTA in the final 5 seconds
  with verbal *and* visual cue for Shorts [T1]. Send prompt after the payoff for
  Reels, spoken and on-screen. **Never a trailing "anyway, thanks for
  watching."**

Reads: `craft/structure.md`, `craft/curiosity-debt.md`, `platforms/$platform.md`,
`voice/corpus.md`.

---

## Pass 5 — Adversarial refinement

Delegate to `voice-critic`. Five personas, each with an **action**, not just a
question — a persona without an action is decoration.

| Persona | Question | Action |
|---|---|---|
| **Skeptic** | Why should I care, and why should I believe you? | Every abstract claim gets a concrete example or gets cut. Every assertion about a result gets replaced by a demonstration of it. |
| **Expert** | What would I nitpick? What caveat did you skip? | Fix the gap, **or make it the deliberate comment hook.** Never leave it accidental. |
| **Scroller** | Would I stop? Would I still be here at second 5? | Read frame 1 only. If it doesn't stop you, return to pass 3. |
| **Competitor** | How is this different from the ten similar pieces already in the feed? | Name the differentiator. If there isn't one, the **angle** is wrong — return to pass 2, not to line editing. |
| **Editor** | What can I cut? | Cut 15% of connective tissue, then verify the debt schedule still balances. |
| **Enthusiast** *(niche-specific)* | Does the person who wrote this actually know cars/bikes? | Run the terminology traps and the tribe check in `niche/authenticity.md`. One error invalidates the script. |

The Competitor pass has a mechanical justification most people miss: TikTok's
similarity check swaps out too-similar candidates, and Instagram's early-stage
ranker judges topical similarity *before* quality is evaluated [both T1]. **Being
indistinguishable from adjacent content is a ranking problem, not just a taste
problem.**

**Quick tier** runs Scroller and Enthusiast only.

---

## Pass 6 — Platform variants

**6a. Mechanical compliance.** Delegate to `platform-auditor`; run
`scripts/platform_check.py`. Aspect, length, safe zones, watermark check,
majority-text check, muted-audio check, disclosure toggle, unresolved
placeholders. **A declared degradation order** from the platform file governs
what gets cut when a limit bites, so the cut is never improvised.

**6b. Genuine re-scripting, not reformatting.** The same idea for TikTok and for
Reels is **two different scripts**, because payoff placement is inverted between
them. **The pass explicitly refuses to letterbox, crop, or reuse a cut** —
Instagram names re-uploads and watermarks as demotions and TikTok names reused
content as FYF-ineligible [both T1].

**6c. Caption and title.** TikTok: the spoken search query plus a few genuinely
topical hashtags. Reels: descriptive keyword-bearing prose, **no hashtags**.
Shorts: Related Video set in Studio, not a description link.

---

## Pass 7 — AI-tell scrub

Run `craft/ai-tells.md` in its stated order:

1. `scripts/register_lint.py` — variance report
2. Substitute, don't ban
3. **The topic-swap test** — the load-bearing one
4. Register fit against `voice/corpus.md`, **not** added roughness

---

## Pass 8 — Tag and log

`scripts/log_post.py` writes to `data/posts.json`: platform, surface, goal
action, angle, trigger, archetype, hook pattern, curiosity-debt schedule, corpus
examples retrieved, particular used, tribe, provenance, commercial status, and
the platform file's `last-verified` at time of writing.

**Untagged drafts break the loop.** Without tags, performance data answers
*whether* a piece worked and never *why*, which is the failure mode of every
content feedback system in the prior art.

Log engagement later in the **platform-correct metric**:

| Platform | Log | Never log |
|---|---|---|
| TikTok | Retention rate, watched-full-video rate, avg watch time (TikTok Studio) | Any external benchmark |
| Reels | Avg watch time, **likes per reach**, **sends per reach** | Raw counts; Trial Reels against normal Reels |
| Shorts | **Engaged views**, Viewed-vs-Swiped-Away, avg % viewed | Raw *Views* — loop-inflated since 31 Mar 2025 [T1] |
