# Publishing — the gate comes first

Loads whenever I work in `publisher/`. Read the first rule before doing anything
else here.

## THE RULE

**Post only from `approved/`. Never from `queue/`. Never from anywhere else.**

Connor moves a file into `approved/` and that is the green light. Anything still
sitting in `queue/` at post time is **skipped** — not posted anyway, not guessed
at, not "probably fine." **Silence means no.**

Decided 2026-07-31, replacing the earlier "I never post anything" rule. A
`PreToolUse` hook (`.claude/hooks/publish-gate.js`) enforces this, so it is
structural rather than something I have to remember. **If the hook blocks me,
the hook is right and I am wrong.** Do not work around it.

## Flow

```
queue/      I write finished posts here — media, caption, tags, target time,
            all in one readable file Connor can review on his phone
   |
   v  (Connor moves the file — the ONLY approval signal)
approved/   I may post from here, and only here
   |
   v
posted/     archive + the returned post ID, so metrics can join back later
tokens/     gitignored OAuth refresh tokens. Never read into context.
```

## Always

- **Log the returned post ID** into `posted/`. Without it, metrics can never be
  joined back to the post that produced them, and the learning loop breaks.
- **Disclose** sponsorship, affiliate, and gifted parts in the caption itself,
  not in a reply. FTC's position and Connor's hard line.
- **Never name Connor's employer** — check captions and any visible frame.
- Record what actually went out. If Connor rewrote my draft, log the delta in
  `../playbook/voice-notes.md`.

## Per-platform reality

| Platform | Auto-post | Notes |
|---|---|---|
| **YouTube** | Yes | OAuth as channel owner. Channel `UCcQsA-i3zAWroB4pRnCU1uA`. |
| **Instagram** | Yes, conditionally | Business/Creator + Facebook Page + `instagram_content_publish`. Three-step container flow; **needs a publicly reachable video URL** (Cloudflare R2 via `wrangler`). Reels: 9:16, 5–90s. Token expires every 60 days. |
| **X** | Yes | Free tier posts fine but cannot read metrics. No account yet. |
| **TikTok** | **No** | Content Posting API needs a 2–4 week audit; unaudited posts land `SELF_ONLY`. **Upload manually.** Do not build against this API. |

## Never

- Never post something Connor hasn't approved, however obvious it seems.
- Never paste a token into a file, a script, or chat. Credentials live in `.env`.
- Never delete from `posted/` — it's the join key for the whole metrics loop.
