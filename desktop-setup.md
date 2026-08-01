# Desktop setup — the short version

Four steps. Two are copy-paste. **Everything else, I do once I'm on the machine.**

---

## 1 — While Windows Update runs

Get the **NVIDIA Studio driver** for the 2080 Ti:
<https://www.nvidia.com/download/index.aspx>

Pick **Studio**, not Game Ready. Studio is the branch tuned for encode
stability — that's what we use the card for.

Let Windows Update finish and reboot before Step 2.

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

---

## 3 — One paste. PowerShell, **normal** this time

```powershell
irm https://claude.ai/install.ps1 | iex
```

Close the window again.

---

## 4 — Copy the folder over, then start me

Copy `C:\Users\cgrace8504\Desktop\AI\` from the laptop to the desktop by **USB**.
Not cloud sync, not email — the folder contains `.env` with your YouTube key.

Then open PowerShell and:

```powershell
cd C:\Users\cgrace8504\Desktop\AI
claude
```

Log in with **connoragrace@gmail.com** — same account, same subscription, not a
second one.

Paste this as your first message:

> Read CLAUDE.md. Verify the toolchain, load the hooks, and test that both of
> them actually block. Then tell me what's broken.

**That's you done.** I check the five tools installed, confirm NVENC is real on
this card, arm the publish gate, run all four hook tests, and report back.

---

## If something looks wrong

**`python` opens the Microsoft Store instead of printing a version** — that's the
Store stub, same trap the laptop had. Settings → Apps → Advanced app settings →
App execution aliases → turn **off** `python.exe` and `python3.exe`.

**`claude` isn't recognised after Step 3** — you're in the old window. Open a new
one. If it still fails, fallback: `npm install -g @anthropic-ai/claude-code`
(Node came in with Step 2).

**Different Windows username on the rebuilt box** — fine, the paths in the repo
are relative now. Just tell me the new folder path.

Anything else: tell me what it said and I'll sort it.

---

## Then the part that actually has a deadline

- [ ] **Offload every SD card and all three phones** onto the desktop
- [ ] **Back it up off-site** — I'll set up rclone to Backblaze B2, ~$6/TB/month

Sunday's archive dig can't start without the footage, and **Aug 7** rides on
Sunday. Right now years of this build sit in exactly one place and in zero
backups. Setup is reversible; that isn't.
