---
name: weekly-review
description: Review social performance since the last snapshot and update the playbook. Use when the user asks for a review, "how did we do", weekly numbers, what's working, or after pulling fresh metrics.
---

# Weekly Review

Turn raw numbers into a decision. The output is not a report — it is 2–3 things
to do differently next week.

## Steps

1. **Load the two most recent snapshots** from `data/snapshots/`. If there is
   only one, say so plainly: trends need two points. Do a baseline read instead
   and stop.

2. **Check freshness.** If the newest snapshot is more than 10 days old, say so
   and offer to run `/pull-metrics` before continuing. Do not analyze stale data
   without flagging it.

3. **Compute deltas** per platform: followers, total views, per-post medians.
   Use **median, not mean** — one outlier post wrecks a mean and will send us
   chasing a pattern that isn't there.

4. **Segment before comparing.** Never pool Shorts with long-form, or Reels with
   feed posts. Different distribution, different ceilings. Compare like to like.

5. **Attribute by pillar** (build / racing / money / life). Which pillar earned
   its slot? The Money pillar is the brand's differentiator — track it closely
   even at low volume.

6. **Separate signal from noise.**
   - 3+ posts showing the same direction → candidate pattern
   - 1–2 posts → hypothesis, goes in `playbook/hypotheses.md`
   - Anything inside ±20% week over week on a small account → noise, say so

   Small accounts are extremely noisy. Resist narrating randomness. "Nothing
   conclusive this week" is a legitimate and useful finding.

7. **Update the playbook:**
   - Confirmed 3x → `playbook/what-works.md`
   - Tested and rejected → `playbook/what-failed.md`
   - Open questions → `playbook/hypotheses.md`

   Date every entry and cite the post IDs it came from.

## Output format

```
## Week of <date>   (vs <prior snapshot date>)

**Headline:** <one sentence — the single thing that matters>

| Platform | Followers | Δ | Median views/post | Δ |
|---|---|---|---|---|

**Best performer:** <post> — <why, mechanically>
**Worst performer:** <post> — <why, honestly>

**Confirmed this week:** <patterns that hit 3x, or "none yet">
**Still testing:** <hypotheses and how many data points they have>

**Do this next week:**
1.
2.
3.
```

## Rules

- Never invent a number. Missing data is written as `UNKNOWN`.
- Never attribute a change to "the algorithm." Explain via hook, thumbnail,
  topic, timing, or length — things we can observe and control.
- If the honest answer is "not enough data," say that. A confident wrong
  narrative is worse than an admitted unknown, because we'll act on it.
