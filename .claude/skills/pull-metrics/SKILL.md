---
name: pull-metrics
description: Pull fresh metrics from connected platforms into a dated snapshot. Use when the user asks to pull, refresh, sync, or update stats/metrics/numbers.
---

# Pull Metrics

## Steps

1. Read `data/accounts.json` to see which platforms are marked `active`.
2. For each active platform, run its ingest script from `ingest/`.
3. For platforms without API access (usually TikTok and X), prompt for manual
   entry using `data/manual-entry-template.csv`, or ask for a dashboard CSV
   export and parse it into the snapshot.
4. Write everything to `data/snapshots/<YYYY-MM-DD>/`.
5. Report what landed and — importantly — **what is missing and why**.

## Known gaps to always surface

| Missing | Why | Workaround |
|---|---|---|
| YouTube retention, avg view duration, CTR | Needs OAuth, not just an API key | Paste from YouTube Studio → Analytics → Content |
| Instagram token expired | Long-lived tokens die after 60 days | Regenerate in Graph API Explorer, update `.env` |
| TikTok everything | No practical API without app review | CSV export from the web dashboard |
| X metrics | Free tier is write-only | Manual entry |

## Rules

- Never write a snapshot with invented values. A missing field is `null`.
- If a script fails, report the actual error. Don't silently produce a partial
  snapshot that looks complete — a half-empty snapshot that reads as full will
  poison every review that follows.
- After a successful pull, offer to run `/weekly-review`.
