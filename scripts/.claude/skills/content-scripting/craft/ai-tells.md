# AI tells

## The finding that reframes this whole problem

**People cannot detect AI text.** Untrained evaluators are at chance [T3, Clark
et al. 2021]; training raises accuracy to at most 55%. Jakesch et al. [T3, PNAS]
found ~52% accuracy, with readers relying on **wrong** cues — grammatical
errors, long words, first-person pronouns, contractions.

The devastating number: **AI profiles optimised to exploit those human
heuristics were judged human 65.7% of the time, versus 51.7% for actually-human
profiles.**

So audiences are not running a lexical classifier. **What they detect — and what
platform policy actually polices — is structural genericness**: content that
could be topic-swapped with light editing.

**Therefore: kill genericness first, vocabulary second.** Vocabulary filters
address the smallest part of the risk, and chasing them is why so much
"de-AI-ified" content still reads as machine-made.

## 1. The topic-swap test — the load-bearing one

> **Could this script be topic-swapped to a different vehicle, or a different
> niche entirely, with light editing, and read the same?**

If yes, it fails, regardless of word choice. Name the specific missing
particular and go get it.

This test matches what platforms police: YouTube's "generic or unoriginal
templates," TikTok's "minimally edited," Google's "no matter how it's created."
It is also what the audience is actually reacting to when they say something
feels like AI.

The automotive version of the test is sharper than most: **could this narration
sit under different footage?** If it could, it is not about the thing on screen,
and that is exactly the faceless-credibility failure in
`niche/authenticity.md`.

## 2. Variance collapse — the measurable one

Register regression is a **distributional** failure, not a lexical one. The
draft satisfies every rule and still reads like an LLM because the *statistics*
of the prose are wrong.

`scripts/register_lint.py` measures:

- Sentence-length standard deviation — **the strongest single signal.** Human
  writing varies wildly; model writing converges on a comfortable mean.
- Paragraph-length standard deviation
- Opener-bigram diversity (how many sentences start the same way)
- Em-dash rate, colon rate
- Proper nouns per 100 words, numerals per 100 words — the specificity proxies

Uniform sentence length is the easiest tell to script for and the most reliable.
Fix it by rewriting, not by inserting a short sentence.

## 3. Substitute, do not ban

A ban leaves the model stranded and it reaches for the next-nearest generic
word. A substitution tells it what to write instead.

| AI tell | Human alternative |
|---|---|
| leverage | use |
| utilize | use |
| in order to | to |
| it's worth noting that | *(delete, state the thing)* |
| delve into | look at, get into |
| a testament to | *(delete, show the evidence)* |
| showcasing | showing |
| pivotal | important, or name the specific stake |
| intricate | complicated, fiddly |
| realm | *(delete)* |
| comprehensive | complete, or say what it covers |
| crucial | *(name the consequence instead)* |
| notably / particularly | *(delete)* |
| game-changer | *(name what changed)* |
| when it comes to X | for X |
| dive into | *(delete)* |
| unlock / unleash | *(delete)* |
| elevate | improve, or name the delta |
| seamless | *(delete or describe the absence of a specific friction)* |
| robust | *(name the failure it survives)* |
| ensure | make sure, or *(delete)* |
| synergy | *(delete the word)* |
| landscape (figurative) | *(delete)* |
| navigate (figurative) | deal with, get through |

**Treat the unmeasured tells lightly.** Rule-of-three lists, "not just X but Y,"
and em-dash counts have no cross-model evidence behind them and are also normal
features of good writing. Do not mangle a sentence to avoid one.

## 4. Register fit, not roughness

**Do not add disfluency, hedging, or unpolished syntax to sound human.** None of
those are supported by evidence, hedging is a named moderator-detection
heuristic, and higher production value tested as *more* credible, not less.

Instead, check register against `voice/corpus.md`. The question is not "does
this sound rough enough" but "does this sound like Sam."

## Automotive-specific tells

These are the ones the comment section actually catches:

- **Narration describes something the clip does not contain.** "Listen to that
  tick" over a music bed. This is the canonical faceless death.
- **The engine on screen is not the engine in the script.** Caught within
  minutes.
- **Wrong generation, facelift, trim, or market** in the B-roll — RHD footage
  under a US story, pre-facelift bumper under a facelift claim.
- **Mirrored or flipped stock footage**, which puts the shifter, exhaust, or
  timing side on the wrong side.
- **Multiple angles of a discovery supposedly unfolding live.**
- **Any first-person claim with no hands, no shop, no continuity.**
- **Terminology errors** — see the trap list in `niche/authenticity.md`. One is
  enough to invalidate a whole script in the comments.
- **Catastrophising routine maintenance.** "Your cabin air filter is DESTROYING
  your engine" is the most-mocked voice in the vertical.
