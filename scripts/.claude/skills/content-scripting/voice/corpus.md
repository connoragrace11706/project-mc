# Voice corpus

**Hand-written only. Never generated, never paraphrased.**

15–30 of Sam's own pieces, verbatim, each annotated with what it did and why it
worked. **Never paraphrase into principles — the paraphrase is where the voice
dies.** A rule says "be direct"; an example shows what Sam's direct actually
sounds like, and only the second is transferable.

Frame these as **"pieces that performed,"** not "pieces I like." The model
treats performance-framed examples as evidence and taste-framed ones as
preference — and weights them accordingly. If performance is unknown, say so in
the annotation rather than implying it.

## Status

**`[EMPTY — 0 of 15 minimum]`**

This is the highest-effort and highest-leverage input in the whole build.
Everything else in this skill is calibration; this is the actual voice.

## Cold start

If Sam has no existing short-form content, bootstrap in this order:

1. **Record three unscripted takes** on things he actually knows — how he'd
   explain a job to a friend in the garage, what he'd say handing someone the
   keys, why he bought the thing. Transcribe verbatim, filler and all. This is
   the highest-fidelity source available and it takes twenty minutes.
2. **Adjacent writing** — forum posts, marketplace listings, texts to friends
   about vehicles, build-thread updates. Register will not be social-native but
   the diction and the reasoning shape will be his.
3. **Do not bootstrap from other creators' scripts.** That produces an impression
   of someone else, and it is exactly the failure this file exists to prevent.

Annotate each entry honestly: `performance: unknown (chosen by taste)` is a
valid annotation and a useful one.

## Format

````markdown
<example index="1" platform="shorts" archetype="B" performance="unknown">
[The piece, verbatim. Every filler word, every false start. Do not clean it up.]
</example>

**What it did:** [the actual effect]
**Why it worked:** [the mechanism, in Sam's terms]
**Voice markers:** [what is distinctively his here — a construction, a rhythm, a
habit of understatement, a way of naming a part]
````

## Maintenance rule

Structure rules (`rules.md`) and these examples must be edited **together** or
they fight. If the required structure changes, the examples change in the same
commit.
