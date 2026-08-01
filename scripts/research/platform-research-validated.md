# Build Spec: Social Content Scripting Agent for Claude Code

**Scope:** an agent that writes *scripts and posts you will produce yourself*. Not a publishing bot. Distribution knowledge exists here to constrain the writing, not to automate posting.

**Confidence tiers used throughout.** Every number carries one. Anything below T3 never becomes a target the agent optimises against.

| Tier | Meaning | Encode as |
|---|---|---|
| **T1** | First-party technical documentation or published source code | Mechanism. Safe to cite and act on. |
| **T2** | First-party statement — exec quote, help page, marketing research, earnings call | Direction and stated intent. Self-interested; never mechanism. |
| **T3** | Peer-reviewed or preregistered independent research | Effect direction; hold magnitudes loosely. |
| **T4** | Vendor study with published methodology and sample | Directional benchmark for that cohort only. Never a target. |
| **T5** | Uncited vendor blog, SEO listicle, AI search summary | **Never encoded. Actively refuted in the skill files.** |

---

## 1. What actually makes content travel, and why

There are two layers and they fail in different ways. Conflating them is the single most common error in creator advice, because a tactic that works on the human layer gets re-explained as a ranking exploit, and a ranking constraint gets re-explained as a psychological law.

### 1a. The human layer — durable mechanism, thinner evidence than advertised

The causal chain that survives scrutiny is narrower than the popular version:

**Attention is captured by a salient information gap opened inside a domain where the viewer already has a foothold.** This is Loewenstein 1994 (T3), and the foothold requirement is the part everyone drops. Curiosity is *reference-point dependent* — "the same degree of knowledge can evoke or not evoke curiosity depending on the level of one's reference point" — and it *requires an existing knowledge base*, not its absence (Jones 1979: r = .51 between self-rated knowledge of an item and curiosity about it). A gap opened in a domain the viewer has no purchase on produces indifference, not curiosity. This is why every top creator independently invented a context-establishing beat *before* the hook: Kallaway's "Context Lean," MrBeast's "match click expectations," Hoyos's "hook then foreshadow."

Loewenstein's five situational triggers are the operational core, and they are the most directly usable thing in the entire corpus:

1. A posed question or riddle
2. A sequence with an anticipated but unknown resolution — **amplified when the viewer generates their own prediction**
3. Violation of an expectation (also shifts the viewer from heuristic to systematic processing)
4. Someone else's possession of information
5. Awareness of having once known something

**Curiosity's default outcome is disappointment.** Loewenstein: satisfying a gap "eliminates the deprivation but leaves one in a neutral state... the transition from aversive deprivation to a neutral state is exceedingly fleeting," and he predicts satisfying cases "will be outnumbered by those in which the information one receives is seen as disappointing." This is the single most important design constraint in this document. Every gap you open incurs a debt, and the payoff must beat a baseline the gap itself raised. It is also why all four creators converged on scheduled re-payment — secondary hook, foreshadow, MrBeast's "3 minute re-engagement." **Curiosity debt is a resource to be tracked, not a lever to be pulled repeatedly.**

**Sharing is a social act about the sharer, not about the content.** This is the part where the popular literature is weakest and the platform evidence is strongest. What failed: Berger 2011's arousal-causes-sharing experiment failed to replicate twice at N=111 and N=160 (Prowten et al. 2024, T3) — "our studies cast doubt on the idea that incidental physiological arousal... impacts people's decisions to share." What survives: Berger & Milkman's 2012 field study (T3, 6,956 NYT articles), where **practical value (+30%) matched awe and beat anxiety, and interest (+25%) also beat anxiety** — and where all four emotion terms together added only ~.07 McFadden pseudo-R², rising to .28 only once length, homepage placement, author and section entered. Emotion is a minor term in a model dominated by placement and topic. STEPPS has no peer-reviewed six-factor validation; it is a taxonomy, not a model.

The platform evidence for the social-act reading is much stronger than the psychology. Instagram runs *two separate prediction heads* for reshare-in-app and share-off-platform (T1); X scores share, share_via_dm and share_via_copy_link as three distinct actions (T1); Mosseri names sends-per-reach as the signal that unlocks non-follower reach (T2). Platforms model sharing as a distinct behaviour, not a byproduct of watching. **Design implication: the send test is "can you finish the sentence *this is for the person who ___*?" not "is this good?"**

**Tension is real; the mechanism everyone cites for it is not.** The Zeigarnik memory effect does not replicate — 38 publications, interrupted:completed recall ratio **0.99**, d_z ≈ 0.15 (T3, 2025 meta-analysis). Do not write "open loops work because the brain can't let go." What *does* replicate in the same literature is the **Ovsiankina resumption effect: interrupted tasks voluntarily resumed ~67% of the time across 21 publications** — a behavioural return tendency, which is a far better model for "part 2" and series content than the memory claim ever was.

Cliffhangers raise arousal and **do not raise enjoyment or continuation intent** (Wirz et al., N=133, EDA + cortisol; replicated in a second pair of experiments, T3). Spoilers do not reliably reduce enjoyment. Narrative transportation does hold: β = .236, 95% CI [.139, .332] (T3 meta-analysis).

**There is a measured optimum for how much you withhold, and most content is on the wrong side of it.** The Upworthy Registered Report (T3, 8,977 field experiments, 35,910 headlines): below 2.58 concreteness, adding specificity raised clicks ~+5.5%; above 3.06, adding specificity *cut* clicks ~−9.9%. Only 8.7% of real headlines benefited from more specificity; 50.9% were hurt by it. The lesson is not "be vague" — it is that a narrow band exists and most writers overshoot it in one direction or the other with no awareness there is a band at all.

**Authenticity is not roughness.** There is direct contrary evidence: identical news stories at higher production value were judged *more* credible (T3, Cummins & Chambers). No controlled study shows overproduced content gets less organic engagement. What is penalised is **perceived commercial intent and genericness**, which is a different thing. Supported levers: personal disclosure (Collins & Miller meta-analysis, d = .281 — modest but robust), genuine subject-matter fit, explicit disclosure of commercial relationships. **Not** supported: first-person pronouns, deliberate disfluency, unpolished syntax, "admitting uncertainty" as a reliability signal — hedges and hesitations move authority, sociability and character judgments in *different* directions (T3).

**People cannot detect AI text, and this reframes the entire problem.** Untrained evaluators are at chance (Clark et al. 2021, T3); training raises accuracy to at most 55%. Jakesch et al. (PNAS, T3): ~52% accuracy, and readers rely on *wrong* cues — grammatical errors, long words, first-person pronouns, contractions. The devastating number: **AI profiles optimised to exploit those human heuristics were judged human 65.7% of the time, versus 51.7% for actually-human profiles.** Audiences are not running a lexical classifier. What they detect — and what platform policy actually polices — is **structural genericness**: content that could be topic-swapped with light editing, containing no first-hand particular, no number that could only come from one source, no stake.

This is confirmed by policy language, not inference. YouTube renamed its policy to "inauthentic content" (15 Jul 2025) and names as ineligible: *"AI-generated content made with generic or unoriginal templates giving the impression of mass production without adding the creator's original, authentic insights or perspective."* Google Search's scaled-content policy: *"no matter how it's created."* TikTok's FYF-ineligible list names *"low-quality or minimally edited content."* **Every major platform now polices genericness and explicitly declines to police AI use as such.**

The lexical tells that *are* measured (Kobak et al., *Science Advances*, 14.4M PubMed abstracts, T3) are content words, not punctuation: *delves* r=28.0, *underscores* r=10.9, *showcasing* r=10.2; 319 excess style words in 2024, **66% verbs, 16% adjectives** — the first year the excess vocabulary was stylistic rather than event-driven. I found **no** empirical support for the tells everyone actually cites: "not just X, it's Y," rule-of-three lists, em-dash frequency, uniform paragraph length, "In conclusion." Those are reader heuristics, not forensic criteria.

### 1b. The distribution layer — five different machines that share four properties

Every platform in scope converged on the same architecture, arrived at independently, and the convergence is the durable part:

| Property | Evidence |
|---|---|
| **Multi-stage funnel: retrieve → cheap filter → expensive rank → post-filters** | TikTok 5-stage (T1); Instagram Explore 1,500 → ~100 → multi-task net (T1); Instagram Reels Chaining lightweight → ~100 (T1); X Home Mixer source → hydrate → pre-filter → score → post-filter (T1) |
| **Ranking is per-viewer predicted probability of specific named actions, not a global quality score** | TikTok predicts like/share/comment/Not Interested/follow/finish/skip/favorite/dwell/soundtrack-tap (T1); Instagram publishes 9 heads and names PLIKE/PCOMMENT/PFOLLOW (T1); X publishes 19 in `PhoenixScores` (T1) |
| **Negative actions are separately modelled and heavily weighted** | TikTok models skip + Not Interested (T1); Instagram models short-watch + Not Interested (T1); X models not_interested, block_author, mute_author, report, and in the only weights ever published, report was −369 against a like at 0.5 (T1) |
| **Eligibility gates sit upstream of ranking and are binary** | TikTok FYF-ineligible list (T1); Instagram's demotion list + Apr 2026 originality regime (T1); YouTube inauthentic-content policy (T1); Reddit mod removal + AutoModerator karma/age gates |

Four more structural facts that hold across the set:

- **Follower count is not a direct ranking input on the recommendation surfaces.** TikTok says so verbatim (T1). X's published Phoenix ranker takes ID hashes and the viewer's action sequence with no popularity features in the released model code (T1, with the caveat that the request builder is unpublished). YouTube: evaluation is per-video, not per-channel (T1). Consequence: **every piece re-earns its audience from zero, and the script cannot assume prior context.**
- **Diversity constraints are enforced mechanically.** TikTok's similarity check swaps out near-duplicates and won't serve two consecutive videos with the same sound or creator (T1). X's `AuthorDiversityScorer` multiplies your Nth post in one feed response by `(1−floor)·decay^position + floor` (T1). Reddit's Home feed sorts "to ensure a level of diversity" (T1). **Posting more does not stack; it competes with itself.**
- **Follower reach and stranger reach are separate problems with separate signals.** X has an explicit `OONScorer` discount for out-of-network (T1). Instagram: likes skew connected, sends skew unconnected (T2). Trial Reels underperform *because* they skip the follower seed. Decide which you're writing for before you write.
- **No platform has ever published a numeric ranking weight for any factor.** TikTok's model card explicitly warns weighting "can change over time." xAI stripped the entire `params` module before releasing the code. Meta publishes prediction heads without weights. **This is a structural fact, not an oversight — which means every specific weight in circulation is invented.**

### 1c. What the two layers mean together

The human layer sets what a viewer *does*. The distribution layer sets which of those actions the machine *counts*, and how much. So the pipeline is:

> Write to produce a specific human action → check that the target platform separately models that action → check the piece clears that platform's eligibility gates → check the format constraints don't destroy the delivery.

Most bad advice collapses one of these steps into another. "Watch time is 40% of the algorithm" collapses a human behaviour into a fabricated weight. "Post at 9am" invents a distribution mechanism with no human behaviour behind it. "Add a hook because of Zeigarnik" invents a human mechanism to justify a real craft rule.

**The rule the agent follows: mechanisms are durable and citable; magnitudes are perishable and mostly fake.** X's mechanisms survived a full rewrite from Scala/MaskNet to Rust/Grok-transformer across three years. Its magnitudes have never been published for the current system and were stale within months when they were.

---

## 2. Per-platform brief

### 2.1 TikTok

**How distribution works (T1).** Five stages: candidate selection → per-viewer prediction → ranking → similarity check → recommendation rules. Predicted interactions, verbatim from the Appendix: like, share, comment, mark Not Interested, follow the author or interact with their profile, finish, skip, favorite, spend a certain amount of time viewing, tap the video's soundtrack. Video-side signals: time posted, region posted from, author's language setting, soundtrack, video length, hashtags. TikTok labels this "non-exhaustive" — a floor, not an inventory.

Dominant factor differs *per surface*, and TikTok publishes them separately (T1): For You — time spent watching this specific video; Friends — likes and comments; Search — relevance to the term entered; Comments — comment language and like count. Each statement is preceded by TikTok's own disclaimer that weighting "can change over time." **Decide which surface a piece is for before writing it.**

There is **no promotion ladder.** No view pools, no batch tests, no graduation thresholds, no first-hour window. The published architecture is per-viewer probability scoring at request time, which is structurally incompatible with a global tier system. Full-text search of the decoded 2.3MB Transparency Center page returns zero hits for "view pool," "batch test," "graduation," and "completion rate."

**Eligibility gates (T1, highest leverage).** FYF-ineligible, verbatim: reused or unoriginal content posted without creative edits, such as clips that show someone else's watermark or logo; low-quality or minimally edited content, such as short clips made from GIFs only; tricking others into increasing engagement (like-for-like promises, false incentives for gifting or following, misleading claims meant to boost views); commercial content not disclosed via TikTok's content disclosure setting. Scope note: ineligible means *not recommended in For You* — the post still reaches followers, profile visitors and search.

**What TikTok pays for (T1, Creator Rewards, launched out of beta 18 Mar 2024).** Original videos **over a minute long**, on four metrics: originality ("quality content unique to the creator, showcasing their point of view"), play duration ("accounts for both watch time and finish rate"), **search value** ("a metric assigned to content based on popular search terms"), audience engagement (likes, comments, shares). These are monetisation criteria, not ranking weights — but they are the clearest published statement of what TikTok wants more of.

**Search is a first-class surface (T1).** TikTok pays on search value and ships Creator Search Insights with a "For You" filter *and* a **content-gap filter** for "topics searched for often, but aren't featured in a large number of videos on TikTok." That gap filter is the cheapest structural lever available on any platform in this document.

**Local Feed (T1, 11 Feb 2026).** US home-screen tab. Posts qualify on **location, topic, and when the content was posted** — recency is an explicit eligibility input, not just a ranking one. Excluded: under-18 accounts, private accounts, Friends/Only-You posts.

**Format constraints.**

| Constraint | Value | Tier |
|---|---|---|
| Aspect / resolution | 9:16, 1080×1920, full-bleed | T1 (letterboxed/upscaled risks the "minimally edited/reused" gate) |
| Safe zones | Keep burned-in text out of ~right 15%, ~bottom 20%, and the top tab strip | **Working guidance, not verified spec.** Verify against TikTok's ad safe-zone template before shipping. |
| Length for monetisation | **Over 60 seconds** | T1 |
| Length for reach | No published minimum or maximum, and no stated preferred duration | T1 (absence verified) |
| Sound | Sound-on-by-default feed; soundtrack tap is a modelled interaction | T1 |
| Captions | Auto-captions are creator-selectable and editable, **not on by default** | T1 |
| Disclosure | Branded-content toggle mandatory for commercial content | T1 |

**Scripting rules.**
- Frame 1 shows the situation already in progress. Skip is an explicitly modelled negative — throat-clearing trains a negative signal, it doesn't merely lose a viewer.
- Write no completion-rate target. Write to "is there an unresolved thing at every second?" Pick the shortest length at which the payoff lands, then cut 15% of connective tissue.
- **If monetisation matters, exceed 60s — and structure 60–90s as 3–4 chained micro-payoffs**, so each ~20s block re-earns the next. This is the curiosity-debt schedule applied to a hard platform constraint.
- **Write one line that is literally a search query someone would type.** Say it aloud in the first 10 seconds and put it in the caption. This is the highest-ROI single line in the whole TikTok brief.
- Demonstrate, do not claim. TikTok's own 2026 forecast says the community rewards "real process and people over curated perfection" — a claim without a demonstration is the strongest ad-tell.
- Exactly **one** deliberate comment hook: an omission, a contestable ranking, a visible mistake left in, or a genuine open question. Stacked hooks read as bait, and bait is a distribution kill, not a cringe issue.
- Script *for* the sound, not over it. Audible spine — a voice, a diegetic sound, a beat that coincides with the payoff. A trending sound is not a ranking bonus; use one only when the video also works without it.
- If the subject has a physical location, write a local-specific line. Local Feed is a second surface keyed on location, topic and recency.
- Last 2 seconds: loop seam or hard stop. Never "anyway, thanks for watching."
- **Never** engagement bait, never reused footage without transformation, never undisclosed commercial content. These are eligibility, not optimisation.

---

### 2.2 Instagram Reels

**How distribution works (T1).** Reels Chaining: inventory gathering (accounts you follow + content similar to recent engagement) → lightweight model using cheap features (reel length, similarity, topical match) selecting ~100 → heavyweight predictions → "the system calculates a relevance score for about 100 reels and puts them in order by this score." Explore: up to 1,500 candidates (item collaborative filtering, personalized PageRank, two-tower sparse sourcing) → two-tower early ranker to ~100 → multi-task multi-label neural net. Instagram runs 1,000+ ML models across surfaces, outputs named PLIKE/PCOMMENT/PFOLLOW.

**The nine published prediction heads (T1).** Use the audio from a reel in one you create; watch less than three seconds; click "Interested"; comment; **watch more of a reel than 95% of users who watched reels of the same length**; click a tall Explore reel into full screen; reshare within Instagram; share off Instagram; follow the author. Content-level input signals listed *separately* (the card never maps inputs to heads): dismissals, sound-on views, three-second views, two-second skips.

Note the long-watch definition. **Watch time is judged as a percentile against reels of your own length.** Length is therefore a strategic commitment: a longer reel must beat a harder retention curve. Explore's card additionally names "watched 95%+" and "viewed 5+ seconds" as targets plus a Not Interested head.

**Mosseri's creator-facing compression (T2).** "The top three signals that matter most for ranking are watch time, likes and sends," and creators should watch "average watch time, likes per reach, and sends per reach." The ratio framing is load-bearing. His split: "likes are slightly more important for connected content, and sends are slightly more important for unconnected content." **The word is "slightly."** No multiplier has ever been published and none can be — Meta publishes heads without weights.

**Why sends dominate the culture.** Instagram is a messaging app wearing a feed. Mosseri's year-end memo (T2): "The primary way people share now is in DMs... That feed is dead. People stopped sharing personal moments to feed years ago." Meta reported Reels reshared over 4.5 billion times a day (Q4 2024 call, T2). Reels and DMs occupy the first two tabs. Reshare is listed *first* in Instagram's Ranking Explained predictions and appears as two separate heads on the system card. Meta cited reshares specifically as evidence its Q2 2026 ranking release was matching content better.

**Eligibility gates (T1).** Reduced visibility for: "low-resolution or watermarked reels, reels that are muted or contain borders, reels that are majority text, or reels that have already been posted on Instagram." Since **30 April 2026**, accounts that "primarily post unoriginal content" are removed from recommendation surfaces across reels, photos *and* carousels, regaining eligibility when "most of their recently posted photos, carousels, and reels are considered original in a 30-day period," rolling. **No numeric repost threshold is published and none should be assumed.**

**Format constraints.**

| Constraint | Value | Tier |
|---|---|---|
| Aspect / resolution | 1080×1920, 9:16, full-bleed, no borders, highest bitrate accepted | T1 (bordered and low-res are named demotions) |
| Length cap | 3 minutes confirmed Jan 2025 | T2 |
| "Not recommended above 3 min" | **Third-party only — no first-party page states this.** Treat as a risk boundary, not a rule. | T5-adjacent |
| Practical target | 8–15s default, anchored to 8.5s platform-average watch time | **T4** (Metricool, 24.4M posts, 375k accounts — vendor sample of Metricool users, not random Instagram) |
| Safe zones | Bottom ~20%, top ~12%, right ~15%; critical text in a centered ~60%-width column between 15% and 75% vertical | Working guidance |
| Sound | Never ship muted. Sound-on views tracked as a distinct signal. | T1 |
| Sound-off share of views | "About half" — **uncited secondhand attribution of a Mosseri interview; do not quote as a statistic.** Direction is well-established. | T5 for the number, T1 for the direction |
| Hashtags | Metricool: ≥1 hashtag correlated with 31.70% fewer views, 33.89% fewer interactions | **T4, and correlational — almost certainly common-cause, not hashtags causing suppression.** Skip them anyway; keyword captions are the documented discovery path. |
| Carousels | ~9× the saves of single images; single images collapsing (reach −22%, engagement −46% YoY) | T4 |
| Reels vs TikTok views | Reels ~30% fewer views than comparable TikTok videos | T4 |

**Scripting rules.**
- **The send test is the gate.** Every script must finish "this is for the person who ___." Prefer identity/relational triggers, in-group grievance, or a genuinely forwardable fact. An explicit "send this to ___" works only if it names a real relationship, never "tag a friend."
- Survive the 2-second skip before optimising for completion. No logo, no title card, no "hey guys."
- **Do not build to a punchline that only pays at the end.** Reshare and rewatch both require the viewer to *already* feel rewarded. Front-load the payoff; let the rest add texture. (This is the single biggest structural difference from YouTube Shorts, where the open loop closing at the end is correct.)
- Write two working layers: a sound-off layer where burned-in text carries full meaning, and a sound-on layer that adds a distinct reward — because "use the audio from a reel you're viewing" is a real prediction head.
- Never majority-text on screen. Named demotion.
- Comment-bait and send-bait are **different heads.** A question drives comments; comments do not substitute for sends when the goal is non-follower reach.
- Split intent by format before writing: strangers → Reel; depth with existing followers or saves → carousel. Never write a carousel script as a Reel.
- Captions as searchable descriptive prose. Keywords in captions, alt text and on-screen text feed topic classification and the LLM-derived interest labels users now see in "Your Algorithm" (launched Reels US 10 Dec 2025, Explore Apr 2026, main feed by Jun 2026 — T2). **Being consistently about an identifiable topic is now an asset on both sides: it helps placement and lets interested viewers opt in — and lets uninterested viewers suppress you.**
- Strip TikTok/CapCut watermarks and letterboxing. Never re-upload a cut already posted to Instagram.
- Benchmark Trial Reels only against other Trial Reels — they skip the follower seed entirely.

---

### 2.3 YouTube Shorts

**How distribution works (T1).** The load-bearing sentence, verbatim from Help: "Our systems use the signals for % of viewers who chose to view, avg. view duration and avg. % viewed to inform ranking," plus "likes and post-watch survey results" as enjoyment gauges. **Comments and shares are not named in that list.** Absence from one help page is not proof of exclusion — YouTube's docs are deliberately partial — but it is a meaningful difference from TikTok, where comment probability is an explicit predicted interaction.

The Shorts tab ranks "based on their performance and relevancy to that individual viewer," personalising on which Shorts/channels the viewer enjoyed before, topics they watch, and sounds they engaged with. **Evaluation is per-video, not per-channel** (T1): "Experimenting with new content formats... will not inherently confuse the algorithm or negatively impact a channel's overall performance" and "The system evaluates each piece of content individually."

**The metric trap that changes everything (T1).** Since **31 March 2025**, a Shorts *View* counts the moment a video starts to play **or replays**, with no minimum watch time. *Engaged views* is defined as "How many times viewers stayed to watch past the initial seconds, not including any loops." **YPP eligibility and Shorts ad revenue share both run on Engaged views.** Consequence: loops inflate Views and earn nothing. Loops are a payoff device, not a distribution device. Any statistic whose denominator spans 31 Mar 2025 is measuring a definitional change, not audience change — including the CEO's own "200 billion daily views" (T2, 21 Jan 2026), which is not comparable to the pre-2025 70B/90B figures.

**No benchmark exists for Viewed vs Swiped Away (T1, absence verified).** YouTube shipped the metric with zero interpretive guidance. The metric is also confounded by traffic source — a Short surfaced to a well-targeted audience shows a high viewed rate for reasons unrelated to quality — so a universal threshold is not a coherent construct even in principle. **Compare a Short against the distribution of your own channel's recent Shorts.**

**Timing is not a lever (T2).** Todd Sherman, Director of Shorts PM (Aug 2023): publishing time is irrelevant unless covering news; quality over quantity; delete-and-reupload can be flagged. The "first 30–60 minutes decides everything" model is imported from long-form and subscriber-feed dynamics the Shorts feed does not share.

**YouTube publishes unusually concrete creative guidance (T1, 16 Apr 2025 and 14 Jul 2026).** Open with "a question, a surprising fact, or a visually captivating moment." "Get to the point quickly." "Shorts are often watched without sound, so captions are essential." Crop to 9:16. Build verbal *and* visual cues during the final 5 seconds. And the one most creators skip: **"The first 5 to 10 seconds of your long video should directly address the topic, question, or hook promised in the Short."** YouTube explicitly debunks the myth that trending audio is required — "Original content and unique ideas succeed without trending audio."

**Format constraints.**

| Constraint | Value | Tier |
|---|---|---|
| Classification | Any video uploaded on or after **15 Oct 2024** that is square or vertical and ≤3 minutes is automatically a Short. Not retroactive. | T1 |
| Resolution | Max upload 1080p; 1080×1920 practical target | T1 |
| Sound | Assume muted; burn captions | T1 |
| Safe zones | **No official safe-area spec for organic Shorts** (only for Shorts *ads*). Practically: keep out of bottom ~20% and right ~15%. | Working guidance |
| CTA | Final 5 seconds, verbal + visual cue; route to long-form via the Related Video tool in Studio (Content → select Short → Related video), not a description link | T1 |
| Monetisation | YPP via Shorts: 1,000 subs + **10 million valid public Shorts views in 90 days** (defined internally as engaged views). Shorts feed watch hours do **not** count toward the 4,000-hour path. **45%** revenue share vs long-form's 55%. | T1 |

**The economic fact that should govern format choice:** anything vertical and under 3 minutes uploaded now is irreversibly a Short at 45%, and its feed watch time earns nothing toward the long-form path. Format is an economic decision made at upload, not an editorial one.

**Scripting rules.**
- Write the **first frame** to survive a swipe, not the first 3 seconds. Line 1 must read as a complete proposition on a muted, thumbnail-sized frame.
- Open with one of YouTube's three named devices. If the first sentence would still make sense with "Hey guys" in front of it, rewrite it.
- **Set an open loop in the first sentence and close it in the last.** Every script must answer: what question is the viewer holding at second 5 that is only answered at the final second? (Opposite structure from Reels — here avg. % viewed is a named ranking input and the payoff belongs at the end.)
- Never put load-bearing information only in the audio track. Any number, name or punchline also exists as on-screen text.
- Do not script comment-bait as a distribution lever here. Comments are not in the named ranking sentence; likes and post-watch surveys are. **Write for satisfaction — "was this worth 30 seconds" — not for provoked replies.**
- Do not script loop-bait as a distribution play. Loops inflate a metric that doesn't pay.
- Make the topic legible in the first second. The feed matches on topic affinity; a script that takes 8 seconds to reveal its subject is being *mis-matched*, not merely under-retained.
- If routing to long-form, write the long-form intro to deliver the Short's exact promise in its first 5–10 seconds. **The handoff fails on the destination side more often than the CTA side.**
- Write every Short to stand alone, even when it's a clip. The feed is a discovery surface with no assumed prior context.
- Do not delete and re-upload an underperformer.

---

### 2.4 X / Twitter

**How distribution works (T1, `github.com/xai-org/x-algorithm`, repo created 19 Jan 2026, last commit 15 May 2026).** Four components: **Home Mixer** (Rust orchestrator), **Thunder** (in-memory store of recent in-network posts), **Phoenix** (a Grok-1-derived transformer doing retrieval and ranking), **Grox** (a Python Grok inference fleet that reads content).

Per request: hydrate the viewer's recent action sequence → source from Thunder (in-network) and Phoenix two-tower ANN (out-of-network) → hydrate → pre-scoring filters (age, dupes, self-posts, blocked/muted authors, muted keywords, already-seen, already-served) → score → top K → post-selection visibility filters → blend ads/prompts/who-to-follow.

**The 19 scored actions in `PhoenixScores` (T1, struct verified field-by-field):** favorite, reply, retweet, quote, click, profile_click, vqv (video quality view), photo_expand, share, share_via_dm, share_via_copy_link, dwell, quoted_click, follow_author, dwell_time (continuous), and the four negatives — not_interested, block_author, mute_author, report. **There is no bookmark field**; repo-wide grep returns zero hits, despite bookmarks existing in the 2023 and 2025 Scala rankers.

Three stacked scorers: **Weighted Scorer** computes Σ weight_i × P(action_i); **Author Diversity Scorer** multiplies by `(1−floor)·decay^position + floor` where position is that author's rank-index among their own candidates after sorting by score — your best post in a feed load is undiscounted, each subsequent one attenuates toward a floor; **OON Scorer** multiplies out-of-network candidates by `OON_WEIGHT_FACTOR` under the comment "Prioritize in-network candidates over out-of-network candidates."

**None of the weights are published.** Every scorer does `use crate::params as p;` against a module that is not in the repository. `grep FAVORITE_WEIGHT` returns exactly one hit — the use site. Also stripped: `OON_WEIGHT_FACTOR`, `AUTHOR_DIVERSITY_DECAY`, `AUTHOR_DIVERSITY_FLOOR`, `MIN_VIDEO_DURATION_MS`. Python follower thresholds are blanked to empty strings. **Any 2026 numeric weight quoted anywhere is quoting something not in the repository.**

**Grok reads the content (T1).** ASR transcription over video attachments (skipping GIFs, which have no audio); multimodal post embeddings truncated to 1024 dims with a 4096-token text budget; spam/safety classifiers; a **"banger initial screen"** where a Grok VLM emits `quality_score` 0–1 (`banger_initial_positive = score >= 0.4`) plus a `slop_score`; and a **reply ranker** scoring replies 0–3. *Caveat:* the published Phoenix ranker's inputs are ID hashes, action types, product surface and a post-age bucket — the path from Grok embeddings into ranking is **not shown** in the release, and the grox pipeline is task-scheduled, rate-limited and filtered rather than exhaustive.

**The reply mechanism small accounts should actually use (T1).** `TaskReplyRankingFilter` skips a reply when *both* the parent-author and root-author follower counts fall at or below a threshold, emitting skip reason **`low_blast_radius`**. Self-replies are excluded outright. **A substantive reply under a large account's post is Grok-ranked 0–3 and can be promoted; the same reply under a small post is never ranked at all; replying to yourself is not this mechanism.**

**The folklore correction that matters most (T1).** The famous weight table (fav 0.5, retweet 1.0, reply 13.5, good_profile_click 12.0, reply_engaged_by_author 75.0, negative_feedback_v2 −74.0, report −369.0) is real, from `twitter/the-algorithm-ml/projects/home/recap/README.md`, dated **5 April 2023**, describing a MaskNet model that no longer exists. It weights **predicted probabilities, not engagement counts.** The same README: the weights "were originally set so that, on average, each weighted engagement probability contributes a near-equal amount to the score." **A high weight signals a rare action, not a valuable one.** And 75.0 was never for a reply — it was `reply_engaged_by_author`: a reply the original author replies back to.

What survives: **negatives dominate the arithmetic** (report −369 vs like 0.5 — two to three orders of magnitude), and **content that pulls the author back into the thread is structurally distinct from content that collects passive likes.**

**Format constraints.**

| Constraint | Value | Tier |
|---|---|---|
| Length | 280 chars free; ~25,000 Premium; Premium+ Articles. Long posts render collapsed — the pre-fold portion is the real hook. | T1/T2 |
| URLs / emoji in char count | URLs ~23 chars regardless of length; emoji 2 chars each | T2 (documented in working repos) |
| Media | `photo_expand` and `vqv` are distinct scored actions text-only posts can never earn | T1 |
| Video minimum | VQV weight is gated on duration exceeding a minimum — **10s in the 2023 code**; the 2026 constant is stripped. Sub-10s clips likely forfeit the video signal. | T1 for the gate's existence, T1-2023 for the value |
| Video audio | Grox runs ASR on video and feeds it into the multimodal embedding. **Silent text-card video is invisible to content understanding.** | T1 |
| Links | Put them in the post body. No link/URL/has_link feature exists anywhere in the 2026 ranking code (verified by full-repo grep); X's Head of Product (28 Jul 2026) and Musk (29 Jul 2026) both stated the penalty ended over a year prior. | T1 + T2 |
| Threads | `DedupConversationFilter` keeps only the **single highest-scoring candidate per conversation_id**. A 12-post thread gets one shot at a viewer's feed, not twelve. | T1 |
| Premium boost | **None in published code.** The only subscription logic is `IneligibleSubscriptionFilter`, which removes paywalled posts from non-subscribers. TweepCred was real in 2023 and is gone. | T1 (argument from absence in a stripped repo) |
| Recency | Both a gate (`AgeFilter` max_age, Thunder retention with 2-min auto-trim) **and** a learned signal (Phoenix embeds a post-age bucket at 60-min granularity capped at 80 hours) | T1 |

**Scripting rules.**
- Lead with the claim in the first line. Dwell and continuous dwell_time are separately scored; the first ~10 words decide whether dwell accrues at all.
- **Engineer a reply, not a like:** the post needs a hole a knowledgeable reader wants to fill. A stated position with one deliberate unhedged edge beats a balanced summary.
- **Budget time to reply to repliers.** Author-engaged conversation is the shape being rewarded. Write posts you intend to work the replies of.
- One idea per post; space posts out. Author diversity decays your Nth post within a single viewer's feed response.
- Attach native media when the content supports it; if video, exceed ~10s and put the substance in the spoken audio.
- Write for one specific reader. The ranker scores against an individual viewer's action-sequence embedding with no popularity features in the released model. **Niche-legible specificity — a real number, a real error message, a named tradeoff — outperforms broad-appeal phrasing.**
- Small account? Strategic substantive replies under large accounts are the only code-confirmed path into someone else's audience.
- **Never write anything a reader would mute or report.** Negatives carry the largest magnitudes ever published on this platform.
- Avoid AI-slop cadence — generic listicle rhythm, LLM prose tics, thread boilerplate. There is a code-confirmed `slop_score` and a `GrokSlopScoreRescorer` that multiplies flagged candidates by a decay factor (feature-switched, decay value unpublished).
- Post 1 of any thread must stand alone and be viral on its own. That is the unit that gets ranked.
- Do not claim bookmarks boost reach. Optimise for DM-shareability instead — three of the 19 actions are share variants.

---

### 2.5 Reddit

**Two systems, not one.**

**(1) Legacy `hot` (T1 as a historical artifact, not verified live).** From `reddit-archive/reddit`, `r2/lib/db/_sorts.pyx`, last modified 2015-08-17, repo archived 2017:

```
round(sign * log10(max(|ups−downs|, 1)) + (epoch_seconds − 1134028003) / 45000, 7)
```

Three inputs: ups, downs, timestamp. **No comment term, no velocity term, no first-hour multiplier.** 45000s = 12.5h, so one order of magnitude of net score exactly offsets 12.5 hours of age. Holding rank against a newer post costs ~20.2% more net upvotes per hour (10^(3600/45000) = 1.2023), ~83× over 24 hours. Because score is logarithmic, **1→10 net upvotes buys exactly as much rank as 100→1000 or 1000→10000.** At 1,000 upvotes, nine more move rank by 0.0039.

This is the real mathematical basis for "early votes matter most" — a property of log scaling, not a hidden bonus. **Reddit has never published a successor and describes its current feeds as ML-ranked, so treat this as canonical illustration of the ranking *shape*, not as live production code.**

`best` (default comment sort) is Wilson score lower bound at z = 1.281551565545, time-independent, precomputed for ups<400/downs<100 — a good early comment keeps ranking on ratio, not volume.

**(2) Home feed (T1, current, from Reddit Help).** Verbatim: "We first create an initial list of content you might enjoy (i.e., candidate generation). Then we filter out stuff you shouldn't have to deal with, such as spam, content you've seen before, or content you've blocked. Next, we use predictive models to anticipate what you may or may not like. Finally, we sort content according to those predictions, and to ensure a level of diversity of content in your feeds." Content signals, verbatim: **"user upvotes and downvotes, the community where the content was posted, the comment history on the post, the post type, post age, and post flairs."** Plus your activity, account age and location.

**Surface change (T1, corrects a common inversion).** Reddit's own changelog, **2 April 2026**: "the final steps to deprecate r/all are being implemented. All links to r/all will now redirect to the Home feed, following the prior removal of r/all entry points. Trending content remains available via r/popular." old.reddit.com retains access. **r/all was deprecated on modern web and mobile — this is Reddit's own announcement, not an SEO invention.** For logged-out redditors the default feed is r/popular, "as determined by net upvotes."

**What actually predicts success (T3).** Lakkaraju/McAuley/Leskovec, ICWSM 2013 — 132,307 images, 867 communities, 250M ratings, solving causality by studying identical images resubmitted with different titles:

- Content + community + timing + resubmission count, **no title at all**: R² = **0.556**
- Adding title language: R² = **0.639**
- **Title language alone: R² = 0.139**

**Which subreddit you post to and what you post dominate; the title is a real but secondary multiplier.** Their in-situ test on 85 image pairs: good-titled posts summed 10,959 upvotes vs 3,438 for bad — but that is a **sum across 85 pairs (~129 vs ~40 per post) posted to two different communities**, so title and subreddit are confounded. The paper says "about three times"; do not quote 3.2× as a single-post result.

Their most useful cultural finding: **an inverted-U on community-specific vocabulary.** Titles too generic for the room fail; titles that over-conform — "too similar to content the community has already seen" — also fail. There is a peak. And novelty is asymmetric: an original title isn't automatically good, but "using a very unoriginal title (high Jaccard sim.) is a strong indication that the submission will do poorly."

**Comments are the survival currency (T3).** The 11-month r/popular audit (1.5M analysed snapshots every 2 min, 10,000 posts, 694 subreddits): **doubling a post's comments gave 91.52% greater odds of remaining in the top 50.** Recent (10-minute) vote velocity affected tenure by 74–161% across model cuts. Average tenure in the top 100: **6.1 hours.** Engagement declines sharply below rank 80. Important nuance: cumulative *Score* carried a large **negative** coefficient (−47.89% for top-50), so state this as "comment activity and recent vote velocity are the strongest positive predictors, while cumulative score is not" — never as "votes don't matter."

**Policy (T1).** Rule 2: "Participate authentically in communities where you have a personal interest, and do not spam or engage in disruptive behaviors (including content manipulation)." Rule 5: "Be authentic." The Spam policy contains **no numeric self-promotion ratio** — only "Post authentic content into communities where you have a personal interest" and "be thoughtful about the frequency of posting." **The 9:1 rule is orphaned, not fabricated:** it was real in the old self-promotion wiki, is gone from sitewide policy, and survives in thousands of individual subreddit rule lists — so it still binds you wherever a sidebar lists it. The Disrupting Communities policy bans "voting services" and "any automation to manipulate vote counts" **by name**.

**AI (T1).** The Spam policy names "Using tools (e.g., bots, generative AI tools) that may break Reddit or facilitate the proliferation of spam" — the ban is on AI used to spam, not AI assistance as such. No sitewide AI-disclosure label. Enforcement is per-subreddit: **4% of subreddits had AI rules; 20% of the top 1% by subscriber count did** (T3, Lloyd/Reagle/Naaman, PACMHCI CSCW264, Nov 2025). Moderators use four unreliable heuristics: content signals, user signals, **deviation from subreddit style norms**, and inaccurate information. Named tells from that paper: "It feels very formal, and it feels very different from the normal kinds of comments" (r/AskHistorians moderator), and AI answers "tend to be very general and hedge more than a real human."

**Format constraints.**

| Constraint | Value | Tier |
|---|---|---|
| Title | Hard cap 300 chars. **4–16 words** — outside that band measurably hurts; inside it, length has no significant effect | T3 |
| Post type | Self (text) posts safest for anything commercial; many subreddits auto-remove link posts or gate on karma/account age. Link posts to a domain you own are the fastest route to removal. | Working guidance + T1 (Rule 2) |
| Flair | Often mandatory; **an explicit ranking signal per Reddit Help**. Unflaired posts are frequently auto-removed before scoring. | T1 |
| Body | 40,000 char cap, not a practical constraint. Short paragraphs, no emoji bullets, no bolded marketing pull-quotes, no CTA block, no signature line. | Working guidance |
| Media | Native uploads autoplay muted, so burn captions — but the media is the artifact and the **title still carries the click**. Do **not** transfer the 9:16 spec from TikTok; Reddit's feed is mixed-aspect with significant desktop traffic. | Working guidance |
| Account | Per-subreddit karma and account-age gates enforced by AutoModerator **before any human or algorithm sees the post**. This is the actual first gate. | Working guidance |

**Scripting rules.**
- **Pick the subreddit before writing anything.** R² = 0.556 without a title vs 0.139 for title alone. Never write one post and fan it to five subreddits.
- Read the top 25 posts of the month and the full rules before drafting. Match the register; do not clone the most-used phrasing.
- Put a real, checkable number or proper noun in the title. "Cut our p99 from 1.8s to 240ms," not "improved performance dramatically."
- Write the title to *open* a conversation, not close one. End on unresolved tension, a contested claim, or a genuine question the room is qualified to answer.
- **Front-load the payload in the title.** Curiosity-gap titles that force a click read as clickbait here and get downvoted rather than opened. (This is the platform where the concreteness optimum sits furthest toward specificity.)
- Never open with a hook formula. "Very formal and very different from normal kinds of comments" is a named moderator detection heuristic.
- **Strip hedging and both-sides padding.** "Hedges more than a real human" is a named heuristic. Commit to a position.
- Lead with the failure, cost, or limitation before the result.
- Disclose affiliation in the first two lines, plainly. Concealed affiliation that gets discovered converts a mild post into a ban.
- Do not post as a first action in a community. Account history is an explicit detection signal.
- **Budget for live comment replies in the first 60–90 minutes** and write the post so replies are easy — leave 2–3 obvious open threads for the author to expand. This is the timing lever, not the posting clock.
- Never buy or solicit upvotes.

---

## 3. The fabrication problem

The validation pass killed a large and specific body of widely-repeated statistics. This section exists so the agent can *refute* them, not merely avoid them — an agent that silently omits a fake number will re-derive it the moment a user asserts it.

### 3.1 The kill list

**TikTok.** Tiered "view pools" and batch-testing cohorts; graduation thresholds ("35% completion + 1.5% engagement to reach 5,000–10,000 viewers"); "70%+ completion to go viral"; "watch time = 40–50% of ranking"; "TikTok counts every loop as a view"; any best-time-to-post table; "burned-in captions beat auto-captions by 18–32% completion." The published architecture is per-viewer probability scoring — **structurally incompatible** with a promotion ladder. Zero hits across the full decoded 2.3MB Transparency Center page for "view pool," "batch test," "graduation," "completion rate."

**Instagram.** "Sends carry 3–5× the weight of likes"; "200 billion Reels plays per day, Zuckerberg, Q3 2025 call"; "10+ reposts in 30 days = removed from recommendations"; "original content confirmed at 40–60% more distribution"; "1.7-second viewer decision window"; "60–70% retention viral threshold."

**YouTube Shorts.** "70%+ VVSA is viral, below 30% dies"; "distribution stops if it doesn't clear a threshold in 30–60 minutes"; the "three-gate seed batch"; "Tubular's 2025 report found under-30% swipe-away gets 4× sustained distribution"; every subscriber-conversion benchmark.

**X.** The "simplified scoring formula" (Likes ×1 + Retweets ×20 + Replies ×13.5 + Profile Clicks ×12 + Link Clicks ×11 + Bookmarks ×10) attributed to "the open-source code under xai-org"; "94% fewer views for link posts"; "30–50% link reach penalty per the open-source code"; "visibility halves every 6 hours"; "first engagement window: 30–60 minutes"; "SimClusters: 85% of OON recommendations"; "threads of 8–12 posts perform 47% better"; "threads get 63% more impressions"; "a quote tweet scores ~25× a like."

**Reddit.** "Video beats text by 78%"; "9AM–12PM = 8× median score"; "50+ upvotes in the first hour = 10× viral potential"; "a post with 50 upvotes in the first hour outranks one with 500 over 12 hours because the algorithm rewards velocity" — this last one is actively false against the only formula we can read, which contains no velocity term at all.

**Cross-cutting.** "High-arousal emotion causes sharing" (failed replication, N=111 and N=160). "Open loops work because of the Zeigarnik effect" (recall ratio 0.99 across 38 publications). "Overproduced content gets less organic engagement" (no controlled study; direct contrary evidence). "Cunningham's Law" as a strategy (an aphorism its namesake disputes).

### 3.2 The five propagation mechanisms

Naming these is what lets the agent *detect* fabrication in material it hasn't seen before.

1. **Number mutation.** If the 70/50/30 VVSA thresholds propagated from one real measurement, the cut points would be fixed. They aren't — the most upstream artifact (an uncited Medium post claiming 3.3B views across 5,400 Shorts) says "less than 60%... between 70 and 90%," not 70/50/30. TikTok's "initial batch" is variously 200–500, 200–300, or ~500 users. **Numbers that drift while gaining precision are being generated, not transmitted.**
2. **Borrowed authority.** conbersa.ai attributes "4× sustained distribution" to "Tubular's 2025 short-form video report," linking only to tubularlabs.com's homepage. No such finding exists. **The structural refutation is decisive: swipe-away rate is a creator-private Studio metric with no public API, so a panel-measurement firm could not compute it even in principle.** Once a fake attribution enters, downstream writers stop looking for a primary source because one appears to already exist.
3. **Broken citation chains.** Dataslayer credits "3–5× the weight of likes" to "Mosseri statements compiled in Buffer's and Later's 2026 algorithm guides." Buffer contains no multiplier and no number. The named upstream does not contain the claim it is credited with.
4. **Wire syndication.** The upvote.net "1,000-post study" — n=1,000 hot r/all posts from a single day, no significance tests, subgroups as small as n=14, sample conditioned on the outcome being measured, published by a company that sells a product Reddit bans by name — was republished identically across usawire, bignewsnetwork, openpr, mexc and iowanewsheadlines. **To an agent counting sources, it now appears on six domains.**
5. **AI summarisation.** Documented repeatedly during validation: search-engine AI summaries restated fabricated claims as settled fact while citing only SEO blogs — "Mosseri confirmed in a Q&A that sends carry 3–5× more weight," "per Mark Zuckerberg on Meta's Q3 2025 call." **The laundering step is no longer blog-to-blog. Summarisers strip the hedges and attach confident executive attributions the underlying sources never made.** This is the mechanism by which every number above will keep re-entering downstream content regardless of how often it is debunked.

Two secondary traps: **tiktok.com/discover/\* URLs are SEO landing pages aggregating user videos** — creator folklore hosted on TikTok's domain. A citation to a tiktok.com URL proves nothing about first-party status. And **TikTok's policy pages serve body text URL-encoded inside a JS payload**, so ordinary fetch-and-render returns an empty page; several fact-checks of these claims likely failed silently for that reason and defaulted to secondary sources.

### 3.3 Three sourcing defects worth carrying (real but misdescribed)

- The **88% "sound is essential"** figure is real and first-party but is **not attributed to Kantar** on the page carrying it — Kantar there supports only a separate 73% sonic-logo finding. No sample size or methodology published anywhere.
- The **"TikTok Algo 101"** formula is authentic and TikTok-acknowledged, but **December 2021 is the NYT's publication date, not a documented authoring date.** Routinely redated to establish false vintage.
- The **Boeker & Urman** factor ordering that circulates ("follow > like > watch time") comes from the paper's abstract, which its own Section 4.6 reverses: "(1) following specific content creators, (2) watching certain videos for a longer period of time, and finally (3) liking specific posts," with the two "separated only marginally." **Anyone citing the abstract ordering is quoting a paper that concludes the opposite in its body.** The "25% completion threshold" is also mischaracterised — 25% was the lowest setting in a 25%–400% experimental range, not a discovered threshold.

### 3.4 The rule the agent follows

Encode this verbatim in `craft/evidence-standards.md` and reference it from every platform file:

> **The publisher test.** Before encoding any statistic: *if only the platform could know this, and the platform has not published it, then nobody knows it.* Swipe-away distributions, ranking weights, completion thresholds, view-pool sizes, and reach multipliers are all creator-private or internal. A precise number for any of them, from any source, is invented.
>
> **The precision tell.** Platforms publish qualitatively by design — "a strong indicator... would receive greater weight than a weak indicator," "slightly more important," "primarily post unoriginal content." **When a source names a multiplier or threshold the platform has never published, the precision itself is the warning sign.** Every fabricated number in this corpus is more precise than any real one.
>
> **Never treat a search summary or an AI answer as a source.** Open the primary document. Platform policy pages may require decoding a JS payload; a page that renders empty is not a page that says nothing.
>
> **Domain ≠ first-party.** `tiktok.com/discover/*` is user content. A press-release wire is not corroboration. A vendor selling the thing the statistic recommends is not a researcher.
>
> **Cite the tier inline, or don't state the number.** Any claim in a platform file without a tier tag and a `last-verified` date is treated as unverified and must not drive a scripting decision.
>
> **Prefer mechanisms to magnitudes.** Mechanisms survived a full rewrite of X's stack across three years and two languages. Magnitudes rotted within months when they were published at all. "Earn the finish" over "70% completion." "Sends unlock stranger reach" over "sends are worth 3× a like."

One inverse warning, because it bit the validation pass: **skepticism aimed at the wrong target produces a confident error just as fast as credulity does.** "Reddit deprecated r/all in April 2026" was flagged as an SEO fabrication. It is Reddit's own changelog. The tell should have been that all the coverage pointed at a single support.reddithelp.com article rather than at each other.

---

## 4. Recommended agent architecture

### 4.1 Primitive ownership

| Concern | Primitive | Why not the alternative |
|---|---|---|
| Never-violate constraints (no invented stats, no engagement bait, no publishing without approval) | **`~/.claude/rules/content.md`** (≤20 lines) | Must apply on every turn including ones that don't invoke the skill. But keep it tiny — a bloated CLAUDE.md causes Claude to ignore the rules inside it. |
| Craft, voice, platform rules, the pipeline | **One router skill + `references/`** | Progressive disclosure: only the description is resident; the body loads on invoke; reference files load only when Read. A 3,000-line corpus costs nothing until used. |
| Voice corpus and AI-tell tables that subagents need | **Separate skills with `user-invocable: false`** | Preloadable via a subagent's `skills:` field. **Cannot use `disable-model-invocation: true`** — preloading draws from the same pool Claude can invoke. `user-invocable: false` hides them from the `/` menu without blocking preload. |
| Unbiased critique | **Subagents** | Context isolation is the entire point. A critic that watched you write the draft is not a critic. |
| Enforcement of anything mechanical | **Hooks** | "An instruction like 'never do X' in CLAUDE.md or a skill is a request, not a guarantee." **Every quantitative gate in all three reference repos is currently advisory. This is the biggest single gap in the prior art.** |
| The command you type | **A skill with `disable-model-invocation: true`** | Slash commands merged into skills; write new ones as skills. `disable-model-invocation` removes it from the listing budget entirely (zero context cost) since you always invoke it explicitly. |
| Read-heavy research with small output | **Backgrounded subagents** | Trend scouting and competitor scans flood the main context with material you'll never reference again. |
| Register of Claude talking *to you* | **Output style** (optional) | Alive, not deprecated (`/output-style` the command was removed v2.1.91; use `/config` or the `outputStyle` setting). **But it does not reach subagents**, so it is the wrong home for the voice of the artifact. |

**Why not put voice in an output style.** It applies every turn and changes the system prompt, which sounds ideal — but subagents don't receive it, and your voice critic is a subagent. Voice must live where it can be preloaded.

**Why not one giant SKILL.md.** Three reasons, one of which is decisive: (1) the rendered body enters the conversation as a single message and **stays for the rest of the session** — every line is a recurring per-turn cost; (2) docs cap it at 500 lines; (3) **after auto-compaction, only the first 5,000 tokens of each invoked skill are re-attached, sharing a 25,000-token budget filled most-recent-first.** A 3,000-line voice corpus in SKILL.md gets *truncated* post-compaction. The same material in `references/` gets *re-read on demand* and survives. This alone settles the architecture.

### 4.2 File tree

```text
~/.claude/rules/content.md                     # ≤20 lines, never-violate

<project>/.claude/
├── settings.json                              # hooks
├── skills/
│   ├── content-scripting/                     # THE ROUTER
│   │   ├── SKILL.md                           # ~150 lines: routing + workflow only
│   │   ├── craft/                             # DURABLE — years. No dates.
│   │   │   ├── evidence-standards.md          # §3.4 rule + the kill list
│   │   │   ├── attention.md                   # reference-point → gap; Loewenstein's 5 triggers
│   │   │   ├── curiosity-debt.md              # payment schedule; disappointment default
│   │   │   ├── hooks.md                       # architectures, not templates
│   │   │   ├── structure.md                   # body/closer patterns; concreteness band
│   │   │   ├── share-psychology.md             # the named-recipient test; practical value
│   │   │   ├── refinement-protocol.md         # the five passes (§5)
│   │   │   └── ai-tells.md                    # SUBSTITUTION table, not a ban list
│   │   ├── voice/                             # YOURS — hand-written only
│   │   │   ├── corpus.md                      # 15–30 of your own pieces, verbatim, indexed
│   │   │   ├── anti-corpus.md                 # same content in generic register, paired
│   │   │   ├── rules.md                       # only greppable rules
│   │   │   └── taste.md                       # what you post about / never post about
│   │   ├── platforms/                         # FAST-ROTTING — dated, templated
│   │   │   ├── _template.md
│   │   │   ├── tiktok.md
│   │   │   ├── reels.md
│   │   │   ├── shorts.md
│   │   │   ├── x.md
│   │   │   └── reddit.md
│   │   ├── data/                              # MACHINE-WRITTEN — never hand-edited
│   │   │   ├── posts.json                     # tagged drafts + engagement snapshots
│   │   │   └── learned-rules.md               # append-only reflection output
│   │   └── scripts/
│   │       ├── register_lint.py               # variance + banned-phrase report
│   │       ├── platform_check.py              # char/length/safe-zone/placeholder gate
│   │       ├── log_post.py                    # append draft + pattern tags
│   │       ├── perf_digest.py                 # aggregate by tag → markdown
│   │       └── staleness.py                   # list platform files past last-verified + 90d
│   ├── voice-corpus/SKILL.md                  # user-invocable: false — preloadable
│   ├── ai-tells/SKILL.md                      # user-invocable: false — preloadable
│   ├── script/SKILL.md                        # disable-model-invocation: true — the command
│   └── post-mortem/SKILL.md                   # context: fork, agent: perf-analyst
└── agents/
    ├── voice-critic.md                        # skills: [voice-corpus, ai-tells]; Read/Grep/Glob
    ├── platform-auditor.md                    # skills: [platform-rules]; mechanical compliance
    ├── fact-checker.md                        # WebSearch/WebFetch; background: true
    ├── trend-scout.md                         # model: haiku; background: true
    └── perf-analyst.md                        # memory: project
```

**Project-scoped, not `~/.claude/skills/`.** Two reasons. Skills precedence is **enterprise > personal > project**, so a personal skill would shadow the project one — surprising, and wrong for a corpus you'll version. More decisively: **Cowork/cloud sessions and scheduled routines do not read `~/.claude/skills/`.** If the monthly performance analysis ever runs on a schedule, the skill must be repo-committed or plugin-shipped.

### 4.3 Router SKILL.md frontmatter

````yaml
---
name: content-scripting
description: Write and refine social posts and video scripts in the user's voice for TikTok, Instagram Reels, YouTube Shorts, X, and Reddit. Use when drafting, rewriting, critiquing, or adapting content for any of these platforms.
when_to_use: "write a post", "script this", "make a Reel about", "draft a thread", "rewrite for LinkedIn", "adapt this for TikTok", "does this sound like me", "punch up this hook"
argument-hint: [platform] [topic-or-file]
arguments: [platform, topic]
allowed-tools: Read Grep Glob Bash(python3 ${CLAUDE_SKILL_DIR}/scripts/*)
paths: ["drafts/**", "content/**", "scripts/**"]
model: opus
---

Write for **$platform** about **$topic**.

## What has been working (last 30d)
```!
python3 ${CLAUDE_SKILL_DIR}/scripts/perf_digest.py --days 30 --top 5
```

## Load order — do not skip, do not substitute memory for a file read
1. `craft/evidence-standards.md` — **always, first.** Governs every claim you make or repeat.
2. `voice/corpus.md` and `voice/taste.md` — always.
3. `platforms/$platform.md` — always. Its Mechanics section is authoritative over everything else, including this file.
4. `data/learned-rules.md` — always. Overrides `voice/rules.md` on conflict.
5. `craft/attention.md` + `craft/hooks.md` — when generating or fixing an opener.
6. `craft/curiosity-debt.md` — for anything over ~20 seconds or over ~150 words.
7. `craft/refinement-protocol.md` — before showing me anything public-facing.
8. `craft/share-psychology.md` — when the goal is stranger reach rather than follower depth.

## Standing instructions
- **Never state a character limit, aspect ratio, safe zone, or ranking fact from memory.** Read it from `platforms/$platform.md`. If that file's `last-verified` is over 90 days old, say so before proceeding.
- **Never state a ranking statistic without its tier tag.** If you cannot name the tier, do not state the number.
- Draft, then delegate to the `voice-critic` subagent before showing me anything.
- For anything with mechanical constraints, delegate to `platform-auditor` after the voice pass.
- Tag every draft with hook pattern, structure variant, and the corpus examples retrieved, then log it with `scripts/log_post.py`. **Untagged drafts break the feedback loop and make the performance data unanswerable.**
- Never publish, schedule, or post. Output goes to `drafts/`. Publishing is a separate, explicitly-approved action.
````

Notes on specific fields:

- **`description` + `when_to_use` share a 1,536-char truncation cap** in the listing. Put the key use case first. Do not stuff 20 trigger phrases into `description` the way `create-viral-content` does — that's what `when_to_use` is for.
- **`${CLAUDE_SKILL_DIR}` is substituted in both the body and `allowed-tools`**, so bundled scripts run without a permission prompt. `create-viral-content` hardcodes absolute paths; that's the bug this field exists to fix.
- **`` !`cmd` `` runs before Claude sees the content and substitutes once** — injected output is not re-scanned, so a script cannot emit another placeholder. The `perf_digest.py` injection therefore has to emit final markdown.
- **`paths:`** gates auto-activation to when you're actually working in draft material.
- **Claude Code does not re-read the skill file on later turns.** Write standing instructions, not one-time steps. The "Standing instructions" heading is doing real work.

### 4.4 Subagent design

```yaml
---
name: voice-critic
description: Score a draft against the user's voice corpus and flag regression to generic LLM register. Cites violations; never rewrites.
tools: Read, Grep, Glob, Bash
model: opus
memory: project
skills:
  - voice-corpus
  - ai-tells
---

You are a hostile voice editor. You do not rewrite — you score and cite.

Run `python3 <skill-dir>/scripts/register_lint.py <draft>` first and read its
numeric report before forming any opinion. Variance statistics beat intuition.

For each violation: quote the offending span, name the rule it breaks, and give
the substitution from the AI-tells table. If the substitution table has no entry,
say so rather than inventing one.

Flag ONLY violations that affect voice or register. Do not manufacture findings
to appear thorough. An empty report is a valid result.

Then answer one question in one sentence: could this draft be topic-swapped with
light editing and still read the same? If yes, that is the finding — name the
specific missing particular (a number, a name, a first-hand observation, a stake).
```

**Why read-only-ish tools.** `Read, Grep, Glob` means it scores instead of quietly rewriting, which preserves the separation between critique and authorship. `Bash` is included solely for the linter; if that feels loose, pre-approve the exact script path instead.

**Why `memory: project`.** Persists at `.claude/agent-memory/voice-critic/`, first 200 lines or 25KB of `MEMORY.md` injected. The critic accumulates a record of *your* recurring failure modes across sessions — which is exactly the thing a fresh-context critic otherwise loses.

**Why `skills:` rather than letting it discover them.** Preloading loads full skill content at startup. A critic that has to decide whether to read the corpus will sometimes not. Constraint to remember: **preloaded skills cannot have `disable-model-invocation: true`.**

**What never reaches a subagent:** your output style, the main conversation's auto-memory, your conversation history, skills you already invoked. It *does* get every level of the CLAUDE.md hierarchy (except built-in Explore/Plan).

`platform-auditor` is the same shape against `platforms/*.md` — mechanical compliance only: length, aspect, safe zones, disclosure toggles, eligibility gates, banned patterns. Split from `voice-critic` because they have different failure modes and different reference material, and because a single "review this" agent reliably under-weights whichever concern it mentions second.

### 4.5 Hooks — the enforcement layer

```jsonc
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "python3 $CLAUDE_PROJECT_DIR/.claude/skills/content-scripting/scripts/register_lint.py \"$CLAUDE_TOOL_FILE_PATH\""
      }]
    }],
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "python3 $CLAUDE_PROJECT_DIR/.claude/skills/content-scripting/scripts/platform_check.py \"$CLAUDE_TOOL_FILE_PATH\""
      }]
    }]
  }
}
```

- **`PostToolUse` on `Write|Edit`** runs the register linter and returns hits as text Claude reads. Advisory, but *guaranteed to fire* — which is strictly better than a rule the model may skip.
- **`PreToolUse` with exit code 2** hard-blocks. Reserve it for the unarguable: over the character limit for the declared platform, an unresolved `[PLACEHOLDER]`, a banned phrase from the zero-tolerance list, a statistic with no tier tag, a claim from §3.1's kill list.
- **If a publishing MCP is ever added, the `PreToolUse` gate on `mcp__<poster>__*` is non-negotiable** — length, placeholder, disclosure-toggle, and an explicit approval flag. Given the calendar-consent precedent in this user's global rules, publishing without explicit per-item confirmation should be structurally impossible, not merely discouraged.

**Hooks cost zero context unless they return output.**

### 4.6 Fast-rotting vs durable: the split rule

Sort by **half-life, not topic.**

| Half-life | Content | Home |
|---|---|---|
| Years | Curiosity gaps, reference-point requirement, curiosity debt, specificity beats abstraction, adversarial passes, sentence-length variance, substitute-don't-ban, the evidence standard | `craft/` — no dates, edited rarely, safe to preload |
| ~1 year | Per-platform *culture*: subreddit norms, Reels' relational consumption, X's tech-audience register, Shorts' lean-back velocity | `platforms/<name>.md`, Culture section |
| Weeks–months | Character limits, aspect ratios, safe zones, API tool names and their bugs, whether hashtags help, eligibility gate wording, monetisation thresholds, revenue splits, current benchmarks | `platforms/<name>.md`, Mechanics section, **dated** |

`platforms/_template.md` forces identical section order everywhere, so a platform update is a five-line diff rather than a rewrite:

```markdown
---
platform: tiktok
last-verified: 2026-07-31
verified-by: TikTok Transparency Center + Newsroom, decoded JS payload
---

# TikTok

## Mechanics  <!-- ROTS FAST — re-verify quarterly -->
- 9:16, 1080x1920, full-bleed. [T1]
- Creator Rewards: original video **over 60s**. [T1, newsroom.tiktok.com, 2024-03-18]
- FYF-ineligible: reused/unoriginal w/o creative edits; someone else's watermark;
  GIF-only clips; like-for-like promises; false incentives; misleading view claims;
  undisclosed commercial content. [T1, fyf-standards]
- Safe zones: right ~15%, bottom ~20%, top tab strip. [WORKING GUIDANCE — not
  verified against TikTok's ad safe-zone template. Verify before shipping.]
- Length for reach: NO published min or max, NO preferred duration. [T1, absence verified]

## Culture  <!-- SEMI-DURABLE -->
- Sound-on, full-screen, no thumbnail, no title. Legible in motion or not at all.
- Rewards "real process and people over curated perfection." [T2, TikTok Next 2026]

## Scripting rules
[...]

## Degradation order  <!-- when constraints bite -->
1. Cut connective tissue  2. Cut the second example  3. Merge two micro-payoffs
Never cut: frame-1 state, the spoken search query, the loop seam.

## Refuted — do not restate, and correct the user if they assert these
- Tiered view pools / batch testing / graduation thresholds — no first-party source;
  architecture is per-viewer probability scoring. [see craft/evidence-standards.md]
- "70% completion to go viral", "watch time = 40-50% of ranking" — invented.
- Any best-time-to-post table — vendor content.
- "Every loop counts as a view" — no first-party confirmation.
```

Seven rules that make this hold:

1. **No platform mechanics in SKILL.md.** The body routes; it never states a limit. `create-viral-content` violates this and now needs a body edit whenever X changes a number.
2. **`last-verified` on every platform file**, checked by `staleness.py`. Files past 90 days get flagged before the agent uses them.
3. **One template, so files stay diffable.**
4. **Cite the tier and source inline on every fast-rotting claim.**
5. **Never merge craft into a platform file.** The moment "curiosity gaps work" lives inside `tiktok.md`, replacing `tiktok.md` costs you the craft.
6. **Machine-written and hand-written never share a file.** `data/learned-rules.md` (appended by reflection) stays separate from `voice/rules.md` (yours), or you can never safely regenerate either.
7. **Every platform file carries a "Refuted" section.** Silent omission is not enough — the agent must be able to push back when the user asserts a fabrication.

### 4.7 Voice encoding

Four separable dials, adapted from langchain's structure — which is the best prior art here specifically because each constant has a doc comment stating what changing it does:

- **`voice/corpus.md`** — 15–30 of *your own* pieces, verbatim, delimited and indexed (`<example index="3">`), each annotated with what it did and why it worked. **Never paraphrase into principles; the paraphrase is where the voice dies.** Frame them as "pieces that performed," not "pieces I like" — the model treats performance-framed examples as evidence rather than taste.
- **`voice/anti-corpus.md`** — the *same content* in generic-LLM register, paired. The contrast does more work than either alone.
- **`voice/rules.md`** — only rules you can grep. "No sentence over 28 words." "Max one em-dash per 500 words." "Never open with a gerund." If you can't write a regex for it, it belongs in the corpus.
- **`voice/taste.md`** — what you post about, what you'd never post about, whose takes you'd amplify. Prevents on-voice pieces about the wrong things.

**The maintenance rule langchain got right and everyone else gets wrong:** structure rules and few-shot examples must be edited *together* or they fight. If you change the required structure, you change the examples in the same commit.

**Register regression is a distributional failure**, not a lexical one — the draft satisfies every rule and still reads like an LLM. So `register_lint.py` measures **variance**: sentence-length stdev, paragraph-length stdev, opener-bigram diversity, em-dash and colon rate, and a topic-swap heuristic (proper nouns per 100 words, numerals per 100 words). `create-viral-content` is the only prior art that names uniform sentence length as a tell, and it's right — it's the strongest signal and the easiest to script.

### 4.8 Feedback loop

Two designs, complementary, and **neither prior-art repo does the thing that makes them work.**

- **Reflection from your edits** (langchain's graph): compare `{ORIGINAL}` vs `{EDITED}` vs `{USER_RESPONSE}`, ask whether the delta generalises, append to `data/learned-rules.md`. Keep langchain's guardrails verbatim — *"Do not infer or assume rules beyond what's explicitly stated. Do not add rules based on implicit feedback. Do not overgeneralize."* and *"You should not be generating a rule which is specific to this post."* Without those clamps a reflection loop fills with noise inside a week.
- **Performance from published results** (`create-viral-content`'s loop): `posts.json` keyed on pattern, engagement snapshots, monthly top-20% vs bottom-20% comparison.

**The missing piece in both: tag every generated draft with the patterns it used** — hook pattern, structure variant, curiosity-debt schedule, corpus examples retrieved, platform, tier of any claim made. Without tags the performance data tells you *that* a post worked and never *why*, which is why most content feedback loops produce nothing actionable.

**Platform-specific metric discipline for the log**, because the wrong denominator makes the whole loop lie:

| Platform | Log this | Never log this |
|---|---|---|
| TikTok | Retention rate, Watched-full-video rate, Average watch time (from TikTok Studio) | External benchmarks |
| Reels | Average watch time, **likes per reach**, **sends per reach** | Raw counts; Trial Reel reach compared to normal reels |
| Shorts | **Engaged views**, Viewed-vs-Swiped-Away, avg % viewed | Raw *Views* (loop-inflated since 31 Mar 2025) |
| X | Replies-that-you-replied-to, dwell proxies, DM shares | Anything derived from the 2023 weight table |
| Reddit | Comments at 1h, tenure, mod-removal events | Vote velocity as a strategy target |

---

## 5. The scripting pipeline

Eight passes. Each has one job, one input, and one output. The five adversarial personas are `create-viral-content`'s and they're good — five different question-sets beat one "make it better" pass because each persona has a different failure mode in view.

**Two tiers**, so the agent doesn't burn eight passes on a reply: **Full** (passes 1–8) for anything public-facing and produced; **Quick** (1, 2, 3, 6a, 8) for replies, comments, and low-stakes posts.

---

### Pass 1 — Intake

**Job:** establish the four things that determine everything downstream, and refuse to proceed without them.

1. **Platform and surface.** Not "TikTok" but "TikTok For You" vs "TikTok Search" vs "TikTok Local" — they have different dominant factors and TikTok publishes them separately. Not "Instagram" but "Reel for strangers" vs "carousel for followers."
2. **Goal, expressed as a modelled action.** Reach strangers → sends (Reels), search retrieval (TikTok), OON reply promotion (X). Deepen followers → likes, saves, comments. Route to long-form → the Related Video handoff. **If the goal cannot be expressed as an action the platform separately models, the goal is wrong.**
3. **The particular.** At least one thing that could only come from this user: a number, a name, a first-hand observation, a stake. **Hard gate.** Without it, the piece will be generic regardless of craft, and genericness is what platforms actually police and audiences actually detect. If the user has no particular, the pass returns "no particular — what actually happened?" rather than a draft.
4. **Monetisation and commercial status.** Changes hard constraints: >60s for TikTok Creator Rewards; disclosure toggle for commercial content; affiliation disclosure in the first two lines on Reddit.

Reads: `platforms/$platform.md`, `voice/taste.md`.

---

### Pass 2 — Angle selection

**Job:** choose *what claim this makes*, before any wording exists.

Generate 3–5 angles. Score each against:

- **Does the target audience have a foothold?** (Loewenstein's reference-point requirement — a gap opened where the viewer has no purchase produces indifference, not curiosity.)
- **Which of Loewenstein's five triggers does it use?** Named explicitly. Prefer #2 (anticipated but unknown resolution) or #3 (expectation violation); #2 upgrades to a force multiplier if the script can get the viewer to *predict*.
- **Does it survive the send test?** "This is for the person who ___." Mandatory for Reels, strong for X DM-shares, ignorable for Shorts.
- **Reddit only:** which subreddit? Community choice dominates title craft by a factor of four in explained variance. Pick the room first, and read its top 25 of the month.
- **Practical value and interest are first-class**, not consolation prizes. The field data puts them level with awe and above anxiety.
- **Is there a searchable phrasing?** On TikTok this is a paid metric with a content-gap tool. On Reddit and X it is retrieval that survives any ranking change.

Output: one selected angle plus a one-line statement of *the gap it opens and the trigger it uses*, carried forward as a constraint.

Reads: `craft/attention.md`, `craft/share-psychology.md`.

---

### Pass 3 — Hook generation

**Job:** produce the opening beat as a **reference-point-then-gap structure**, not a template slot.

Generate 5–8 candidates. Every candidate must contain both components, and the pass names them separately:

- **Foothold beat** — what establishes the domain so the gap can be felt. On TikTok this is the state visible in frame 1, not a sentence. On Reddit it's the subreddit plus a proper noun in the title. On X it's the claim itself, since the tech audience arrives with the foothold.
- **Gap beat** — the expectation violation, question, or unresolved state.

Platform-specific first-beat constraints, read from the platform file rather than remembered:

| Platform | The first beat must |
|---|---|
| TikTok | Show the situation already in progress. Skip is a modelled negative — throat-clearing trains it. |
| Reels | Survive a 2-second skip. Most concrete visual or sharpest line. |
| Shorts | Read as a complete proposition on a **muted, thumbnail-sized frame**. One of YouTube's three named devices. |
| X | Lead with the claim in the first ~10 words. |
| Reddit | Be the title. Front-load the payload — curiosity-gap titles read as clickbait and get downvoted rather than opened. |

**Concreteness check.** Score each candidate on the specificity band. Half of real headlines are already past the point where more detail helps, and the failure is asymmetric (−9.9% above the optimum vs +5.5% below it). A hook that is too specific to leave anything unresolved is as broken as one too vague to signal a domain — and the second failure is much more commonly diagnosed than the first.

**Rejection filter:** if a candidate would still make sense with "Hey guys" in front of it, it's not a hook. If it's meta-commentary about what the piece will contain, it spends the reference point without opening a gap.

Reads: `craft/hooks.md`, `craft/attention.md`, `platforms/$platform.md`.

---

### Pass 4 — Script body

**Job:** write the full piece with an explicit **curiosity-debt schedule**.

Before writing, lay out the schedule: at what timestamp or paragraph does each opened gap get paid, and what new gap does that payment open? The rule from Loewenstein: **satisfaction's default outcome is disappointment**, so never let outstanding debt exceed what's recently been paid.

Platform-specific structure, which is where the platforms genuinely diverge:

| Platform | Payoff placement | Why |
|---|---|---|
| TikTok, 60–90s | **3–4 chained micro-payoffs**, each ~20s block re-earning the next | Monetisation requires >60s; retention requires the piece never coasts |
| Reels, 8–15s | **Front-load the payoff**, let the rest add texture | Reshare and rewatch both require the viewer to *already* feel rewarded. A punchline-at-the-end Reel is structurally wrong. |
| Shorts | **Open loop in sentence 1, closed in the last** | avg. % viewed is a named ranking input; the viewer needs a stated reason to reach the end |
| X | Claim first, evidence second, **deliberate hole third** | The hole is what pulls a knowledgeable reader into a reply |
| Reddit | Failure/cost/limitation before the result; 2–3 obvious open threads for the author to expand | Comments drive tenure; disclosed failure pre-empts the ad reflex |

Also in this pass:

- **The comment/reply hook.** Exactly one, deliberate: an omission, a contestable ranking, a visible mistake left in, or a genuine open question. **One, not three.** Stacked hooks read as bait, and bait is an eligibility problem on TikTok, not a taste problem.
- **The sound-off layer.** For all four video platforms, write the burned-in text so it carries full meaning independently, then write audio that adds a *distinct* reward — because "reuse this audio" (Reels) and "tap the soundtrack" (TikTok) are separately modelled actions.
- **The close.** Loop seam or hard stop for TikTok. CTA in the final 5 seconds with verbal *and* visual cue for Shorts. For Reels, the send prompt after the payoff, spoken as well as on-screen. Never a trailing "anyway, thanks for watching" — dead tails are measured.
- **X threads:** post 1 must be standalone-viral. `DedupConversationFilter` keeps one candidate per conversation, so a 12-post thread gets one shot, not twelve.

Reads: `craft/structure.md`, `craft/curiosity-debt.md`, `platforms/$platform.md`, `voice/corpus.md`.

---

### Pass 5 — Adversarial refinement (five personas)

Runs in `voice-critic` and `platform-auditor` subagents. Each persona has a voice, questions, and — the part that makes it executable rather than decorative — **actions**.

| Persona | Question | Action |
|---|---|---|
| **Skeptic** | "Why should I care, and why should I believe you?" | Every abstract claim gets a concrete example or gets cut. Every assertion about a result gets replaced by a demonstration of it. |
| **Expert** | "What would I nitpick? What's the caveat you skipped?" | Either fix the gap or **make it the deliberate comment hook.** Do not leave it accidental. |
| **Scroller** | "Would I stop? Would I still be here at second 5?" | Read only frame 1 / line 1 / the title. If it doesn't stop you, return to pass 3. |
| **Competitor** | "How is this different from the ten similar pieces already in this feed?" | Name the differentiator explicitly. If there isn't one, the *angle* is wrong — return to pass 2, not to line editing. |
| **Editor** | "What can I cut?" | Cut 15% of connective tissue. Verify the curiosity-debt schedule still balances after cutting. |

The Competitor pass has a platform-mechanical justification most people miss: TikTok's similarity check swaps out too-similar candidates, Instagram's early-stage ranker judges topical similarity before quality is ever evaluated, and Reddit's Home feed sorts for diversity. **Being indistinguishable from adjacent content is a ranking problem, not just a taste problem.**

**Quick tier** runs Scroller and Editor only.

---

### Pass 6 — Platform variants

**6a. Mechanical compliance** (`platform-auditor` + `platform_check.py`, hook-enforced). Aspect, resolution, length, safe zones, character counts with URL and emoji weighting, disclosure toggles, flair, watermark check, majority-text check, muted-audio check, originality check against `posts.json`. **A declared degradation order** — from the platform file — governs what gets cut when a limit bites, so the cut is never improvised.

**6b. Genuine re-scripting, not reformatting.** The same idea for TikTok and for Reels is two different scripts, because payoff placement is inverted between them. The same idea for X and Reddit is two different pieces, because one wants a claim with a hole and the other wants a disclosed failure with open threads. **The pass explicitly refuses to letterbox, crop, or reuse a cut across platforms** — Instagram names re-uploads and watermarks as demotions, TikTok names reused content as FYF-ineligible, and Reddit's evidence says a recycled title is the strongest single predictor of failure.

**6c. Caption / title / description.** TikTok: the spoken search query, plus a small number of genuinely topical hashtags. Reels: descriptive keyword-bearing prose, **no hashtags**. Shorts: Related Video link set in Studio, not a description link. X: link in the body. Reddit: 4–16 words, sentence case, a checkable number or proper noun, flair set.

---

### Pass 7 — AI-tell scrub

**Job:** kill genericness first, vocabulary second. The ordering matters — vocabulary filters address the smallest part of the risk.

1. **Run `register_lint.py`.** Numeric report: sentence-length stdev, paragraph-length stdev, opener-bigram diversity, em-dash rate, colon rate, proper nouns per 100 words, numerals per 100 words. **Variance collapse is the strongest measurable tell and the only one that's scriptable.**
2. **Substitute, don't ban.** From `craft/ai-tells.md`, structured as `AI Tell | Human Alternative`. *Leverage → use. Utilize → use. Synergy → [delete the word].* A ban leaves the model stranded; a substitution tells it what to write instead. Load the measured excess-vocabulary list (delves, underscores, showcasing, pivotal, intricate, realm, comprehensive, crucial, notably, particularly) — but treat the *unmeasured* tells (rule-of-three lists, "not just X but Y," em-dash counts) as heuristics with a light touch, since no cross-model evidence supports them and they're also normal features of good journalism.
3. **The topic-swap test — the load-bearing one.** *Could this be topic-swapped with light editing and read the same?* If yes, it fails, regardless of word choice. Name the specific missing particular. This is the test that matches what platforms police (YouTube's "generic or unoriginal templates," Google's "no matter how it's created," TikTok's "minimally edited") and what audiences actually detect.
4. **Register-fit, not roughness.** Do not add disfluency, hedging, or unpolished syntax to sound human — none of those are supported and hedging is a *named* Reddit moderator detection heuristic. Check register against `voice/corpus.md` instead. Reddit adds one more: check for deviation from *that subreddit's* style norms, which is a distinct heuristic from generic-LLM detection.

---

### Pass 8 — Tag and log

**Job:** make the piece answerable later.

`log_post.py` writes to `posts.json`: platform, surface, goal action, angle, trigger used, hook pattern, structure variant, curiosity-debt schedule, corpus examples retrieved, particular used, commercial status, and the platform file's `last-verified` at time of writing. Engagement snapshots get appended later at 1h/24h/7d/30d in **the platform-correct metric** from §4.8.

**Untagged drafts break the loop.** Without tags, performance data answers *whether* and never *why*, which is the failure mode of every content feedback system in the prior art.

---

## 6. Open questions for the user

These materially change the build and research cannot answer them.

**1. Niche and subject matter.** Everything above is platform-general. The foothold requirement in pass 3 cannot be operationalised without knowing what domain your audience already has purchase on. It also determines whether the TikTok content-gap tool is worth wiring in, whether X's `low_blast_radius` reply strategy is available (which large accounts are in your space?), and which subreddits exist at all. **What is the subject, and who specifically is the reader who already knows enough to feel the gap?**

**2. Voice corpus source material.** `voice/corpus.md` needs **15–30 pieces you actually wrote**, verbatim, with what each did. This is the highest-effort and highest-leverage input in the whole build. Three sub-questions: (a) Do 15–30 pieces exist yet, or is this a cold start? (b) If cold, do we bootstrap from adjacent writing — emails, Slack, docs, code review comments — and accept that the register won't be social-native? (c) Do you have performance data on any of them, or are these chosen by taste? The langchain framing of "posts that have done well" only works if performance is known; otherwise say so, so the model treats them as taste rather than evidence.

**3. Which platforms are actually in scope.** Five is a lot of surface area, and the per-platform files are the fast-rotting part that needs quarterly re-verification. Realistically: which two or three are you actually producing for? Reels and TikTok look similar and have **inverted payoff placement**, so treating them as one saves nothing. Reddit is a completely different discipline — text-first, community-gated, and it requires you to have account history in the target subreddits *before* the agent is useful. Do you?

**4. On camera or not.** Determines whether the video platforms are in scope at all in a meaningful way. TikTok's "real process and people" and the demonstrate-don't-claim rule assume a person or a visible artifact. If you're not on camera, what *is* on screen — screen recordings, physical work, artifacts, motion graphics? The safe-zone and burned-in-text rules change substantially between talking-head and screen-capture formats.

**5. Cadence and volume.** Two things depend on it. **Author diversity decay on X** means a burst cannibalises itself, so daily-vs-weekly changes what the agent should even offer to produce. And **Instagram's rolling 30-day originality window** means a stretch of reposts costs recommendation eligibility account-wide — so if the plan involves repurposing, the cadence determines whether that's survivable. Also: is the intent a scheduled rhythm, or opportunistic when you have something to say? The second is more defensible against the genericness gate, because a schedule creates pressure to publish with no particular.

**6. Performance data feedback — will it actually happen?** The tagging in pass 8 costs real effort and pays nothing unless engagement snapshots get logged at 1h/24h/7d/30d. Three options: (a) **manual entry** — you paste numbers monthly, simplest, and honestly the most likely to survive; (b) **API/MCP ingestion** — more setup, and note the metric traps (Shorts *Engaged views* not Views; Reels *per-reach ratios* not raw counts; TikTok Studio retention rather than any external benchmark); (c) **skip it** — build without the loop, and the agent gets no better over time. **If (c), we should drop `posts.json`, `log_post.py`, `perf_digest.py` and the `perf-analyst` subagent entirely rather than ship dead scaffolding**, and the reflection-from-your-edits loop becomes the only learning mechanism.

**7. Does anything publish, ever?** This spec assumes output lands in `drafts/` and you produce and post manually. If a publishing MCP is in scope later, the `PreToolUse` hard-block gate is mandatory and needs an explicit per-item approval flag — the calendar-consent rule in your global config is the precedent, and content publishing has the same shape of irreversible-external-effect risk.

**8. Multi-persona or single voice?** langchain's `prompts.langchain.ts` pattern — a parallel swappable prompt set behind one interface — exists for supporting multiple voices or a client roster. If everything is your own voice, we skip it and keep the tree flat. If there's ever a second voice, the split has to be designed in from the start, because retrofitting it means restructuring `voice/` and every subagent that preloads it.