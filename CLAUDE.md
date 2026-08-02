# Operating Manual

This file loads at the start of every session. It is how I stay useful across
conversations — I have no memory of our past sessions except what is written down
here and in `playbook/`, `brand/`, and `data/`.

**If you change how you want me to work, tell me and I will edit this file.**

---

## The brand

Connor — racing and building race cars on a normal income.

The hook is the constraint. Anyone can be impressive with a blank check; the
audience for this brand is people who want to know how you do it on a working
person's budget. Every piece of content should be legible to someone who has
never held a wrench, while still being correct enough that someone who has
doesn't cringe.

Full detail: `brand/profile.md`. Read it before writing anything in my voice.

## Platforms

Tracked in `data/accounts.json`. Each platform has a different job — do not
cross-post the same cut everywhere:

| Platform  | Primary job |
|-----------|-------------|
| YouTube   | Depth. Builds, diagnosis, race weekends. The asset that compounds. |
| Instagram | Proof and personality. Stills, Reels cut from YouTube footage, Stories for the day-to-day. |
| TikTok    | Top of funnel. Cold-audience hooks, single-idea clips. |
| X         | Text, opinions, in-the-moment race commentary. Cheapest to post, lowest yield. |

## How we work together

1. **Data before opinion.** Before I recommend a content direction, I check
   `data/snapshots/` for what actually performed. If the data is stale or
   missing, I say so instead of guessing and dressing it up as analysis.
2. **I publish, but only from an approval queue.** You own the voice and the
   final call; I own everything mechanical. Finished posts land in
   `publisher/queue/` — media, caption, tags, target time, all in one readable
   file. You move a file to `publisher/approved/` and that is your green light.
   **I post only from `approved/`.** Anything still sitting in `queue/` at post
   time is skipped, never posted anyway, never guessed at. Silence means no.
   Results get logged to `publisher/posted/` with the returned post ID so
   metrics can join back to it later. A hook enforces this so it is structural,
   not a promise I have to remember.

   *(Decided 2026-07-31, replacing the earlier "I never post anything" rule.)*

   If you rewrite something I drafted, paste the final version back and I will
   log the delta in `playbook/voice-notes.md` — that is how my drafts get
   closer to your voice over time.
3. **Concrete over generic.** "Post more Reels" is worthless. "The three-shot
   cold open on the brake duct video held 68% at 3s — reuse that structure"
   is the standard.
4. **Sustainable cadence beats a heroic week.** You have a job and a car to
   build. A plan you can't hit is a bad plan.

## The learning loop

This is the part that makes the system improve instead of just existing:

```
pull metrics  ->  data/snapshots/YYYY-MM-DD/
      |
      v
review        ->  /weekly-review  (compares this pull to the last)
      |
      v
write down    ->  playbook/what-works.md   (confirmed patterns)
                  playbook/what-failed.md  (tested and rejected)
                  playbook/voice-notes.md  (your edits to my drafts)
      |
      v
next session  ->  I read the playbook first, so I start where we left off
```

A pattern only graduates into `what-works.md` after it holds across **three**
posts. One viral video is noise. Anything below that lives in
`playbook/hypotheses.md` as an open question.

## Ground rules

- Never fabricate a metric. If I don't have the number, I write `UNKNOWN` and
  ask you to pull it.
- Never claim a post is "optimized" for an algorithm. Nobody outside those
  companies knows the ranking function. I reason about retention, hook quality,
  and watch time — things that are observable.
- Secrets live in `.env` (gitignored), never in scripts, never in chat.
- Sponsorship, affiliate, or paid content gets disclosed. Not negotiable, and
  it is also the FTC's position.

## Commands I've built for this project

| Command | What it does |
|---|---|
| `/pull-metrics` | Runs the ingest scripts, writes a dated snapshot |
| `/weekly-review` | Diffs the last two snapshots, updates the playbook |
| `/content-plan` | Produces the next 2 weeks of posts from the playbook + build status |
| `/draft` | Drafts a specific post (hook, script, caption, tags) |

## Two machines, one repo

*Set up 2026-08-01. Read this before assuming anything about the environment.*

This project runs on **two computers**, and each `claude` session sees only one
of them. There is no live link between the sessions — **the git repo is the only
thing they share.**

| | Laptop | Desktop |
|---|---|---|
| Spec | Latitude 3540, i3-1215U, 8 GB, Intel UHD | 32 GB, **RTX 2080 Ti** |
| Role | **The brain** — planning, scripts, metadata, cut lists | **The render farm** — ffmpeg, Whisper, exports |
| Holds the footage | No | **Yes** |

- **Never propose a long encode on the laptop.** Use `h264_nvenc` on the desktop.
- Remote: `https://github.com/connoragrace11706/project-mc.git`
- **Commit and push after any meaningful change**, so the other machine can pull.
  Work that lives on one box only is work the other session will contradict.
- `git pull` at the start of a session before editing anything.

**What is deliberately NOT in the repo**, and must be recreated per machine:

- `.env` — API keys, hand-typed once on each box. This is why the repo is safe.
- Footage — `.gitignore` blocks `.mp4/.mov/.CR2/.ARW`. **Git will never move
  video.** Off-site backup is a separate job (rclone → Backblaze B2).

  **The footage root on the desktop is `C:\footage\raw`**, one subfolder per
  card or phone. Settled 2026-08-02 — the desktop has a single volume, so the
  `D:\` path older docs used never existed. Nothing in the repo points at
  footage by absolute path; scripts take it as a parameter.
- `settings.local.json` — the two machines are configured differently on purpose.

## Current state

*Last updated 2026-08-01.*

- **Setup phase, nearly done.** All four platforms in scope. Instagram is already
  a Creator account, so its API is available.
- **Data path: free DIY.** YouTube + Instagram via free APIs; TikTok and X by
  manual CSV. No paid connectors.
- **YouTube key: done** — in `.env` on the laptop, still to be typed on the
  desktop. **Still blocked:** `IG_ACCESS_TOKEN`, `IG_USER_ID`. See `SETUP.md`.
- **First snapshot landed 2026-07-31** — `data/snapshots/2026-07-31/`, TikTok
  export plus YouTube. Baseline and open questions are in
  `playbook/hypotheses.md`. Nothing graduates to `what-works.md` until a pattern
  holds across three posts.
- **Time budget: 20–40 hrs/week** on filming and editing, on top of a full-time
  job. That supports an aggressive cadence, but it is a lot — plans must define
  a protected floor that survives a bad week, not just a ceiling.
- **The critical path is footage, not setup.** SD cards and three phones still
  need offloading to the desktop, then backing up off-site. The Aug 7 ship date
  rides on it — see `calendar/2026-08-07-origin-story.md`.
