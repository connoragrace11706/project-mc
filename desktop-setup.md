# Desktop setup — the short version

Four steps. Two are copy-paste. **Everything else, I do once I'm on the machine.**

---

## 1 — While Windows Update runs

Get the **NVIDIA Studio driver** for the 2080 Ti:
<https://www.nvidia.com/download/index.aspx>

Pick **Studio**, not Game Ready. Studio is the branch tuned for encode
stability — that's what we use the card for.

Let Windows Update finish and reboot before Step 2.

> **STATUS 2026-08-01 — RESOLVED.** Was broken on driver **596.36**:
>
> ```
> Driver does not support the required nvenc API version. Required: 13.1  Found: 13.0
> The minimum required Nvidia driver for nvenc is 610.00 or newer
> ```
>
> Fixed by installing **Studio Driver 610.88 WHQL** (released 2026-07-28):
>
> ```
> https://us.download.nvidia.com/Windows/610.88/610.88-desktop-win10-win11-64bit-international-nsd-dch-whql.exe
> ```
>
> Note the filename needs `-dch-`; the otherwise-obvious `...-nsd-whql.exe`
> 404s. Authenticode-verified as NVIDIA Corporation before installing.
>
> Post-reboot `nvidia-smi` reports **610.88**, and the two-second `h264_nvenc`
> test encode succeeds — 60 frames, 1920x1080, 2.000 s, exit 0, 881 KB.
>
> Turing (RTX 20-series) keeps full Studio driver support through **October
> 2026**. After that this same wall can come back, and the fallback would be
> pinning an older ffmpeg rather than chasing a driver that no longer ships.

---

## 2 — One paste. PowerShell **as Administrator**

Right-click Start → *Terminal (Admin)*.

```powershell
winget install --id Gyan.FFmpeg        --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id yt-dlp.yt-dlp      --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.13 --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id Git.Git            --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id OpenJS.NodeJS.LTS  --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
```

**Then close the window.** Installers change PATH; an open window keeps the old
one. That's the cause of most "command not found" confusion on Windows.

> **STATUS 2026-08-01 — done, but only on the second attempt.**
> The first run of this paste silently did not take: `winget list` later showed
> **no matching package** for `Gyan.FFmpeg`, `yt-dlp.yt-dlp`, or
> `Python.Python.3.13`, and none of the three were on PATH. Git and Node were
> fine (they came from their own MSIs). Re-run installed all three.
>
> **Verify it actually took** rather than assuming — in a *new* window:
>
> ```powershell
> ffmpeg -version; yt-dlp --version; python --version; git --version; node --version
> ```
>
> Confirmed working 2026-08-01: ffmpeg **8.1.2**, yt-dlp **2026.07.04**,
> Python **3.13.14**, git **2.55.0**, node **v24.18.1**.
>
> Note: `yt-dlp` pulls in two dependencies of its own — **Deno** and a **second
> ffmpeg build**. Harmless, but it means two ffmpeg binaries are on PATH. Gyan's
> build wins the ordering, which is the one we want.

---

## 3 — One paste. PowerShell, **normal** this time

```powershell
irm https://claude.ai/install.ps1 | iex
```

Close the window again.

---

## 4 — Copy the folder over, then start me

**Done 2026-08-01, in two stages.** Copied from
`C:\Users\cgrace8504\Desktop\AI\` on the laptop by USB, verified byte-identical
(SHA256, 79/79 files).

It landed in **OneDrive** first, which was wrong — the folder contains `.env`
with your YouTube key, and cloud sync also locks files mid-write.

An earlier version of this doc claimed the folder had been moved to `C:\dev\ai`.
**It had not.** `C:\dev\ai` did not exist; the repo was still running out of
`C:\Users\conno\OneDrive\Desktop\ai`, key and all. Moved for real on 2026-08-01:
234/234 files SHA256-verified byte-identical at `C:\dev\ai`, `git fsck` clean,
HEAD unchanged at `5883aab`, working tree clean, `.env` and `api key/` still
correctly gitignored.

**The repo lives at `C:\dev\ai`. Never on OneDrive.** If a future session opens
somewhere under `OneDrive\`, that is the bug — stop and move it.

Then open PowerShell and:

```powershell
cd C:\dev\ai
claude
```

Log in with **connoragrace@gmail.com** — same account, same subscription, not a
second one.

Paste this as your first message:

> Read CLAUDE.md. Verify the toolchain, load the hooks, and test that both of
> them actually block. Then tell me what's broken.

**That's you done.** I check the five tools installed, confirm NVENC is real on
this card, arm the publish gate, run all four hook tests, and report back.

### The four hook tests

These used to be referred to as "all four hook tests" without ever being written
down. They are two hooks, each of which has to **block the bad case and allow the
good one** — a hook that blocks everything is as broken as one that blocks
nothing.

| # | Hook | Case | Expected |
|---|---|---|---|
| 1 | `publish-gate.js` | publish command targeting `publisher/queue/` | **deny** |
| 2 | `publish-gate.js` | publish command targeting `publisher/approved/` | allow |
| 3 | `secret-scan.js` | API key written into a tracked file | **deny** |
| 4 | `secret-scan.js` | same key written into `.env` | allow |

Feed a `PreToolUse` payload straight into the hook on stdin — that tests the
script without needing to provoke a real tool call.

> **Do NOT pipe the payload in PowerShell.** This was wrong in an earlier
> version of this doc and it produces **false passes**:
>
> ```powershell
> # BROKEN - do not use
> '{"tool_name":"Write","tool_input":{...}}' | node .claude\hooks\secret-scan.js
> ```
>
> PS 5.1 prepends a UTF-8 BOM (`U+FEFF`) when piping to a native exe, so the
> hook's `JSON.parse` throws. Both hooks `catch { process.exit(0) }` — they
> **fail open** — so the BOM makes every case print nothing, which reads as
> "allow". The two deny tests silently pass-as-allow and the two allow tests
> are indistinguishable from a crashed hook. `$OutputEncoding` does not
> suppress it (verified 2026-08-01).
>
> Write a BOM-less file and redirect stdin instead:
>
> ```powershell
> $f = "$env:TEMP\payload.json"
> [System.IO.File]::WriteAllText($f, $json, (New-Object System.Text.UTF8Encoding $false))
> cmd /c "node ""C:\dev\ai\.claude\hooks\secret-scan.js"" < ""$f"""
> ```
>
> Working harness kept at `scratchpad\gate-tests.ps1`; it runs all four and
> prints a tally. Claude Code itself feeds the hooks clean UTF-8, so this trap
> only ever affected the manual test, never the live gate.

Deny prints a JSON `permissionDecision` block; allow prints nothing. Both hooks
exit 0 either way, so **check the output, not the exit code.** Always confirm at
least one deny case actually denies — that is what proves the harness is
delivering stdin at all.

**Status 2026-08-01: 4/4 pass**, re-verified with the redirect harness above.
The publish gate also blocked a real tool call during testing — the test command
itself named `queue`, and the hook killed it before it ran. It is genuinely
armed, not just correct in isolation.

---

## If something looks wrong

**`python` opens the Microsoft Store instead of printing a version** — that's the
Store stub, same trap the laptop had. Settings → Apps → Advanced app settings →
App execution aliases → turn **off** `python.exe` and `python3.exe`.

After the Step 2 re-run the real interpreter sits at
`%LOCALAPPDATA%\Programs\Python\Python313\`, which is **ahead of** `WindowsApps\`
in PATH, so a new shell should get the real one. If it doesn't, the aliases above
are why. There is also a `uv`-managed 3.13.14 (`uv run python`) that bypasses
PATH entirely and is unaffected by the stub.

**`ffmpeg -version` works but NVENC fails** — that's the driver, not ffmpeg. See
the Step 1 status box. Confirm with a two-second encode rather than trusting
`ffmpeg -encoders`; the encoder is listed even when the driver can't run it:

```powershell
ffmpeg -f lavfi -i testsrc=size=1920x1080:rate=30:duration=2 -c:v h264_nvenc -b:v 5M test.mp4
```

**`claude` isn't recognised after Step 3** — you're in the old window. Open a new
one. If it still fails, fallback: `npm install -g @anthropic-ai/claude-code`
(Node came in with Step 2).

**Different Windows username on the rebuilt box** — fine, the paths in the repo
are relative now. Just tell me the new folder path.

Anything else: tell me what it said and I'll sort it.

---

## Pipeline tooling — added 2026-08-01

Beyond the five from Step 2:

| Tool | Version | For |
|---|---|---|
| rclone | 1.75.0 | Off-site backup to Backblaze B2 |
| ExifTool | 13.59 | Real shoot dates for `/index-footage` |
| faster-whisper | 1.2.1 | Local transcription, GPU |
| CTranslate2 | 4.8.1 | Whisper inference engine |

Also upgraded: .NET Runtime 8.0.21 → 8.0.29, VC++ Redistributable x64/x86
14.42 → 14.51. `winget upgrade` is now clean.

### Transcription environment

Lives at **`C:\dev\ai\.venv`** (uv-managed, Python 3.13.14). Gitignored.

**Verified working on GPU 2026-08-01** — `large-v3`, CUDA float16, a
TTS-generated test sentence transcribed at **19/19 words, 0.9 s for a 17 s clip**
(~19x realtime). First load is ~38 s of CUDA warmup; after that it's sub-second.

**This worked even while NVENC was broken** — the old driver only blocked the
*encode* path; CUDA compute was always fine. Both paths are healthy now on
610.88.

### Encode settings that matter

- **Always pass `-pix_fmt yuv420p` for anything we ship.** With RGB input
  (`testsrc`, some screen captures) NVENC silently picks *High 4:4:4
  Predictive*, which plays back badly outside desktop players and is a bad
  surprise to find after a long export. Forcing `yuv420p` gives Main profile.
- **Don't expect a huge speedup on short 1080p.** Measured 2026-08-01 on a 30 s
  1080p synthetic clip: NVENC `p5` 3.22 s vs libx264 `medium` 4.41 s — only
  **1.4x**. Synthetic footage compresses trivially and the run is dominated by
  decode/filter, so this understates the real gain. The wins that actually
  matter are long real footage, 4K, and that NVENC leaves the CPU free.
  Re-benchmark on real build footage once it is offloaded.

**The one gotcha:** CTranslate2 needs cuBLAS and cuDNN, which come from the
`nvidia-cublas-cu12` / `nvidia-cudnn-cu12` wheels and land in `site-packages`
where Windows does not look for DLLs. Any script must register them *before*
importing `faster_whisper`, or it fails with an opaque library error:

```python
import os, glob
for b in sorted(glob.glob(r"C:\dev\ai\.venv\Lib\site-packages\nvidia\*\bin")):
    os.add_dll_directory(b)
    os.environ["PATH"] = b + os.pathsep + os.environ["PATH"]
from faster_whisper import WhisperModel   # only after the loop
```

---

## Then the part that actually has a deadline

- [ ] **Offload every SD card and all three phones** onto the desktop
- [ ] **Back it up off-site** — rclone is installed; still needs a B2 account and
      `rclone config` (interactive auth — you have to do that part), ~$6/TB/month

Sunday's archive dig can't start without the footage, and **Aug 7** rides on
Sunday. Right now years of this build sit in exactly one place and in zero
backups. Setup is reversible; that isn't.
