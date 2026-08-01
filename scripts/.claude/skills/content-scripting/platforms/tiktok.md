---
platform: tiktok
last-verified: 2026-07-31
verified-by: TikTok Transparency Center (decoded JS payload), TikTok Newsroom, Creator Rewards docs
---

# TikTok

## Mechanics  <!-- ROTS FAST — re-verify quarterly -->

**Five stages** [T1]: candidate selection → per-viewer prediction → ranking →
similarity check → recommendation rules.

**Predicted interactions, verbatim** [T1]: like, share, comment, mark Not
Interested, follow the author or interact with their profile, finish, skip,
favorite, spend a certain amount of time viewing, tap the video's soundtrack.
TikTok labels this list "non-exhaustive" — a floor, not an inventory.

**Video-side signals** [T1]: time posted, region posted from, author's language
setting, soundtrack, video length, hashtags.

**Dominant factor differs per surface**, published separately [T1]:

| Surface | Dominant factor |
|---|---|
| For You | Time spent watching this specific video |
| Friends | Likes and comments |
| Search | Relevance to the term entered |
| Comments | Comment language and like count |

Each is preceded by TikTok's own disclaimer that weighting "can change over
time." **Decide the surface before writing.**

**There is no promotion ladder.** [T1, absence verified] No view pools, no batch
tests, no graduation thresholds, no first-hour window. Per-viewer probability
scoring at request time is structurally incompatible with a global tier system.

**FYF-ineligible, verbatim** [T1] — highest-leverage constraint on this
platform:
- reused or unoriginal content posted without creative edits, such as clips
  showing someone else's watermark or logo
- low-quality or minimally edited content, such as short clips made from GIFs
  only
- tricking others into increasing engagement (like-for-like promises, false
  incentives, misleading claims meant to boost views)
- commercial content not disclosed via TikTok's content disclosure setting

Scope: ineligible means **not recommended in For You**. The post still reaches
followers, profile visitors and search, and the flag is visible in analytics.

**Creator Rewards** [T1, launched out of beta 18 Mar 2024]: original videos
**over a minute long**, judged on originality, play duration ("accounts for both
watch time and finish rate"), **search value** ("a metric assigned to content
based on popular search terms"), and audience engagement. These are monetisation
criteria, not ranking weights — but they are the clearest published statement of
what TikTok wants more of.

**Search is a first-class surface** [T1]. TikTok pays on search value and ships
Creator Search Insights with a **content-gap filter** for "topics searched for
often, but aren't featured in a large number of videos." That gap filter is the
cheapest structural lever available on any platform in this skill.

**Local Feed** [T1, 11 Feb 2026]. US home-screen tab. Posts qualify on
**location, topic, and when the content was posted** — recency is an explicit
eligibility input, not just a ranking one. Excludes under-18 and private
accounts.

| Constraint | Value | Tier |
|---|---|---|
| Aspect / resolution | 9:16, 1080×1920, full-bleed | T1 (letterboxed or upscaled risks the "minimally edited / reused" gate) |
| Length for monetisation | **Over 60 seconds** | T1 |
| Length for reach | No published minimum, maximum, or preferred duration | T1, absence verified |
| Sound | Sound-on-by-default feed; soundtrack tap is a modelled interaction | T1 |
| Captions | Auto-captions are creator-selectable and editable, **not on by default** | T1 |
| Safe zones | Keep burned-in text out of ~right 15%, ~bottom 20%, top tab strip | **Working guidance — not verified against TikTok's ad safe-zone template** |
| Disclosure | Branded-content toggle mandatory for commercial content | T1 |

## Culture  <!-- SEMI-DURABLE -->

Sound-on, full-screen, no thumbnail, no title. Legible in motion or not at all.
TikTok's own 2026 forecast says the community rewards "real process and people
over curated perfection" [T2] — **a claim without a demonstration is the
strongest ad-tell here.**

Automotive note: this is the platform where the engine note is genuinely a
ranking-adjacent asset, because tapping the soundtrack is a modelled action.

## Scripting rules

- **Frame 1 shows the situation already in progress.** Skip is an explicitly
  modelled negative — throat-clearing trains a negative signal, it doesn't
  merely lose a viewer.
- **Write no completion-rate target.** Write to "is there an unresolved thing at
  every second?" Pick the shortest length at which the payoff lands, then cut
  15% of connective tissue.
- **If monetisation matters, exceed 60s — and structure 60–90s as 3–4 chained
  micro-payoffs**, each ~20s block re-earning the next.
- **Write one line that is literally a search query someone would type.** Say it
  aloud in the first 10 seconds and put it in the caption. Highest-ROI single
  line in this file. Automotive queries are unusually literal: "why does my
  [model] [symptom]", "[year range] [model] common problems", "how to [task] on
  a [model]".
- **Demonstrate, do not claim.**
- Exactly **one** deliberate comment hook. Stacked hooks read as bait, and bait
  is a distribution kill here, not a taste issue.
- **Script *for* the sound, not over it.** Audible spine — a voice, a diegetic
  sound, or a beat that coincides with the payoff. A trending sound is not a
  ranking bonus; use one only when the video also works without it.
- If the subject has a physical location, write a local-specific line. Local
  Feed is a second surface keyed on location, topic and recency.
- Last 2 seconds: loop seam or hard stop.
- **Never** engagement bait, reused footage without transformation, or
  undisclosed commercial content. These are eligibility, not optimisation.

## Degradation order

1. Cut connective tissue
2. Cut the second example
3. Merge two micro-payoffs

**Never cut:** the frame-1 state, the spoken search query, the loop seam, or any
payoff for a gap already opened.

## Refuted — do not restate, and correct Sam if he asserts these

- **Tiered view pools, batch testing, graduation thresholds** ("35% completion +
  1.5% engagement reaches 5,000–10,000 viewers"). No first-party source; the
  published architecture is per-viewer probability scoring. Zero hits for "view
  pool," "batch test," "graduation," "completion rate" across the full decoded
  Transparency Center page.
- **"70%+ completion to go viral," "up from 50% in 2024."** Invented.
- **"Watch time is 40–50% of ranking."** No weight has ever been published.
- **"TikTok counts every loop as a view."** No first-party confirmation.
- **Any best-time-to-post table.** Vendor content.
- **"Burned-in captions beat auto-captions by 18–32% completion."** Invented.
- **`tiktok.com/discover/*` is not a first-party source** — those are SEO
  landing pages aggregating user videos.
