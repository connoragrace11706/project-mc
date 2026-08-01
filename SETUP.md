# Setup — what's blocking, and what each thing costs you

Ordered by value-per-minute. Do them top down; stop whenever you like, the
system works with partial data.

---

## 1. YouTube API key — 10 minutes, free, do this one

Gets automated pulls of channel + per-video public stats.

1. Go to <https://console.cloud.google.com> and create a project.
2. **APIs & Services → Library →** search "YouTube Data API v3" → **Enable**.
3. **Credentials → Create Credentials → API key.** Copy it.
4. Click **Restrict key** → under *API restrictions* select YouTube Data API v3.
5. Copy `.env.example` to `.env` and paste the key into `YOUTUBE_API_KEY=`.
6. Tell me your channel handle and I'll fill in the channel ID.

Then: `.\ingest\Get-YouTubeStats.ps1`

**Caveat worth knowing up front:** this gets views/likes/comments. It does *not*
get retention, average view duration, or click-through rate — those need OAuth
as the channel owner. Those three are the numbers that actually explain *why*
a video did well. Until we wire up OAuth, paste them from YouTube Studio and
I'll merge them. That's a 2-minute job per review cycle.

---

## 2. Instagram — ~30 minutes, free, no Facebook Page needed

**Updated 2026-07-31.** This section used to say a linked Facebook Page was a
hard requirement. **That is no longer true.** Meta now ships two paths, and we
want the newer one:

| | **Instagram API with Instagram Login** ← use this | Instagram API with Facebook Login |
|---|---|---|
| Facebook Page | **Not required** | Required |
| Publishing | ✅ | ✅ |
| Media insights | ✅ | ✅ |
| Metrics on *other* accounts | ❌ | ✅ |

We don't need metrics on other people's accounts, so the Facebook Page and all
its overhead is pure cost. Skip it.

**The one real blocker that remains:** the IG account must be **Business or
Creator**. Personal accounts have no API access at all — no workaround.

### Steps

1. **Check the account type.** Instagram app → *Settings and privacy* →
   *Account type and tools*. If it offers "Switch to professional account" you
   are Personal — switch to **Creator**. Free, reversible, no feature loss.
2. <https://developers.facebook.com> → **Create App**.
3. Choose the use case that exposes **Instagram** (not Facebook Login).
4. Add the **Instagram** product → set up **Instagram API with Instagram Login**.
5. Request these scopes:
   - `instagram_business_basic` — profile + media
   - `instagram_business_content_publish` — posting
   - *(`instagram_business_manage_comments` if we want comment triage later)*
6. Generate a token, then **exchange the short-lived token for a long-lived one**
   (60 days).
7. Put it in `.env` as `IG_ACCESS_TOKEN`, and the account ID as `IG_USER_ID`.

**Note:** the older scope names (`instagram_basic`, `instagram_manage_insights`)
were deprecated in January 2025. Anything on the web using them is out of date.

**Annoyance:** the token expires every 60 days. Automate the refresh with a
Cloudflare Worker on a cron (`wrangler` is already installed), or set a calendar
reminder until then.

**Publishing gotcha worth knowing now:** the publish flow needs the video at a
**publicly reachable URL** — Meta fetches it, you don't upload bytes directly.
That's what Cloudflare R2 is for. Reels want 9:16, 5–90s.

---

## 3. TikTok — skip for now

The Display API requires an app that goes through a review process, and even
approved it gives thin data. **Recommendation:** export your analytics CSV from
the TikTok web dashboard (Analytics → Overview → Download data) every couple of
weeks and drop it in `data/manual/`. Ten seconds of work, better data than the
API gives.

---

## 4. X / Twitter — skip unless you're already paying

The free API tier is write-only; it cannot read your own post metrics. Basic is
about $200/month, which is not defensible at this stage of the brand.

**Recommendation:** manual entry via `data/manual-entry-template.csv`. X is the
lowest-yield platform for a visual brand anyway — treat it as a repost channel
and don't spend money instrumenting it.

---

## 5. Paid connectors — optional shortcut

`Supermetrics` and `Windsor.ai` are already installed as connectors in this
session and would cover all four platforms with an OAuth click, no code. Both
are paid SaaS aimed at marketing agencies (typically $50–200+/mo after a trial).

**My take:** not worth it yet. The DIY path above covers YouTube and Instagram
for free, and those are 80% of what matters for this brand. Revisit if the
manual entry becomes a chore you actually skip — a connector you use beats a
free script you don't.

Say the word and I'll kick off the OAuth flow for either one.

---

## 6. Backblaze B2 — off-site backup. **The one with a real deadline.**

Everything above is about measuring the channel. This one is about not losing
the thing the channel is made of. Years of build footage currently exist on SD
cards and three phones, in **one** place, with **zero** backups. Every other
item on this list is reversible; that one isn't.

`rclone` 1.75.0 is installed and `ingest\Backup-Footage.ps1` is written and
ready. The parts I cannot do for you are the account and the key — both need a
browser and a card on file.

### What you do (~10 minutes)

1. <https://www.backblaze.com> → sign up for **B2 Cloud Storage**. Needs a card;
   first 10 GB are free, then roughly **$6/TB/month**.
2. **Buckets → Create a Bucket.**
   - Name: bucket names are globally unique across all of B2, so `footage` is
     long gone. Use something like `projectmc-footage-archive`.
   - Files in bucket: **Private**.
   - Default encryption: **Enable** (free, server-side).
   - Object Lock: leave off unless you want files to become genuinely
     undeletable for a fixed period.
3. **Lifecycle Settings → Keep all versions of the file.** This is the setting
   that saves you from a bad delete or a ransomware run. Do not set it to keep
   only the last version.
4. **Application Keys → Add a New Application Key.**
   - Allow access to: **that one bucket only**, not "All".
   - Type: **Read and Write**.
   - Copy both values. The application key is displayed **exactly once**.
5. Put all three into `.env`:

   ```
   B2_ACCOUNT_ID=<the keyID, not your account number>
   B2_APPLICATION_KEY=<shown once>
   B2_BUCKET=projectmc-footage-archive
   ```

   `.env` is gitignored. Do not paste these into chat — I don't need to see
   them, the script reads them itself.

### Then tell me, and I'll run it

```powershell
.\ingest\Backup-Footage.ps1 -FootageRoot C:\footage\raw -DryRun   # always first
.\ingest\Backup-Footage.ps1 -FootageRoot C:\footage\raw
.\ingest\Backup-Footage.ps1 -FootageRoot C:\footage\raw -Verify   # prove it landed
```

### Two things worth understanding about how this is built

**It uses `rclone copy`, never `rclone sync`.** `sync` makes the remote match
the local copy, which means it deletes remote files whose local original has
gone. That is precisely the failure we are buying insurance against: one bad
delete or one drive that drops offline mid-scan, and `sync` dutifully destroys
the second copy too. `copy` only ever adds. It leaves orphans behind when you
rename things, and that is a cheap price.

**Credentials never touch a command line.** The script reads `.env` and hands
rclone its config through `RCLONE_CONFIG_*` environment variables, so the key
stays out of shell history, out of the rclone log, and out of `rclone.conf`.

### Not done yet, and it matters

- **Free space:** this machine has **one** drive with **854.8 GB free**, not the
  ~2 TB `ROADMAP.md` assumed. Nobody has measured the archive yet. If the cards
  and phones total more than ~850 GB, the offload fails partway and the backup
  never gets a complete source. **Measure before copying** — add up the used
  space on every card and phone first.
- Restores are untested. A backup you have never restored from is a hypothesis.
  Once the first upload lands, pull one clip back down and play it.

---

## What I need from you regardless of the above

These aren't blocked on any API — fill in `brand/profile.md`:

- The car(s), the class you run, where the build is right now
- Your handles on each platform
- Realistic hours/week for filming and editing
- Anything off-limits to talk about publicly
