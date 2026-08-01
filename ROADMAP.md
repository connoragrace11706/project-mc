# Roadmap — building the production system

*Originally written 2026-07-31 from an audit of this machine and research into
how established creators run AI in their workflow. **Rewritten the same day**
after the interview revealed a second machine, a second person, and a footage
archive — all of which changed the architecture.*

Read `CLAUDE.md` for the operating manual and `brand/profile.md` for who we are.
This file is the plan for what the system becomes and why.

---

## 1. What exists right now

A **measurement skeleton, well designed, never run.**

| Area | State |
|---|---|
| `CLAUDE.md`, `SETUP.md` | Good. Posting rule updated 2026-07-31 to the approval-queue model. |
| `brand/profile.md` | **Rewritten from the interview.** Positioning, team, car, hardware, voice, hard lines all real now. |
| `data/accounts.json` | **Handles in:** `project.mc.racing` on YouTube, Instagram, TikTok. No X account. IDs still unresolved. |
| `ingest/*.ps1` | Written and careful. Never run — no API key yet. |
| `playbook/*.md` | Four templates, all empty. Nothing is evidence-based yet. |
| `.claude/skills/` | 4 skills: `pull-metrics`, `weekly-review`, `content-plan`, `draft`. |
| `editor/`, `publisher/`, `scripts/` | **Empty.** The entire production half, unbuilt. |
| `.env`, `.claude/settings.json`, `.claude/agents/` | Do not exist. No hooks, no subagents. |

---

## 2. The real hardware picture

The first version of this file assumed the laptop was all there was and
concluded everything had to run in the cloud. **That was wrong.** There are two
machines and they have different jobs.

| | **Laptop — the brain** | **Desktop — the render farm** |
|---|---|---|
| CPU | i3-1215U (6c/8t) | **[FILL]** |
| RAM | 7.7 GB | **32 GB** |
| GPU | Intel UHD (no CUDA) | **RTX 2080 Ti** — 11 GB VRAM, CUDA, NVENC |
| Disk | 92 GB free | **~2 TB free** after wipe, expandable |
| Job | Planning, scripting, metrics, publishing, this repo | Editing, transcription, encoding, the footage archive |

**What the 2080 Ti unlocks that the laptop couldn't do:**

- **DaVinci Resolve is viable.** Real editing and grading, GPU-accelerated.
- **Local transcription is free and fast.** `faster-whisper large-v3` on CUDA
  runs many times faster than realtime. The API line in the budget goes to zero.
- **NVENC hardware encoding.** Exports in minutes, not hours.
- **Local image generation** for thumbnails, if we ever want it.

**Consequences for how we work:**

1. **Run Claude Code on the desktop too.** That's where the footage lives, so
   that's where I need to be to drive ffmpeg and Whisper directly against it.
   This repo should live on the desktop, or be synced to it.
2. **The proxy workflow is now optional, not mandatory.** 2 TB and a real GPU
   means we can work on originals. Still worth generating proxies for anything
   we want to review on the laptop.
3. **The laptop stays the control surface.** Planning, drafting, metrics and
   publishing are all text — they run fine on a potato, and it's the machine
   that's actually with you.

**⚠ The urgent problem this does not solve.** All footage currently lives on
**SD cards and three phones, with no backup** — years of an irreplaceable build
on the two most failure-prone media that exist. And the desktop is about to be
wiped. **Verify nothing on that desktop exists nowhere else before formatting
it.** Consolidating and backing up the archive comes before anything clever.

**Still needed:** desktop CPU model and confirmation of free space post-wipe.

---

## 3. This is a two-person operation

The first version assumed a solo creator. Wrong.

| | **Connor** | **G (fiancée)** |
|---|---|---|
| Role | Builder, primary on-camera | Camera **and on-camera co-host** |
| Capacity | 20–40 hrs/wk, on top of a full-time job | **8 hrs/day** |
| Also | — | Photography business; wants her own channel |
| Stated need | A workflow that makes the channel grow | **"A good schedule for direction"** |

**The real constraint is coordination, not hours.** The classic two-person build
channel failure: he's wrenching and can't direct, she's shooting and doesn't
know which shot carries the story, and the session ends with 40 GB of footage
missing the one angle the video needed.

That is fixable before the camera turns on, and it's the highest-value thing
this system does for them:

**Title and thumbnail are decided first → the shot list falls out of them → G
knows exactly what she's hunting for → the footage matches the story.**

**G's channel** is a spin-off about her **photography business**, not a second
car channel. Different audience, different platforms — **Instagram first, then
Pinterest**; YouTube is a distant third for photographers. It gets its own
playbook, and it launches off the main channel's audience rather than cold. The
two feed each other: the build supplies portfolio work, the main channel
showcases her shooting, her channel converts that into clients.

---

## 4. "You film, I do the rest" — the honest split

### What I can genuinely take off you

- **Ideation and packaging** — title and thumbnail *before* filming.
- **Shot lists** — so you film the right things once. This is where the biggest
  time saving happens, and it happens before the camera turns on.
- **Scripting** — full scripts, VO, talking points, converging on your voice via
  `playbook/voice-notes.md`.
- **Footage indexing** — every clip transcribed, timestamped, tagged, searchable.
  "Where did I explain the oil pump decision?" becomes a query, not an hour of
  scrubbing. **This is the one that unlocks the archive.**
- **The rough cut** — silence removal, filler-word removal, take selection,
  structure, B-roll callouts, assembled by ffmpeg from a cut list I produce.
- **Shorts extraction** — one long-form into 5–10 vertical clips, hook-first,
  auto-reframed, captioned. Highest-leverage repetitive work in the pipeline.
- **All metadata** — titles, descriptions, chapters, tags, per-platform captions,
  disclosure lines.
- **Thumbnails** — concepts and generation via the Higgsfield CLI.
- **Publishing** — YouTube, Instagram, X via API. TikTok manual (§7).
- **Metrics, review, playbook.** Already designed, needs keys.
- **Comment triage.**

### What I can't do, and won't pretend to

- **Judge a take.** I read transcripts. I can't hear flat delivery or see bad
  light. *Fix: say "that was the one" on camera — I'll find it in the transcript
  and it costs you nothing.*
- **Taste.** Music, pacing, the moment to hold a shot. I get you to 85%; the
  last 15% is what makes it yours.
- **Sound mixing and colour to a high standard.** Automatable to "acceptable."
- **See footage I can't reach.** On an SD card in the garage, it doesn't exist
  to me. Offloading is yours and it's non-negotiable.
- **Guarantee TikTok auto-posting** (§7).

### The posting rule — settled 2026-07-31

`CLAUDE.md` used to say *"I never post anything."* Replaced, deliberately, with
the **approval queue**: I write finished posts into `publisher/queue/`, you move
what you approve into `publisher/approved/`, I post **only** from `approved/` and
log results to `posted/`. Anything unapproved at post time is skipped, never
guessed at. A hook makes this structural rather than a promise.

---

## 5. How the people who are good at this actually work

**1. Title and thumbnail come first — before filming.** The leaked MrBeast
production guide is explicit: the creative process starts with title and
thumbnail, and everything downstream is built to pay them off. Their three
metrics are CTR, average view duration, and retention. Costs nothing, and for a
two-person crew it's also the coordination fix from §3. **`/draft` should refuse
to produce a script until the title and thumbnail concept exist.**

**2. Format systems, not one-off videos.** Recurring formats compound. For this
channel the obvious ones: the cost breakdown, the failure post-mortem, the
race-weekend recap, and — uniquely available here — **"does it hold?"** after
every power increase on the stock bottom end.

**3. AI in the middle, never at the ends.** Humans do the idea and the on-camera
work; humans do the final taste pass; AI eats transcription, rough cuts,
repurposing, captions, metadata, thumbnail iteration, comment triage. Channels
that let AI do the ends read as generic — fatal for a brand whose entire value is
"this is a real guy telling the truth."

**4. Repurposing ratio is the leverage.** One shoot should yield the long-form,
5–10 shorts, stills, and a text post. Most solo creators film plenty and publish
a fraction. That conversion is the automatable part.

**5. Retention-driven iteration.** Find where people leave, change that thing.
This is what `playbook/` is for, and why the YouTube OAuth gap in §7 matters more
than it looks.

---

## 6. CLIs and tools

Verified against winget on this machine. Per `MEMORY.md`, **ffmpeg is the only
Tier 1 item still missing** — Python 3.13, Node 24 and git 2.55 are now installed.

### Tier 1

| Tool | Install | Why |
|---|---|---|
| **ffmpeg** | `winget install Gyan.FFmpeg` | The backbone. Proxies, trimming, concat, captions, reframing, audio extraction. Every automation calls it. **Install on both machines.** |
| **yt-dlp** | `winget install yt-dlp.yt-dlp` | Pull your own uploads back for clipping; grab competitor references for teardown. **Also missing.** |
| ~~git~~ | ✅ 2.55.0 installed | Version control for the knowledge base. |
| ~~Python 3.13~~ | ✅ 3.13.14 installed | Unlocks `faster-whisper`, `auto-editor`, `scenedetect`. |
| ~~Node 24~~ | ✅ 24.18.1 installed | Runtime for `higgs` and `wrangler`. |

### Tier 2 — as needed

| Tool | Install | Why |
|---|---|---|
| **ExifTool** | `OliverBetz.ExifTool` | Camera timestamps → footage auto-organises by shoot day. **Important for the archive**, where filenames are meaningless. |
| **DaVinci Resolve** | direct download | Now viable on the desktop. Free tier is genuinely capable. |
| **rclone** | `Rclone.Rclone` | Off-site backup of the archive, and public URLs for Instagram publishing (§7). |
| **HandBrake CLI** | `HandBrake.HandBrake.CLI` | Better delivery presets than raw ffmpeg. Optional. |
| **OBS Studio** | `OBSProject.OBSStudio` | Only if you want screen-recorded segments — tuning software, datalogs, telemetry. |
| **Shotcut** | `Meltytech.Shotcut` | Light NLE for the laptop. Mostly superseded by Resolve on the desktop. |

### Already installed

- **`higgs`** (`@higgsfield/cli`) — image/video gen, TTS, `soul-id`. **Best use: thumbnails.** Not for cutting real footage.
- **`wrangler`** (Cloudflare) — R2 gives cheap storage with public URLs, which is exactly what Instagram publishing requires, plus Workers for the IG token-refresh cron.

### Not recommending

- **Docker / Postiz / Mixpost** — good tools, but the laptop can't host them and the desktop shouldn't be tied up. Revisit via Railway (~$5/mo) if scheduling gets painful.
- **Transcription APIs** — the 2080 Ti made these unnecessary. Local is free.
- **Supermetrics / Windsor.ai** — $50–200+/mo, not defensible.

---

## 7. Publishing reality per platform

| Platform | Auto-publish? | What it takes | Verdict |
|---|---|---|---|
| **YouTube** | **Yes** | OAuth as channel owner. `videos.insert` = 1 quota unit, 100 uploads/day cap. | **Do it first.** Also unlocks the **Analytics API** — the only source of retention, AVD and CTR, the three numbers the whole playbook runs on. |
| **Instagram** | **Yes, with conditions** | Business/Creator linked to a Facebook Page, Meta app, `instagram_content_publish`. Three-step container flow, **requires a publicly reachable video URL** (→ R2). Reels: 9:16, 5–90s. | Second. As app owner you can work in dev mode against your own account without full App Review. **Blocked until the IG account is confirmed Business/Creator.** |
| **X** | **Yes** | Free tier can post; cannot read your own metrics. | **No account yet.** Claim `project.mc.racing` regardless. |
| **TikTok** | **Effectively no** | Content Posting API needs a 2–4 week audit with strict UX review. Unaudited: 5 users/day, everything posts `SELF_ONLY`. | Upload manually — 60 seconds, and the native editor helps reach. |

```
publisher/
  queue/      I write finished posts here
  approved/   you move them here — the gate
  posted/     archive + returned post ID, so metrics join back
  tokens/     gitignored OAuth refresh tokens
```

---

## 8. Structure

```
AI/
├── CLAUDE.md                    operating manual  ✅ posting rule updated
├── SETUP.md                     credentials  [reorder: YT OAuth first]
├── ROADMAP.md                   this file
│
├── brand/
│   ├── profile.md               ✅ rewritten from the interview
│   ├── build-log.md             ** NEW — MISSING AND IMPORTANT **
│   └── assets/                  ** NEW ** logo, lower-thirds, music licences,
│                                          disclosure boilerplate
│
├── library/                     ** NEW — the foundation **
│   ├── index.json               every clip: path, shoot date, camera, duration, tags
│   ├── transcripts/             one per clip, word-level timestamps
│   └── proxies/                 480p, for reviewing on the laptop
│
├── editor/                      exists, empty
│   ├── cutlists/                in/out points + why
│   ├── templates/               caption styles, intro/outro, reframe presets
│   └── *.ps1                    ffmpeg assembly, caption burn, 9:16 reframe
│
├── publisher/                   exists, empty — see §7
├── drafts/                      ** NEW ** scripts, hooks, captions in progress
├── thumbnails/                  ** NEW ** concepts, variants, which one won
├── calendar/                    ** NEW ** the plan, protected floor, surge list
├── research/                    ** NEW ** competitor teardowns — start with
│                                          "Project 324K" (K24-swapped E36)
│
├── data/  ingest/  playbook/    exist
└── scripts/                     rename to lib/ — ambiguous with video scripts
```

### The one genuinely missing piece: `brand/build-log.md`

`CLAUDE.md` says `/content-plan` works from "the playbook + build status."
**There is no build status file.** Content here is downstream of what's
physically happening to the car. Without it, every plan I produce is invented.
Five minutes for Connor to start; unblocks the most-used command in the project.

---

## 9. Claude Code configuration

### Directory-scoped `CLAUDE.md`

Short and operational, one per working area:

- `library/CLAUDE.md` — naming conventions, what a transcript record contains, **never delete originals**.
- `editor/CLAUDE.md` — ffmpeg conventions, caption style, per-platform target specs, cut from originals not proxies.
- `publisher/CLAUDE.md` — **the approval gate, stated first and bluntly.** Never post from `queue/`. Always log the returned ID. Disclosure rules.
- `brand/CLAUDE.md` — voice rules distilled from `profile.md` + `voice-notes.md`, **including the employer hard line and the profanity placement rules.**

### Subagents (`.claude/agents/`) — none exist yet

| Agent | Job | Tools |
|---|---|---|
| `clip-finder` | Read transcripts, propose shorts with in/out points and a hook line | Read, Grep, Glob |
| `voice-editor` | Apply every rule in `voice-notes.md` to a draft | Read, Edit |
| `metrics-analyst` | Diff snapshots, propose playbook changes, enforce the 3-post rule | Read, Bash |
| `thumbnail-critic` | Judge variants against the title. Deliberately adversarial | Read |

### Skills — 4 exist, add 6

Existing: `pull-metrics`, `weekly-review`, `content-plan`, `draft`.

| New skill | Job |
|---|---|
| `/index-footage` | Offload a card or phone: proxy, transcribe on GPU, tag, write to `library/index.json` |
| `/cut` | Transcript → cut list → ffmpeg rough assembly |
| `/shorts` | One long-form → N vertical clips, captioned and reframed |
| `/publish` | Move approved items out of the queue; log results |
| `/build-log` | Quick append to `brand/build-log.md` — dictate what you did today |
| `/shot-list` | **New, for G.** Title + thumbnail → the shots she needs to get. The §3 coordination fix, made mechanical |

Amend `/draft` to enforce title-and-thumbnail-first.

### Hooks (`.claude/settings.json`) — none exist yet

- **PreToolUse guard on `publisher/`** — refuse any post not in `approved/`. Makes the editorial gate structural.
- **PreToolUse secret scan on writes** — block anything token-shaped. Enforces the `CLAUDE.md` rule instead of trusting me to remember.

### MCP servers

ffmpeg MCP servers exist. **Skip them.** A skill shelling out to ffmpeg is
simpler, debuggable, and versioned in this repo. Revisit only if that gets
unwieldy.

---

## 10. Sequencing

Order chosen by Connor: **measurement first, then the archive.**

**Phase 0 — now**
1. ⏳ YouTube API key → resolve channel ID → first snapshot *(in progress)*
2. `winget install Gyan.FFmpeg` on both machines
3. **Verify the desktop holds nothing irreplaceable, then wipe**
4. Start `brand/build-log.md` — where the car is today
5. Confirm the Instagram account is Business/Creator + linked to a Facebook Page

**Phase 1 — protect the archive** *(before anything clever)*
6. Pull everything off SD cards and all three phones onto the desktop
7. Off-site backup — rclone to R2/B2. Years of a build in one place is how channels die
8. `/index-footage` — ExifTool for dates, GPU Whisper for transcripts, into `library/index.json`
9. **Employer-safety pass** over old footage: badges, uniforms, work vehicles, branded anything

**Phase 2 — the launch sequence**
10. The origin story is already filmed: stock M3 → pushed to the limit → motor lets go → the K24 decision. **That's the first act and it costs zero garage hours.**
11. `/cut` and `/shorts` built and tested against that real footage
12. Publish while the build runs in parallel — **the swap starts on camera from part one**, which is rare and shouldn't be wasted

**Phase 3 — publishing**
13. `publisher/` + approval queue, YouTube first
14. Instagram (needs Creator + FB Page + R2 hosting)
15. X account claimed. TikTok stays manual

**Phase 4 — the loop closes**
16. Two snapshots → first real `/weekly-review` → hypotheses graduate into
    `what-works.md` on evidence instead of vibes

---

## 11. What this costs

| Item | Cost |
|---|---|
| ffmpeg, Python, git, yt-dlp, rclone, Resolve, OBS, auto-editor, scenedetect | $0 |
| YouTube Data + Analytics API, Instagram Graph API, X posting | $0 |
| **Transcription** | **$0** — local on the 2080 Ti |
| Off-site backup (R2 / B2), ~2 TB | ~$10–30/mo |
| **Ongoing total** | **~$10–30/mo, essentially all backup** |

The standard creator SaaS stack — Descript + Opus Clip + a scheduler — runs
$60–150/mo. The open-source path plus the desktop does it for the price of
storing your archive somewhere it can't be lost.

---

## 12. Open items

**Answered in the 2026-07-31 interview:** posting rule (gated), build order
(measurement first), the car, the team, hardware, voice, hard lines, handles.

**Still needed:**

1. **Desktop CPU** and confirmed free space after the wipe.
2. **Is Instagram already Business/Creator, linked to a Facebook Page?** Nothing on the IG side works until it is.
3. **G's photography handles**, and how she wants to be credited on camera.
4. **Tow vehicle** — unresolved, and the first event will arrive faster than expected.
5. **Time attack series** — undecided. Also a legitimate video: *"which series should I run?"*
6. **Verify the profanity/smoking monetization thresholds** in `brand/profile.md` — flagged unverified; my check was blocked.
7. **Monetization plan** — Connor named "profiting from it" as a core goal. Deserves its own session: YPP thresholds, why ad revenue is negligible early, why parts partnerships arrive around 10–20k *engaged* subs, and why the Money pillar's honesty is a sponsorship asset rather than a liability. Realistically a **12–18 month** play.

---

## Sources

- [MrBeast leaked production guide — key points (Tubefilter)](https://www.tubefilter.com/2024/09/17/mrbeast-internal-production-guide-leaked-key-points/)
- [How to Succeed in MrBeast Production (Simon Willison)](https://simonwillison.net/2024/Sep/15/how-to-succeed-in-mrbeast-production/)
- [YouTube Data API quota costs](https://developers.google.com/youtube/v3/determine_quota_cost)
- [Instagram content publishing (Meta)](https://developers.facebook.com/docs/instagram-platform/content-publishing/)
- [Instagram Reels API publishing guide](https://postproxy.dev/blog/instagram-reels-api-publishing-guide/)
- [TikTok Content Posting API guidelines](https://developers.tiktok.com/doc/content-sharing-guidelines)
- [TikTok Content Posting API in 2026: audit and alternatives](https://www.postpeer.dev/blog/best-tiktok-posting-api)
- [Postiz (open-source scheduler)](https://github.com/gitroomhq/postiz-app)
- [AI YouTube Shorts Generator (open-source Opus Clip alternative)](https://github.com/samuraigpt/ai-youtube-shorts-generator)
- [Claude Code Video Toolkit](https://github.com/wilwaldon/Claude-Code-Video-Toolkit)
- [faster-whisper vs whisper.cpp (2026)](https://codersera.com/blog/faster-whisper-vs-whisper-cpp-speech-to-text-2026/)
- [Project 324K — K24-swapped E36 (direct comparable)](https://www.youtube.com/watch?v=jahq_ODXzCU)
