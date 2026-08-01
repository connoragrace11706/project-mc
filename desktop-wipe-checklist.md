# Desktop wipe — read this at the machine

Written 2026-08-01. Machine is old and degraded, not compromised. Goal: a clean
box that becomes the render farm for the content pipeline.

**Step 1 has no undo. Everything else is recoverable.**

---

## Step 1 — rescue what's irreplaceable (15 min)

The only step you can't take back. Copy to an external drive or a cloud folder:

- [ ] Footage and photos not already on the SD cards / three phones
- [ ] **G's photography work** — the thing I'd worry about most
- [ ] Documents and receipts — **the $40k parts invoices** if any live here
- [ ] Build files — datalogs, tune files, wiring diagrams
- [ ] Browser bookmarks (export to a file, or just sign into your browser account)

**If you're unsure whether something exists elsewhere, copy it.** Storage is
cheap; a 2021 track day is not re-shootable.

Skip programs entirely. Reinstall those fresh — dragging old installers across is
how a clean machine gets cooked again.

## Step 2 — Reset with Cloud download ← recommended

No USB stick, no driver hunting, no Media Creation Tool. Start it in two minutes.

**Settings → System → Recovery → Reset this PC**

1. **Remove everything**
2. **Cloud download** ← *important*, see below
3. **Change settings** → **Clean data: Yes**
4. Reset

**Why Cloud download and not Local reinstall:** Local rebuilds from the recovery
image sitting on your drive, which on a machine this old is a stale, bloated
version of Windows — you'd be restoring the same tired OS. Cloud pulls current
Windows files from Microsoft (~4 GB). Fresh result, and it still handles your
drivers, which a USB clean install does not.

**Clean data: Yes** is the difference between "delete the files" and "actually
overwrite them." Adds time, worth it, and it's the right call if this machine
ever gets sold or handed on.

Budget 30–60 minutes unattended.

### If you'd rather do a USB clean install

Slightly cleaner — strips OEM bloat and any junk in the recovery partition. Costs
you driver hunting:

- **Download the LAN + chipset drivers to the USB first.** Fresh installs often
  have no network driver, and no network driver means you can't download the
  network driver. Find your board with `msinfo32` → *BaseBoard Product*.
- Build media on the laptop: <https://www.microsoft.com/software-download/windows11>
- Boot from USB (F12 / F2 / Del at power-on), **Custom: Install Windows only**,
  delete every partition on the system drive, install to the unallocated space

**Reset with Cloud download is the better trade unless you specifically want the
OEM partitions gone.**

**Licence:** digital and tied to the motherboard. Reactivates on its own, no key
needed.

**Second data drive?** Leave it out of the reset — don't let it get formatted.

## Step 3 — rebuild for the content work

- [ ] Windows Update until it stops finding things
- [ ] **NVIDIA driver for the 2080 Ti** — this is what makes the box worth using:
      CUDA for Whisper transcription, NVENC for fast exports
- [ ] Toolchain, already proven working on the laptop:

```powershell
winget install --id Gyan.FFmpeg        --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id yt-dlp.yt-dlp      --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.13 --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
winget install --id Git.Git            --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
```

- [ ] Install Claude Code so I can drive ffmpeg and Whisper against the footage
      directly
- [ ] **Install nothing you can't account for.** A clean machine that slowly gets
      its old software back is a machine on its way to being cooked again. That's
      how this one got here.

## Step 4 — the thing the ship date actually depends on

- [ ] **Offload every SD card and all three phones** onto the rebuilt desktop
- [ ] **Back it up off-site** — rclone to R2/B2. Years of a build living in
      exactly one place is how channels die.

Sunday's archive dig can't start without this, and the **Aug 7** ship date rides
on Sunday.

---

## Schedule

This replaces the Saturday infrastructure day in
`calendar/2026-08-07-origin-story.md` rather than adding to it. Aug 7 is still
live. Doing it tonight buys Saturday back for filming or the $40k invoice dig.
