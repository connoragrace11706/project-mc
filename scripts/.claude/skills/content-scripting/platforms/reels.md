---
platform: reels
last-verified: 2026-07-31
verified-by: Instagram Ranking Explained, Meta system cards, Mosseri posts, Meta engineering blog
---

# Instagram Reels

## Mechanics  <!-- ROTS FAST — re-verify quarterly -->

**Reels Chaining** [T1]: inventory gathering (accounts followed + content
similar to recent engagement) → lightweight model on cheap features (reel
length, similarity, topical match) selecting ~100 → heavyweight predictions →
"the system calculates a relevance score for about 100 reels and puts them in
order by this score."

**Explore** [T1]: up to 1,500 candidates → two-tower early ranker to ~100 →
multi-task multi-label neural net.

**The nine published prediction heads** [T1]:
1. Use the audio from a reel in one you create
2. **Watch less than three seconds**
3. Click "Interested"
4. Comment
5. **Watch more of a reel than 95% of users who watched reels of the same
   length**
6. Click a tall Explore reel into full screen
7. **Reshare within Instagram**
8. **Share off Instagram**
9. Follow the author

Content-level input signals listed *separately* (the card never maps inputs to
heads): dismissals, sound-on views, three-second views, two-second skips.

**Note head #5.** Watch time is judged as a **percentile against reels of your
own length.** Length is a strategic commitment — a longer reel must beat a
harder retention curve.

**Mosseri's creator-facing compression** [T2]: "The top three signals that
matter most for ranking are watch time, likes and sends," and creators should
watch "average watch time, likes per reach, and sends per reach." **The ratio
framing is load-bearing.** His split: "likes are slightly more important for
connected content, and sends are slightly more important for unconnected
content." **The word is "slightly."** No multiplier has ever been published and
none can be — Meta publishes heads without weights.

**Why sends dominate.** Instagram is a messaging app wearing a feed. Mosseri
[T2]: "The primary way people share now is in DMs... That feed is dead." Meta
reported Reels reshared over 4.5 billion times a day [T2]. Reshare is listed
**first** among Instagram's published predictions and appears as two separate
heads.

**Eligibility gates** [T1]. Reduced visibility for: "low-resolution or
watermarked reels, reels that are muted or contain borders, reels that are
majority text, or reels that have already been posted on Instagram."

Since **30 April 2026**, accounts that "primarily post unoriginal content" are
removed from recommendation surfaces across reels, photos *and* carousels,
regaining eligibility when "most of their recently posted photos, carousels, and
reels are considered original in a 30-day period," rolling. **No numeric repost
threshold is published and none should be assumed.**

| Constraint | Value | Tier |
|---|---|---|
| Aspect / resolution | 1080×1920, 9:16, full-bleed, **no borders**, highest bitrate accepted | T1 — bordered and low-res are named demotions |
| Length cap | 3 minutes | T2 |
| Practical target | 8–15s default | **T4** — vendor sample (Metricool, 24.4M posts), not random Instagram |
| Sound | **Never ship muted.** Sound-on views tracked as a distinct signal | T1 |
| Sound-off share of views | Direction well-established; **the commonly quoted number is uncited** | T1 direction, T5 number |
| Hashtags | Skip them. Keyword captions are the documented discovery path | T4 correlational — do not repeat the suppression figure as causal |
| Safe zones | Bottom ~20%, top ~12%, right ~15%; critical text in a centred ~60%-width column between 15% and 75% vertical | Working guidance |
| Carousels | Strong for saves and follower depth | T4 |

## Culture  <!-- SEMI-DURABLE -->

Relational, not broadcast. The unit of success is a DM, not a view. Automotive
sends well because ownership is an identity — "for the guy in your group chat
who just bought one" is a real relationship, and this platform is built around
that exact act.

The "Your Algorithm" interest controls (Reels US Dec 2025, Explore Apr 2026,
main feed by Jun 2026) [T2] mean **being consistently about an identifiable
topic is now an asset on both sides**: it helps placement, lets interested
viewers opt in, and lets uninterested viewers suppress you. A car account that
is clearly a car account benefits.

## Scripting rules

- **The send test is the gate.** Every script must finish "this is for the
  person who ___." Prefer identity, relational triggers, in-group grievance, or
  a genuinely forwardable fact. An explicit "send this to ___" works only if it
  names a real relationship — **never "tag a friend."**
- **Survive the 2-second skip before optimising for completion.** No logo, no
  title card, no intro.
- **Do not build to a punchline that only pays at the end.** Reshare and rewatch
  both require the viewer to *already* feel rewarded. **Front-load the payoff.**
  This is the single biggest structural difference from YouTube Shorts.
- Write two working layers: a sound-off layer where burned-in text carries full
  meaning, and a sound-on layer that adds a **distinct** reward — "use the audio
  from a reel you're viewing" is a real prediction head, and an engine note is
  exactly the kind of audio people reuse.
- **Never majority-text on screen.** Named demotion.
- **Comment-bait and send-bait are different heads.** A question drives comments;
  comments do not substitute for sends when the goal is stranger reach.
- Captions as searchable descriptive prose. Keywords in captions, alt text and
  on-screen text feed topic classification.
- **Strip TikTok/CapCut watermarks and letterboxing.** Never re-upload a cut
  already posted to Instagram. Archetype P (letterboxed in-group ritual) is
  **not available here** without a full-bleed reframe.
- Benchmark Trial Reels only against other Trial Reels — they skip the follower
  seed entirely.

## Degradation order

1. Cut connective tissue
2. Cut the setup context (the payoff is front-loaded, so context is the cheapest
   loss)
3. Drop to a single visual claim plus the sound event

**Never cut:** the front-loaded payoff, the muted card's claim, the send trigger,
or full-bleed framing.

## Refuted — do not restate, and correct Sam if he asserts these

- **"Sends carry 3–5x the weight of likes."** Mosseri said "slightly." The
  multiplier is invented, and its most-cited attribution chain leads to a source
  that contains no number.
- **"10+ reposts in 30 days removes you from recommendations."** No numeric
  threshold is published.
- **"Original content confirmed at 40–60% more distribution."** Invented.
- **"1.7-second viewer decision window."** Invented.
- **"60–70% retention viral threshold."** Invented.
- **"200 billion Reels plays per day, Zuckerberg, Q3 2025 call."** Misattributed.
- **Any claim that Reels are "not recommended above 3 minutes."** Third-party
  only; no first-party page states it. Treat as a risk boundary, not a rule.
