# Hook architectures

Architectures, not templates. A template gets recognised and swiped; an
architecture generates a hook that fits the particular you actually have.

Kallaway, on a hooks video with 763K views, opens by refusing to give a hook
list: *"I'm not going to give you a list of 25 proven viral hooks cuz that's not
what you need — what you need is to understand the psychology behind why those
hooks worked."* That is the correct instinct and this file follows it.

## Every hook has two beats

**Foothold beat** — establishes the domain so the gap can be felt. Without it
you get indifference, not curiosity (`attention.md`).

**Gap beat** — the expectation violation, question, or unresolved state.

In automotive short-form these usually occupy the **same second**, because the
foothold is visual and free: the part in frame, the bay open, the bike in shot.
Name them separately anyway when generating candidates. If a candidate has only
one, it is not a hook.

## The five architectures

Each maps to a Loewenstein trigger. Name the trigger when you generate.

**1. Unresolved mechanical state** *(trigger 2 — anticipated but unknown
resolution)*. The strongest architecture in this niche because the tension is
physical and the audience can predict. Will it start, what killed it, how much
will this cost, is it worth saving. **Upgrade: get the viewer to predict.** A
visible symptom before the diagnosis invites a guess, and a guess is what turns
trigger 2 into a force multiplier.

**2. Named-object contradiction** *(trigger 3 — expectation violation)*. A
specific, disputable assertion about a specific product, stated flat. Requires a
real argument behind it: take a side, give the strongest version of the opposing
case, explain the tiebreak. **Never pose the fight as an open question and walk
away** — that is marketing, and the audience reads it as such.

**3. Insider possession** *(trigger 4 — someone else has the information)*. The
shop frame, the auction frame, the "I've had forty of these through the
workshop" frame. Only available if it is true. It is the fastest architecture to
get caught faking.

**4. The answerable physics question** *(trigger 1)*. "How much lean angle
before you lose traction?" works. "What's the best sports car?" does not. The
test: **can the viewer reason toward an answer from what is on screen?** If not,
it is a poll, and polls are marketing.

**5. The number that reframes** *(trigger 3, numerically)*. A cost, a mileage, a
production count. See below — the number needs a qualifier to become an
argument.

## Concreteness

Score every candidate against the band in `attention.md`. Half of real headlines
are already past the point where more detail helps, and overshooting costs
nearly twice what undershooting gains.

**Too specific** leaves nothing unresolved: "This 2015 Camry's alternator
failed at 148,000 miles because the bearing seized." Nothing to find out.

**Too vague** signals no domain: "You won't believe what I found." No foothold,
so no gap.

**In band:** "This is what 148,000 miles does to an alternator." Domain
established, mechanism unresolved.

## Numbers need qualifiers

A bare number is a stat. A qualified number is an argument.

- "$22,000 **in 2004 money**" beats "$22,000"
- "sitting for **6 years**, and it doesn't even have a battery" beats "sitting
  for 6 years"
- "**235,000 miles**" beats "high mileage"
- A **/10 score** beats any adjective
- Superlative plus spec: "the largest brakes ever fitted to a production car"

**Scale discipline:** scarcity finality in three clauses ("$3.5 million. Only 29
in the world. Sold out.") is an exotic-tier device. On a $45K crossover it reads
as a dealership ad. Superlatives require a superlative object — see the
anti-hyperbole rule in `niche/authenticity.md`.

## Rejection filters

Run these before scoring anything:

- **If it would still make sense with "Hey guys" in front of it, it is not a
  hook.** It is an introduction.
- **If it is meta-commentary about what the piece will contain**, it spends the
  reference point without opening a gap. "Today I'm going to show you three
  things about..." is a table of contents.
- **If the rhetorical question has no visible proof within 2 seconds**, cut it.
  The measured pattern in this niche is question at 2.07s, physical evidence on
  screen at 3.7s. A question with a delayed payoff is the clickbait pattern that
  gets punished.
- **If the gap requires knowledge the target viewer does not have**, it produces
  indifference. Check the foothold against the tribe in `voice/profile.md`.

## Generation procedure

Produce 5–8 candidates. For each, state:

```
Candidate:      [the actual opening beat, as it will be delivered]
Foothold:       [what establishes the domain]
Gap:            [what is unresolved]
Trigger:        [1-5]
Concreteness:   [under band / in band / over band]
Muted version:  [what the text card says if audio is off]
```

Then run the Scroller pass from `refinement-protocol.md` on frame 1 alone.

Platform first-beat constraints live in `platforms/<name>.md` and override
anything here. Niche-native opening patterns — the macro-object cold open, the
silent spec card, the mid-thought walk-in — live in `niche/archetypes.md` and
`niche/authenticity.md`.
