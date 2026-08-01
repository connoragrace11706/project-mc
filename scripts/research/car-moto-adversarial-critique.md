# Adversarial critique of the car/moto short-form research corpus

**Headline: the corpus is not safe to ship as a spec.** One of the four reports (the "landscape" report) is built on a measurement error that inverts its central thesis, and that thesis has propagated into the other three. I re-pulled the underlying data with yt-dlp against live channels on 31 Jul 2026. The creator roster is mostly real; the *conclusions drawn from view counts* are mostly wrong.

---

## 1. Creator verification

### 1a. Verified real, handle and scale correct

All confirmed live from channel metadata (`channelMetadataRenderer` + header subscriber string), not aggregators:

carwow 11.1M · Throttle House 3.41M · ChrisFix 11.2M · Engineering Explained 4.22M · Donut 9.32M · Doug DeMuro 5.09M · Hoovie's Garage 1.66M · WhistlinDiesel 10.7M · TheStradman 4.55M · The Straight Pipes 1.81M · Vice Grip Garage 2.55M · Mighty Car Mods 3.98M · Adam LZ 3.91M · Rob Dahm 1.28M · Vehicle Virgins 2.51M · savagegeese 868K · Watch Wes Work 446K · South Main Auto 1.0M · Max Wrist 1.1M · ThatDudeinBlue 1.32M · RevZilla 1.55M · Papadakis Racing 638K · FortNine 2.35M · MotoJitsu 610K · CanyonChasers 287K · Itchy Boots 3.37M · Yammie Noob 1.59M · Adobo Moto 533K · MCrider 324K · Motobob 409K · Bikes and Beards 2.81M · DanDanTheFireman 676K · Rainman Ray 664K · The Car Care Nut 1.8M · Chaseontwowheels 1.26M · Home Built By Jeff 229K · Bad Obsession Motorsport 441K · CarEdge 715K · Lucky Lopez 508K · Supercar Blondie 22.1M · Pushing Pistons (YT) 615K · Crash Bandito NL, Bystro 299, Quiz Kingdom, TopCars TV, Chariots, AutoSphere, DYTASTIC, Casual Car Dude, A Girl and Her Bike — all real.

Papadakis is the one number I'll endorse without caveat: "Trick NASCAR remote oil filter adapter explanation" **430K vs 22K for the next-best Short**. The ~20x claim is exactly right.

### 1b. Wrong, misattributed, or unlocatable — do not let these into the spec

| Claim | Reality |
|---|---|
| **`@OGchevydude` = "Chevy Dude's dedicated Shorts channel, 300–2,000 views each, instructive case of FAILURE, do not script Shorts this way"** | 351K subs. **Top Short = 14,000,000 views**, "Be Aware Of This CLASSIC Sales Technique and never answer this question." Then 10M, 6.4M, 2.2M, 2.0M, 1.9M, 1.4M, and 1.3M for "How To Ask A Car Dealer To Lower Their Fees." This is the single load-bearing "instruction fails" case in the corpus and it is a 14M-view instructional dealer-advice channel. |
| **Chevy Dude "~1M followers across platforms"** | Main `@ChevyDude` 514K + Shorts channel 351K. The "~1M cross-platform" figure double-counts the same audience. |
| **"Supercar Blondie Shorts channel ~102K subs, ~85M views"** → basis for "do not propose spinning up a separate Shorts channel" | `@Supercarblondieshorts` resolves to a **128-subscriber fan/impostor channel**. The 102K/85M figures came from third-party ranking sites and I could not locate the channel they describe. The recommendation is unsourced, and is contradicted outright by OGchevydude. |
| **`@Motorfied`** listed in a cohort described as "long-form 291K–3.9M" | `@Motorfied` = **5 subscribers**. Either a hallucinated handle or a total misattribution. |
| **`@TheMotorcycleBrain`** in the same "long-form 291K–3.9M" cohort | 15.5K subscribers. Not in that cohort. |
| **`@PetroHead`** same cohort | 56.6K subscribers. Same problem. |
| **"BRAAAPP-ONLY"** faceless moto crash aggregator | No such channel found. Search resolves to `braaaponline`, an Australian motorcycle manufacturer, 3K–40K views. Drop it. |
| **`@itsjusta6`** (YouTube) | 404. The real handle is **`@itsjusta6official`** (1.43M). The TikTok exists; the report's own "unconfirmed identity" caveat should have blocked the "~1,000 views per Pt.X" claim from being used as evidence. |
| **Dash Cam Owners Australia "163k subscribers"** | **604K**. The 163K figure is from the ~2019 Daily Dot article and was carried forward as current. |
| **Dashcam Lessons "not verified"** | Real, **992K subs**. Under-rated in the corpus, not over-rated. |
| **`@carthrottle` TikTok** | The report already flags this as an Arabic-language impostor. Correct — keep the flag, delete the handle. |

### 1c. Sourcing that must not enter a public spec

- **Grokipedia is cited as the source for YouTube's July 2025 "inauthentic content" policy.** Grokipedia is not a policy source. The "16 channels terminated / 4.7B views" casualty figures are single-sourced from it. Strip both. The policy direction is right; the citation is unusable.
- **Every Reddit quote in the corpus is second-hand.** Three of four reports independently hit a Reddit block. Two delegated to Antigravity and both judged the returned quotes fabricated. The fourth's Reddit material came via Codex and was never opened by the researcher — including the thread IDs (`r/motorcycles/comments/1u58379/`, `r/TikTokCringe/comments/1df5mvs/`) and the "live vs dead brand-tribe triggers" ranking, which is one of the most actionable-looking findings in the whole corpus. **Nothing Reddit-attributed here is evidence.** The honest move is to mark the entire community-sentiment leg as untested hypothesis, not to launder it into scripting rules.

---

## 2. The measurement error that breaks the corpus

The "landscape" report sampled `yt-dlp` against `/shorts` tabs, which returns **recent uploads**, and then treated those ranges as channel performance profiles. It flagged this in its own uncertainty section and then built its entire thesis on it anyway. Here is what a 200–300 item pull sorted by views actually returns:

| Channel | Report's stated range | Actual top Shorts |
|---|---|---|
| Engineering Explained | 65K–1.8M | **41M**, 23M, 23M, 22M, 20M |
| MotoJitsu | 6K–41K | **6.3M**, 5.0M, 2.6M, 2.5M, 2.2M |
| Doug DeMuro | 4.9K–342K | **2.9M**, 1.6M, 1.6M, 1.2M |
| The Straight Pipes | 21K–66K ("low ceiling") | **3.0M**, 1.6M, 1.0M |
| Yammie Noob | 4K–13K ("sponsor collapse") | **1.8M**, 1.3M, 1.2M |
| Adobo Moto | 2.7K–73K | **1.3M**, 1.3M, 835K |
| DanDanTheFireman | 300–36K | **2.8M**, 1.5M, 556K |
| Chase on Two Wheels | 473–5,000 ("has NOT cracked short-form") | **623K**, 390K, 309K |
| Chevy Dude Shorts | 300–2,000 | **14M**, 10M, 6.4M |

Every "instructive failure case" in the corpus is a sampling window, not a finding.

**And the direction of the error is not random — it points the opposite way from the thesis.** The rule as written is: *"Instructional framing ('How to...', 'Mastering...', 'Tips for...') is the single most reliable underperformer in this vertical."* The actual top-performing Shorts on the exact channels cited:

- MotoJitsu: "Quick Lesson About The Clutch" (6.3M), "How To Swerve On A Motorcycle" (2.5M), "How To Do Smaller Circles" (1.1M), "Start Doing This For EVERY Corner" (728K).
- Adobo Moto: top **eight** Shorts are all how-to installs — "how to install a motorcycle chain" (1.3M), "How to do a 600 Mile service on your sport bike" (1.3M).
- The Car Care Nut: "**How To** Make Your Toyota Last Over 300,000 Miles **Part 1**" (1.4M) and "**Part 3**" (1.1M) — instructional *and* serialized, i.e. banned twice over by the corpus's own rules.
- DanDanTheFireman: "How To Ride a Motorcycle in Traffic" (2.8M).
- Chevy Dude Shorts: "How To Ask A Car Dealer To Lower Their Fees" (1.3M).
- ChrisFix, uncontested in the corpus: "How to Remove Locking Lug-Bolts without the Key" (6M).

**Instruction is the dominant winning format in automotive short-form.** The spec currently forbids it. If the scriptwriting agent ships with this rule it will systematically avoid the highest-performing format in the vertical.

What MCrider actually shows (top Short 74K, floor ~9K) is not "instruction fails" — it's that **long SEO title constructions with colon-subtitles fail** ("Mastering Motorcycle Braking_ Achieve Balance and Control in Your Stops," complete with the literal underscore from a repurposing template). MCrider's own best performer is "How much lean angle before you lose traction on your motorcycle?" — instruction phrased as a physical question with an answer. That's the real rule and it's worth keeping. Rewrite as: *short imperative or answerable-question instruction wins; templated multi-clause course-catalogue titles lose.*

Two more corrections that follow from the same data:

- **The "sponsor collapse" finding is dead.** Two separate reports state as measured fact that Yammie Noob's sponsored DJI Shorts run at 3–13K "against 200K–1M organic" and call it "a visible, measurable collapse." His actual top Shorts are 1.8M/1.3M/1.2M and the sampled window was a recent sponsored block. The underlying advice (don't lead with the sponsor) is fine as craft; it is not evidenced here and must not be presented as a measured effect.
- **The "mid-tier moto cohort has not cracked short-form" finding is dead**, and killing it reveals a genuine gap: Chase on Two Wheels' winners are **roll-on acceleration pulls with pure spec titles** — "2025 Yamaha R3 | 40-80 Pull" (623K), "2023 Kawasaki ZX-4RR | 40-80 Pull" (390K). No hook, no jeopardy, no contradiction, no personality. Just a named bike, a stated speed band, and the engine. **None of the four reports names this archetype**, and it is one of the most repeatable formats in moto short-form.

### Misattributed examples

- **`a8bg_ES2jN8`** is quoted as the Rolls-Royce "identify-then-contradict walkaround" and made into a format archetype. The actual video is Throttle House's **"The Beast" — a one-off hot rod with a 27-litre Rolls-Royce Merlin *aero engine*** (3.75M). The "it's a Rolls-Royce, except it's kind of not" line is about an aircraft engine in a bespoke car, not "a little bit of extra bonnet" on a press-fleet Ghost. The archetype generalizes a one-of-one freak into a rule that, applied to normal cars, produces exactly the "treating a base model as exotic" cringe listed in the brief.
- **`kHq_T7BN0_8`** ("Can I UNSEIZE this Suzuki?", FortNine, 2.6M) is used as a Shorts archetype and as the source of the "faceless VO must start speaking by 1.55s" timing rule. **It is 137 seconds long.** It is not a Short. Any first-3-seconds rule derived from it is derived from a long-form opener.
- **`J8HXDSMTC3E`** is used twice with incompatible readings: once as "the wordless meme-caption gag, carwow's ceiling format," once as "the stacked-verdict indicator rating series." Both reports are describing the same 1.44M video. Worse, the joke in it is *BMW drivers don't indicate* — and a different report in the same corpus lists **"BMW drivers never signal" as a DEAD tribal trigger that produces jokes, not discussion.** The spec would be simultaneously holding this up as the ceiling format and banning its premise.

---

## 3. Cringe audit

Rules that will actively produce mocked content:

**1. "Front-load jeopardy, cost, or a wrong done to someone — 'will BURN your car down'."** Applied by an agent to routine maintenance this generates *"your cabin air filter is DESTROYING your engine."* That is the Scotty Kilmer register, and Scotty Kilmer is the most-mocked figure in the vertical. The corpus names ChrisFix as "the trusted counter-example to Scotty Kilmer" and never derives the rule. **Catastrophising ordinary maintenance is the single loudest fraud tell in car content.** The spec needs a hard ceiling: jeopardy is licensed only when the failure mode is real, named, and mechanism-explained.

**2. "Cold-open mid-sentence on a third party's voice stating stakes."** The Rainman Ray example works because it is genuine documentary audio captured incidentally. A *scripted* mid-sentence cold-open is a staged discovery — the exact thing the corpus elsewhere identifies as fatal ("having multiple angles of a scene before it unfolds is a pretty good indicator it's staged"). An agent handed "cold-open mid-sentence" as a rule will fabricate the sentence.

**3. "FIRST-PERSON GRIEVANCE — 'I got scammed by a [named brand] dealership'."** For a creator who was not scammed, this is a manufactured grievance, and the comment section will ask for the RO, the shop name, and the date. This format is only available to someone with the paperwork.

**4. "Use a hard number and a named rival for any comparison"** directly manufactures the **spec-sheet comparison slideshow** that the same corpus bans three rules later. Two rules, one contradiction, and the agent will resolve it toward whichever it read last.

**5. "2,500 loonies less."** FortNine is Canadian. Throttle House is Canadian. carwow and shetalkscars are British. The corpus mixes bonnet/hood, boot/frunk, tyre/tire, £/CAD/USD without ever flagging register. An agent will write "loonies" and "the bonnet" into a US script. **The spec needs a market-register lock as a hard field.**

**6. The 16-term community glossary** ("farkle," "brain bucket," "the ton," "bagger," "clip-ons," "rearsets," "meat crayon," "squid math," "roost," "whiskey throttle"). These are not one register. *Farkle* is GS/ADV. *The ton* is British café-racer. *Brain bucket* is old-school cruiser. *Roost* is dirt. Deploying three of them in one script is the loudest possible tourist signal — worse than using none. And the shaming vocabulary (*squid, organ donor, meat crayon*) is listed in the spec **immediately next to a rule saying never gear-shame**; an agent will use it.

**7. "Steal MotoJitsu's die-cast miniature."** Signature props are recognised instantly. Copying one reads as derivative, not as craft.

**8. "Write a caption that is itself the joke (carwow)."** carwow can post a wordless meme because it is a decade-old UK marketplace with Mat Watson attached. On a cold account, "BMW drivers watching this like 🤷‍♂️" is a 2019 meme with no equity behind it. The corpus's own note — "reserve wordless aesthetic B-roll for creators with an established persona" — needs to be generalised to the caption-gag format too, and it isn't.

**9. All-caps emoji titles ("Close Call 💀", "SO LUCKY!!").** Native on TikTok; on YouTube this is the exact register of the faceless crash-repost farms the corpus itself flags as most exposed to reused-content enforcement. Platform-gate it.

**10. Absent from the corpus entirely:** the "hyperbole about ordinary cars" failure has no rule at all. Nothing stops the agent writing "this thing is an absolute WEAPON" about a Camry TRD. The Stradman price/scarcity archetype ("$3,500,000, only 29 in the world, sold out") transplanted onto a $45K crossover reads as a dealership ad, and the spec provides no guard.

---

## 4. Subculture collisions

The corpus contains one good rule — "pick one tribe's frame per script and stay inside it" — and then supplies archetypes drawn from mutually hostile tribes with no routing logic. Specific collisions:

1. **Skill demo vs ADV/touring/cruiser.** "SKILL DEMONSTRATION WITH VISIBLE OUTCOME — show the knee-down, the wheelie" is sportbike-coded. To ADV and cruiser audiences it reads as squid. It is *also* the exact thing that drops YouTube from full ads to limited ads (stand-up wheelie / hands-free). The archetype is simultaneously a tribal and a monetization liability.

2. **Judgment invitation requires the creator to pass the test.** MotoJitsu can run "What Did He Do Wrong?" because his channel is explicitly ATGATT and his own slow-speed control is on camera. A creator filmed in a hoodie cannot run this format at all — it inverts into a hypocrisy pile-on. Gate the format on the creator's own on-camera gear and riding, not on the topic.

3. **FortNine's register is not portable to a Harley audience.** F9 is sportbike/ADV-coded with open contempt for cruiser orthodoxy. "Loud pipes save lives is nonsense" is a defensible F9 position and an audience-ending one for a bagger channel. Cruiser is also the largest paying moto demographic.

4. **JDM reverence vs classic/restoration.** Engine-code literacy (2JZ, RB26) reads as Gran Turismo-brained to a pre-war or concours audience. Conversely, the corpus romanticises **patina** (Vice Grip Garage) — which to a restoration audience is neglect, and to a Barrett-Jackson audience is a defect.

5. **Stance is structurally excluded.** The corpus's dominant voices — FortNine, Engineering Explained, CanyonChasers, Papadakis, ChrisFix — are all the function-over-form tribe, and "function over form" is written in as a value. Stance deliberately inverts that test. If the creator's audience is show/fitment, **essentially every archetype in the spec is hostile to them** and the spec never says so.

6. **Mall-crawler taxonomy is a purity test the creator must survive.** "Nerf bars instead of real sliders," "20-inch rims and it's 2wd" — run this with a levelled truck on 20s in your own B-roll and you end yourself. It also insults the largest and most commercially valuable segment of the truck market.

7. **EV has no native archetype.** SILENT SPEC CARD, PURE ENGINE-NOTE, DRAG COUNTDOWN, "script 5–8 seconds of raw exhaust" — the sound-led archetypes, which the corpus calls the ceiling formats, are structurally unavailable for EV content. EVs are a large and growing share of new-car short-form. The spec has nothing for it, and the "soul" material is written entirely from the ICE side.

8. **Buying-advice audiences are consumers, not enthusiasts.** Chevy Dude / CarEdge / Lucky Lopez viewers are people buying a car. Applying enthusiast gatekeeping rules (engine codes, "never say 'this car'", terminology purity) to that audience is a category error — and note this is the audience attached to the 14M-view Short.

**Questions the agent must answer before writing a single line:**
- Which tribe is the core audience? (JDM/tuner · stance · track · classic/restoration · truck/overland · Euro · muscle · EV/tech · exotic/lifestyle · consumer-buyer; moto: sportbike · cruiser/Harley · ADV · dirt/supermoto · touring · vintage)
- Market register: US / UK / CA / AU / EU — currency, panel names, regulatory frame.
- Does the creator personally pass this format's purity test (gear, own vehicle, own hands, own money)?
- Is the vehicle owned, borrowed, press-fleet, rented, or someone else's? (drives both disclosure and which archetypes are available)
- Is any footage third-party, and what is the licence?
- ICE or EV — because it decides whether sound is available as the payload.

---

## 5. Generic-advice purge

Cut or demote — these are general short-form advice with a car bolted on, and they occupy roughly a third of the corpus:

- Hook in the first three seconds; don't open with an intro; no "hey guys."
- Start mid-thought / open on a conjunction.
- Target 25–45s; payoff before 20s.
- End with a question rather than "let me know below."
- Write platform-specific, not once-for-three.
- No cross-platform watermarks.
- Text overlay for muted viewing.
- Assert, don't hedge.
- Use a hard number.
- Self-deprecation is credibility armor.
- Don't lead with the sponsor. *(also now unevidenced — see §2)*
- "Faceless is fine, templated-with-no-original-input is not." *(restating YouTube's TOS)*
- "Don't spin up a separate Shorts channel." *(generic **and** falsified by OGchevydude)*
- "Do not gate the hook on production polish." *(true everywhere)*

**Keep — these are genuinely automotive and genuinely earned:**
- Macro on a single failed part, in hand, shallow DOF, deadpan naming (Watch Wes, 1.2M on a lug nut).
- Year/trim-range targeting: "if you have a 2012–2014 Camry" — makes owners feel addressed and creates a legitimate correction surface.
- Quoted-claim disproof: `"Other Shop" Says You Need A Motor!` (2.5M) — repair-order register as a title system.
- Sound as the payload, text as the contract; the roll-on pull with a spec title.
- Lead with the failure, not the win (Donut, South Main, Hoovie) — well evidenced across three independent channels.
- The obscure-part explainer (Papadakis 430K vs 22K) — the cleanest single result in the corpus.
- Terminology precision, and the provenance rules.
- Real numbers itemised, never MSRP-as-price.

---

## 6. Policy blind spots

The policy report is the strongest of the four and its platform-text quotes are worth keeping (with the primary-source verification it asks for). What it missed:

1. **Defamation and recording-consent — the biggest gap.** The corpus promotes "I got scammed by a [named brand] dealership" as the highest-floor format and instructs the agent to *name the brand inside 3 seconds*. Naming a specific franchise or an identifiable service advisor turns a script into a defamation exposure with no platform protection. Worse: the marquee example cold-opens on a third party's recorded voice, in **Florida — a two-party-consent state** (as are CA, IL, PA, WA, MA, MD). The spec must require: no named dealership without documentation, no identifiable third-party audio without consent, opinion framing over factual assertion.
2. **Customer PII in shop content.** Plates, VINs, repair-order names, faces. Not mentioned once, and every garage-diagnosis archetype in the spec puts a customer's vehicle on camera.
3. **Emissions-defeat content.** EGR/DPF deletes, defeat tunes, catless downpipes. The EPA has fined tuners and shops directly under the Clean Air Act, and this is live in exactly the diesel/tuner segment the corpus touches (WhistlinDiesel adjacency). Completely absent.
4. **Theft-adjacent instruction.** ChrisFix's 6M "How to Remove Locking Lug-Bolts without the Key" is celebrated as the model format; it sits one step from YouTube's instructional-theft line, and catalytic-converter and relay-attack content is squarely over it. The spec should flag the boundary rather than hold the example up unqualified.
5. **FTC 16 CFR 255 / ASA disclosure.** The corpus treats "say if it's borrowed" as a *credibility* move. A loaned press vehicle, a comped part, or a covered trip is a **material connection requiring disclosure by law** in the US and UK. Legal obligation, not tone.
6. **Press embargoes.** The first-look walkaround archetype (Pushing Pistons' 2027 Audi Q9, 6M) runs on press-fleet access. Breaking an embargo gets a creator blacklisted from OEM fleets permanently — an existential business risk for that entire format, unmentioned.
7. **Incidental music at car meets.** Meta Rights Manager and Content ID routinely mute Reels/Shorts over background music at a cars-and-coffee or a show. "Engine noise is the natural answer" doesn't cover ambient capture at events.
8. **"Made for kids" misflagging.** Car content — bright vehicles, "cars" keywords, toy-adjacent thumbnails — draws MFK flags, which kill comments and personalized ads. Automotive-specific and absent.
9. **Reused-content risk from the creator's own long-form.** The corpus recommends serialised long-form clips (Donut) while elsewhere warning about reused content. YouTube's inauthentic-content enforcement treats mechanical re-cuts of your own long-form differently from your original uploads; the spec needs to say what "original input" means for a clip.

---

## 7. The faceless problem

The corpus's answer — "the human element must be the OPINION and the original footage, write in first person with a stake" — is half right and half actively dangerous. Telling an agent to write first-person stakes ("I bought this," "this happened to me") **over footage the narrator did not shoot** is instructing it to fabricate. That is the Tiffany Mitchell failure mode with a voiceover instead of a photographer.

The real dividing line is **provenance discipline**, and it's testable:

**What kills faceless automotive channels** — the audience does frame-level forensics, and these are the specific tells:
- Narration describes a sound the clip does not contain, or the clip has a music bed under a "listen to that lifter tick."
- B-roll is the wrong generation, facelift, trim, or market: RHD footage under a US-market story, a pre-facelift bumper under a facelift claim, the wrong wheel, a European plate.
- The engine on screen isn't the engine in the script — a 1JZ or an RB under "2JZ" narration is the canonical one, and it gets caught in minutes.
- Mirrored/flipped stock footage, which puts the shifter, the exhaust, or the timing side on the wrong side.
- Multiple camera angles of an "unfolding" discovery.
- Implausibly clean fluids, or a filmed-before-the-drain-plug-comes-out sequence.
- Any first-person claim ("when I pulled the head") with no hands, no shop, and no continuity.

**What makes faceless work** — four survivable models, all of which relocate authority away from ownership:
1. **Analysis over credited clips.** The narrator owns the *read*, not the footage, and says so on screen. DanDanTheFireman and Dashcam Lessons (992K) are this. Credit line on screen solves rights and the "he stole this" attack in one move.
2. **Documented/archival framing** where nobody expects presence — auction results, recall filings, NHTSA complaint data, EPA figures, period press. ThatDudeinBlue's "$22,000 **in 2004 money**" is this: the qualifier converts a stat into an argument and requires no presence.
3. **The object in your own hand.** Watch Wes Work is the ceiling case — a rusty lug nut on a fingertip did 1.2M. Strictly this isn't faceless, it's hands-only, and that's the point: **hands are the cheapest possible credential and they defeat every gatekeeping attack.**
4. **Engineering claims with a mechanism.** Engineering Explained is functionally faceless at the hook level — the authority is the physics, which is checkable.

**The rule to encode, replacing the corpus's version:** *never write a sensory or first-person claim that the footage on screen cannot substantiate.* Write around footage you didn't shoot ("a stock 2JZ makes X — here's why the head gasket goes first"), never inside it. Credit third-party clips on screen. And where a claim needs presence, either get hands in frame or change the claim.

---

## Bottom line for the spec

1. **Discard every view-count range from the landscape report** and re-derive from sorted pulls. Its headline finding — instruction loses, jeopardy wins — is backwards.
2. **Delete** `@Motorfied`, `BRAAAPP-ONLY`, the Supercar Blondie Shorts channel claim, the "separate Shorts channel" recommendation, the Grokipedia-sourced policy figures, and all Reddit-attributed quotes.
3. **Fix** `@itsjusta6official`, Dash Cam Owners Australia (604K), Chevy Dude (514K + 351K, not "~1M"), the `a8bg_ES2jN8` Merlin-engine misreading, and the `kHq_T7BN0_8` long-form-as-Short error.
4. **Add** the missing archetype the data revealed (the spec-titled roll-on pull), the market-register lock, the tribe-routing questions, an EV-native format, and the anti-Scotty-Kilmer ceiling on jeopardy language.
5. **Add** the legal layer the corpus has no coverage of: defamation, two-party consent, customer PII, disclosure law, embargoes, defeat devices.