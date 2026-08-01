---
name: content-scripting
description: Write and refine short-form video scripts in Sam's voice for TikTok, Instagram Reels, and YouTube Shorts in the car and motorcycle space. Use when drafting, rewriting, critiquing, or adapting automotive or moto content for any of these platforms.
when_to_use: "script this", "write a Short about", "make a Reel about", "draft a TikTok", "punch up this hook", "does this sound like me", "adapt this for Reels", "what should I post about this car/bike"
argument-hint: [tiktok|reels|shorts] [topic]
arguments: [platform, topic]
allowed-tools: Read, Grep, Glob, Bash(python3 .claude/skills/content-scripting/scripts/*)
---

Write for **$platform** about **$topic**.

## Load order — read the files, do not substitute memory

Read in this order. Each is a real file read, every time.

1. `craft/evidence-standards.md` — **always, first.** Governs every claim you
   make or repeat, and every number you are tempted to state.
2. `voice/profile.md` — always. If any REQUIRED field is unfilled, stop and ask
   for it. Scripting without it produces predictable, specific failures.
3. `voice/corpus.md`, `voice/taste.md`, `voice/rules.md` — always.
4. `niche/tribes.md` — always. Locks the tribe and the market register.
5. `platforms/$platform.md` — always. Its Mechanics section is authoritative
   over everything else in this skill, including this file.
6. `data/learned-rules.md` — always. Overrides `voice/rules.md` on conflict.
7. `niche/archetypes.md` + `niche/authenticity.md` — when choosing a format or
   generating an opener.
8. `craft/attention.md` + `craft/hooks.md` — when generating or fixing a hook.
9. `craft/curiosity-debt.md` — for anything over ~20 seconds.
10. `niche/risk.md` — before finalising anything involving speed, a maneuver,
    third-party footage, a named business, or a person other than Sam.
11. `craft/refinement-protocol.md` — before showing Sam anything.

## Workflow

Run the eight-pass pipeline in `craft/refinement-protocol.md`.

- **Full** (passes 1–8) for anything Sam will actually produce.
- **Quick** (1, 2, 3, 6a, 8) for throwaway ideas and variations.

Delegate pass 5 to the `voice-critic` subagent and pass 6a to
`platform-auditor`. A critic that watched you write the draft is not a critic.

## Standing instructions

- **Never state a statistic without its tier tag.** If you cannot name the tier,
  do not state the number. Mechanisms are durable and citable; magnitudes are
  perishable and mostly invented.
- **If `platforms/$platform.md` has a `last-verified` date over 90 days old,
  say so before proceeding.** Run `scripts/staleness.py` to check.
- **One tribe per script.** Never mix tribe-specific vocabulary. Three terms
  from three tribes in one script is the loudest possible tourist signal —
  worse than using none.
- **The particular is a hard gate.** Every script needs at least one thing that
  could only come from Sam: a number, a part, a first-hand observation, a cost,
  a mistake. Without one, return "no particular — what actually happened?"
  rather than a draft. Genericness is what platforms police and audiences
  detect; craft does not compensate for it.
- **Write the muted layer and the sound layer as separate deliverables that each
  work alone.** Never write a text card that is a transcript of the voiceover.
- **Check the provenance ladder before choosing a format.** Owned, borrowed,
  press fleet, rented, or someone else's — this decides which archetypes are
  available and what must be disclosed.
- Tag every draft per pass 8. Untagged drafts break the feedback loop and make
  performance data unanswerable.
- Output to `drafts/`. **Never publish, schedule, or post.**

## Scope note

Platform files exist for TikTok, Reels, and Shorts. Validated research for X and
Reddit is archived in `research/platform-research-validated.md` if those ever
come into scope; do not write for them from memory.
