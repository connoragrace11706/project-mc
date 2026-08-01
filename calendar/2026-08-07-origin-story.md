# Production plan — "My M3's Engine Blew. So I Spent $40,000 on a Honda."

**Ship: Friday 7 August 2026.** Written Fri 31 July.
Package: `../drafts/01-origin-story-package.md`

---

## The honest read on this deadline

Seven days is aggressive but real, **and it hinges on one unknown**: nobody has
looked at the archive yet. Every frame is on SD cards and three phones. If the
failure footage doesn't exist, the video changes shape and we find that out on
**Sunday**, not Thursday night.

Two things could kill the date, and both are on the first weekend:

1. **The archive doesn't have the motor coming apart.** Recoverable — we open on
   the aftermath instead. Costs a rewrite, not the date.
2. **The desktop isn't ready.** This laptop cannot edit this video. If the
   desktop isn't wiped, toolchained, and holding the footage by **Sunday night**,
   Friday is gone.

The build also starts this week — parts land around Aug 6. **Filming the build
takes priority over editing the archive.** The build only happens once; the
archive will wait. That's why the protected floor below exists.

## Protected floor vs. the target

| | What ships no matter what |
|---|---|
| **Floor** | **3 Shorts** cut from archive footage, published Wed/Thu/Fri. Requires only the offload and one working ffmpeg. |
| **Target** | The floor **plus** the 12–18 min long-form on Friday. |

If Wednesday arrives and the rough cut isn't assembled, **we ship the floor and
move long-form to Aug 14.** A missed long-form is a scheduling note. A dead feed
for a week is a real cost. Do not trade the floor for the target.

---

## Schedule

### Sat 1 Aug — infrastructure day *(Connor + me)*

Nothing creative happens today. This is the day that makes the rest possible.

- [ ] **Verify the desktop holds nothing irreplaceable, then wipe.** Old footage,
      photos, G's photography work. Once it's gone there's no re-shooting a 2021
      track day.
- [ ] Fresh Windows → install **ffmpeg, Python 3.13, git, yt-dlp**
- [ ] Install **Claude Code on the desktop** — I have to be where the footage is
      to drive ffmpeg and Whisper against it
- [ ] Copy this repo across (or clone it once git's in)
- [ ] **Offload everything** — all SD cards, all three phones — into one tree
- [ ] **Back it up off-site before touching it.** rclone → R2/B2. Years of a
      build existing in exactly one place is how channels die, and today it
      briefly exists in *zero* extra places.

**Blocking for everything after this. If Saturday slips, the ship date slips.**

### Sun 2 Aug — the archive dig *(me, mostly)*

- [ ] `/index-footage` — I build it: ExifTool for real shoot dates, GPU Whisper
      for transcripts, into `library/index.json`
- [ ] **The verdict**: does footage of the motor letting go exist? I answer this
      by Sunday night, in writing.
- [ ] **Employer-safety pass** — badge, uniform, work vehicle, branded anything.
      This is old footage shot before that was a rule. Hard line.
- [ ] I produce the **cut list** — in/out points against the seven beats

**Connor's homework, and it's on the critical path:**

- [ ] **The itemised $40,000 list.** Real receipts. This is a four-minute segment
      and the single thing nobody else in this niche will make. Approximate
      numbers are worse than none — *real numbers or no numbers*.

### Mon 3 Aug — shoot the missing pieces *(Connor + G)*

- [ ] **Thumbnail first.** Blown S50 and the K24 side by side, hands in frame,
      `$40,000` overlay, nothing else. *If the S50 is gone, fallback: you holding
      the failed part, K24 behind you.*
- [ ] Pickup shots for gaps the cut list exposes — I'll have the list Sunday night
- [ ] The **0:00–0:07 open**: blown motor in hand, state the number. **Clean —
      no profanity in the ad-eligibility window.**
- [ ] The **closing beat**: *"We're not building it until we blow it up."* Your
      words, straight to camera. This is the line the whole series hangs on.

### Tue 4 Aug — assembly *(me)*

- [ ] ffmpeg rough cut from the cut list, against originals
- [ ] Silence and filler removal
- [ ] Cost-breakdown graphics — plain text on screen, no motion-graphics theatre
- [ ] Captions, burned in
- [ ] **Hand G a rough cut by end of day**

### Wed 5 Aug — taste pass *(G)* + build starts *(Connor)*

- [ ] G: pacing, music, colour. The last 15% — the part that makes it yours.
- [ ] **Parts land. Build starts. Film it.** This takes priority over editing.
- [ ] **Floor: Short #1 publishes** — the blown motor reveal, 15s, no context
- [ ] I write metadata: description, chapters, **3–5 tags (not 33)**, pinned comment

### Thu 6 Aug — review *(Connor)*

- [ ] Watch it end to end. Every number correct? Any employer identifiers?
- [ ] **Floor: Short #2** — "$40,000. Here's the receipt."
- [ ] Post lands in `publisher/queue/` with media, description, tags, target time
- [ ] **Connor moves it to `publisher/approved/`.** That's the green light and
      the only one. Unapproved = not posted. Silence means no.

### Fri 7 Aug — ship

- [ ] I publish from `approved/`, log the ID to `posted/`
- [ ] **Floor: Short #3** — "This bottom end is stock."
- [ ] Pinned comment goes up: *"Stock bottom end, 500whp target. How long does it
      last? I'll post the answer either way."*
- [ ] Reply to **every** comment for the first 48 hours. The baseline shows **one
      comment across the entire YouTube channel** — the pinned question is the
      first deliberate attempt to fix that, and it only works if you answer.

---

## Owners

| Who | This week |
|---|---|
| **Connor** | Desktop wipe + offload (Sat), the $40k list (Sun), thumbnail + pickups (Mon), review + approve (Thu), comments (Fri+). Build filming from Wed. |
| **G** | Thumbnail and pickup shoot (Mon), taste pass (Wed). From Wed: build footage — **title-first, so she knows the shot before the camera's up**. |
| **Me** | Toolchain, indexing, transcription, cut list, rough assembly, captions, metadata, Shorts, publishing. |

## Success measures

Judge against the 2026-07-31 baseline in `../playbook/hypotheses.md`, not vibes.

| Metric | Baseline | What "worked" looks like |
|---|---|---|
| Long-form on the channel | **0** | 1 |
| Comments on the video | ~0 per post | **>10** — the pinned question is the test |
| Subs | 25 | Any real movement. 0.4% conversion is the number we're attacking. |
| Short views | 830–1,645 | Hold the range; anything above is the title change working |

**One measurement discipline:** don't change five things and claim a win. The
deliberate changes this week are **(1)** long-form exists, **(2)** titles carry
information, **(3)** a pinned question invites comments, **(4)** 3–5 tags instead
of 33. If comments jump, it's most likely (3) — log it against **O2/O3** rather
than declaring the whole strategy correct.

## Open risks

| Risk | Impact | Mitigation |
|---|---|---|
| Failure footage doesn't exist | Rewrite the first act | Answer it **Sunday**, open on the aftermath |
| Desktop not ready by Sun night | **Kills the date** | Saturday is infrastructure-only for exactly this reason |
| $40k list incomplete | Guts the differentiating segment | Connor starts it Sunday; partial-but-real beats complete-but-estimated |
| Build eats the week | Editing slips | **Ship the floor.** Long-form moves to Aug 14. |
| Blown S50 already scrapped | Thumbnail weakens | Fallback concept already specified |
