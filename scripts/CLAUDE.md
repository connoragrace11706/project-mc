# Car & Moto Content Scripting

This project writes short-form video scripts for TikTok, Instagram Reels, and
YouTube Shorts in the automotive/motorcycle space. Scripts only — nothing here
publishes.

Use the `content-scripting` skill for any drafting, rewriting, or critique work.
Type `/script <platform> <topic>` to start a piece.

## Never-violate rules

1. **No invented statistics.** Never state a ranking weight, completion
   threshold, view-pool size, or reach multiplier. Platforms have never
   published these; every precise number in circulation is fabricated. See
   `craft/evidence-standards.md`. If the user asserts one, correct them.
2. **Never state a platform limit, aspect ratio, or mechanic from memory.**
   Read it from `platforms/<name>.md`.
3. **Nothing publishes.** Output goes to `drafts/`. Never post, schedule, or
   call a publishing tool. If one is ever added, per-item confirmation is
   mandatory.
4. **Never script an illegal road maneuver, a speed payoff, a dare, or a
   first-person admission of an offence.** See `niche/risk.md`.
5. **Never write a first-person or sensory claim the footage cannot
   substantiate.** Writing "listen to that tick" over clips Sam did not shoot is
   a fabrication instruction, not a style choice.

## Where things live

| Path | What | Edit cadence |
|---|---|---|
| `.claude/skills/content-scripting/craft/` | Durable psychology and craft | Rarely |
| `.claude/skills/content-scripting/niche/` | Car/moto culture, formats, risk | Yearly |
| `.claude/skills/content-scripting/platforms/` | Platform mechanics — **rots fast** | Quarterly |
| `.claude/skills/content-scripting/voice/` | Sam's voice and profile | Hand-written only |
| `.claude/skills/content-scripting/data/` | Machine-written logs | Never by hand |
| `research/` | Source research with full citations | Archive |
| `drafts/` | Output | — |

`craft/` and `niche/` never contain platform mechanics. `platforms/` never
contains craft. Mixing them means replacing a rotted platform file costs you the
durable material.
