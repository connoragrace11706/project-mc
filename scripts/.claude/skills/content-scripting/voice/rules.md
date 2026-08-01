# Voice rules

**Only rules you can grep.** If you cannot write a regex or a counter for it, it
belongs in `corpus.md` as an example instead. A rule that cannot be checked is a
vibe, and vibes do not survive a subagent boundary.

`data/learned-rules.md` overrides this file on conflict.

## Starting defaults

These are placeholders calibrated to the niche research, not to Sam. **Replace
them once `corpus.md` has real entries** — the linter should be measuring Sam's
distribution, not a generic one.

| Rule | Value | Why |
|---|---|---|
| Max sentence length | 28 words | Spoken delivery; anything longer loses the listener |
| Sentence-length stdev | ≥ 5.0 | **Variance collapse is the strongest measurable AI tell.** Uniform length reads as machine-written regardless of word choice |
| Opener-bigram diversity | ≥ 0.7 unique | Prevents every sentence starting the same way |
| Max em-dashes | 1 per 200 words | Overuse is a recognised tell |
| Proper nouns per 100 words | ≥ 3 | Specificity proxy. Automotive scripts should be dense with model names, part names, codes |
| Numerals per 100 words | ≥ 2 | Same. A script with no numbers in this niche is probably generic |
| Banned openers | "Hey guys", "Welcome back", "In this video", "Today I'm going to" | Marketing tells. The one creator who gets away with a self-intro has eleven million subscribers |
| Banned phrases | "game-changer", "absolute unit" (of an ordinary car), "you won't believe", "this changes everything", "let me tell you" | Hyperbole tells |
| Tribe-specific terms | **Max 1 per script** | Three terms from three tribes is the loudest tourist signal. See `niche/tribes.md` |
| Catastrophic verbs | Only with a named part + named failure + named consequence | The anti-catastrophising rule in `niche/authenticity.md` |

## Zero tolerance — hard-blocked by the PreToolUse hook

These are not style preferences. They fail the build.

- Any statistic without a tier tag
- Any claim on the kill list in `craft/evidence-standards.md`
- An unresolved `[PLACEHOLDER]`
- A first-person sensory claim in a faceless script (`I heard`, `listen to
  that`, `you can feel`) — see the faceless-credibility rule
- "tag a friend", "follow for more", "comment below"
- A speed callout or a velocity-based title (`niche/risk.md`)

## What does NOT belong here

Anything requiring judgment. "Be conversational," "sound confident," "keep it
punchy" — these are unmeasurable, and an agent that satisfies them still writes
generic prose. Put the example in `corpus.md` instead and let the model pattern-
match against something real.
