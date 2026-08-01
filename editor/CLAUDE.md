# Editing — ffmpeg conventions

Loads whenever I work in `editor/`. These are verified-working incantations, not
guesses. Anything added here should be tested before it's written down.

## Where work happens

**The desktop, not the laptop.** The laptop (i3, 8 GB, Intel UHD) is the brain —
planning, cut lists, metadata. The desktop (32 GB, RTX 2080 Ti) is the render
farm. Never propose a long encode on the laptop.

## Verified toolchain

| Tool | Version | Notes |
|---|---|---|
| ffmpeg | 8.1.2 (Gyan full build) | Wins on PATH. `winget install Gyan.FFmpeg` |
| ffprobe | 8.1.2 | Same package |
| yt-dlp | 2026.07.04 | Pulls in Deno + a **second** ffmpeg build as dependencies |

> **Two ffmpeg copies exist on PATH.** Gyan's full build resolves first, which is
> what we want. If a command ever behaves oddly, check which binary ran:
> `Get-Command ffmpeg -All`

## ⚠ The Windows font trap

`drawtext` **fails on Windows with no fontconfig**:

```
Fontconfig error: Cannot load default config file: File not found
```

The command exits non-zero and **writes no output file**. Every caption burn
must pass an explicit `fontfile`, and the drive-letter colon must be escaped for
the filter parser:

```
fontfile='C\:/Windows/Fonts/arialbd.ttf'
```

Note the backslash before the colon and forward slashes after. Verified working
2026-07-31.

## Verified recipes

### Long-form → 9:16 vertical with a burned caption

```powershell
ffmpeg -y -i in.mp4 -vf "crop=ih*9/16:ih,scale=1080:1920,drawtext=fontfile='C\:/Windows/Fonts/arialbd.ttf':text='STOCK BOTTOM END':fontcolor=white:fontsize=64:x=(w-text_w)/2:y=h-220:box=1:boxcolor=black@0.6:boxborderw=20" -c:a copy out.mp4
```

Produces 1080×1920 h264. `crop=ih*9/16:ih` takes the centre column — fine for
static shots, **wrong when the subject is off-centre.** For those, offset the
crop with `x=` rather than accepting a centred crop that cuts the subject out.

### Inspect a clip (always do this before planning a cut)

```powershell
ffprobe -v error -select_streams v:0 -show_entries stream=width,height,codec_name,r_frame_rate -show_entries format=duration -of default=noprint_wrappers=1 in.mp4
```

### Lossless trim (no re-encode — fast, keyframe-snapped)

```powershell
ffmpeg -y -ss 00:01:23 -to 00:01:45 -i in.mp4 -c copy out.mp4
```

Use for rough assembly. Cuts land on keyframes, so it is **approximate** — for
frame-accurate cuts drop `-c copy` and accept the re-encode.

### Extract audio for transcription

```powershell
ffmpeg -y -i in.mp4 -vn -ac 1 -ar 16000 -c:a pcm_s16le out.wav
```

16 kHz mono is what Whisper wants. Don't feed it a 48 kHz stereo stream.

### Proxy for reviewing on the laptop

```powershell
ffmpeg -y -i in.mp4 -vf scale=-2:480 -c:v libx264 -preset veryfast -crf 28 -c:a aac -b:a 96k proxy.mp4
```

## Hardware encoding

`ffmpeg -encoders` lists `nvenc`, `qsv` **and** `amf` on this laptop — that
listing is **compile-time, not runtime.** There is no NVIDIA or AMD hardware
here; only QSV could plausibly work, and it is untested.

- **Desktop:** use `h264_nvenc` (2080 Ti). Big win on export time.
- **Laptop:** assume `libx264` and expect it to be slow. Don't render here.

## Platform targets

| Target | Spec |
|---|---|
| YouTube long-form | 1920×1080, h264, keep source frame rate |
| YouTube Shorts | 1080×1920, ≤180s |
| Instagram Reels | 1080×1920, **5–90s** to land in the Reels tab |
| TikTok | 1080×1920 |

## Rules

- **Cut from originals, never proxies.** Proxies are for review only.
- **Never overwrite a source file.** Always write to a new path.
- Check the first 7 seconds of any YouTube upload for profanity — ad-eligibility
  window. See `../brand/CLAUDE.md`.
- Captions burned in, not sidecar — most viewing is sound-off.
