---
name: script
description: Start a new short-form script. Runs the full eight-pass pipeline.
argument-hint: [tiktok|reels|shorts] [topic]
arguments: [platform, topic]
disable-model-invocation: true
---

Write a **$platform** script about **$topic**.

Load the `content-scripting` skill and run the **Full** pipeline (passes 1–8)
from `craft/refinement-protocol.md`.

## Before anything else

Read `voice/profile.md`. **If any REQUIRED field is `[UNFILLED]`, stop and ask
Sam for it.** Do not guess and do not proceed on a default — each blank field
has a named failure mode documented next to it, and every one of them produces
content his own audience will call out.

The four that block hardest:

- **Tribe** — the archetype set is not tribe-neutral, and vocabulary from three
  tribes in one script is the loudest tourist signal available.
- **Market register** — no default. US/UK/CA/AU diverge on panel names,
  currency and fuel measure.
- **Provenance of the vehicle** — decides which archetypes are even available
  and what has to be disclosed.
- **On-camera gear and competence**, if this is moto and the judgment-invitation
  archetype is a candidate. A creator filmed in a hoodie cannot run it; it
  inverts into a hypocrisy pile-on.

## Then

Run passes 1–8. Delegate pass 5 to `voice-critic` and pass 6a to
`platform-auditor` — they run in isolated context on purpose.

Write the finished script to `drafts/YYYY-MM-DD-<slug>.md` and log it with
`scripts/log_post.py`.

**Do not publish, schedule, or post.**

## Output shape

```markdown
# <working title>
platform: <tiktok|reels|shorts>   surface: <feed|search|local|explore>
archetype: <letter>   trigger: <1-5>   goal action: <the modelled action>
tribe: <tribe>   provenance: <owned|borrowed|press|rented|third-party>
runtime target: <seconds>

## Muted layer
CARD (0:00–end of opening, top third, static):
> <complete claim, legible with no audio>

## Shot list
| Time | Shot | On-screen text |
|---|---|---|
| 0.0 | <macro on the specific part, shallow DOF> | |

## Spoken
[0.9s] <first spoken word lands here — faceless 0.9-1.7s, on-camera up to 2.2s>
...

## Curiosity-debt schedule
| Time | Gap opened | Gap paid | Outstanding |
|---|---|---|---|

## Comment hook
<the one deliberate nitpickable detail or open question>

## Caption
<platform-appropriate; TikTok includes the spoken search query, Reels is
keyword-bearing prose with no hashtags>

## Flags for Sam
<rights, disclosure, jurisdiction, anything the auditor raised>
```
