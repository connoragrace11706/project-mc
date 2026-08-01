#!/usr/bin/env python3
"""Hard gate for drafts. Blocks on the unarguable only.

Runs as a PreToolUse hook on Write|Edit (reads the hook JSON on stdin) and also
works standalone on a path. Exit 2 blocks the write and returns stderr to Claude.

Only fires on files under drafts/. Everything else passes untouched.

The rule this enforces: "never do X" in a skill file is a request, not a
guarantee. Anything mechanically checkable belongs here instead.

Usage:
    platform_check.py <file>...        # standalone
    echo '<hook json>' | platform_check.py   # PreToolUse hook
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

# --- Fabricated statistics. See craft/evidence-standards.md kill list. --------
KILL_LIST = [
    (r"\b(70|60|50)\s*%\s*(\+|or more|completion|retention)", "completion/retention threshold — no platform publishes these"),
    (r"view\s*pool", "TikTok 'view pools' — architecture is per-viewer scoring, no promotion ladder"),
    (r"batch\s*test", "TikTok 'batch testing' — no first-party source"),
    (r"graduat\w*\s+threshold", "graduation thresholds — invented"),
    (r"watch\s*time\s*(is|=|accounts for)\s*\d+\s*[-–]?\s*\d*\s*%", "watch-time weight — no platform has ever published a ranking weight"),
    (r"sends?\s+(carry|are worth|weigh)\s+\d", "sends multiplier — Mosseri said 'slightly', no number exists"),
    (r"\b\d+\s*x\s+(the\s+)?weight\s+of\s+(a\s+)?like", "engagement multiplier — invented"),
    (r"first\s+(30|60)\s*[-–]?\s*(to\s+)?\d*\s*minutes?\s+(decides|determines|window)", "first-hour window — imported from long-form, not Shorts/TikTok"),
    (r"best\s+time\s+to\s+post", "best-time-to-post tables are vendor content"),
    (r"reply\s+is\s+worth\s+\d+\s+likes?", "X engagement weights — from the 2023 repo, stale and never published for the current system"),
    (r"every\s+loop\s+counts", "loop counting — no first-party confirmation, and Shorts Engaged Views explicitly excludes loops"),
]

# --- Risk. See niche/risk.md. ------------------------------------------------
RISK = [
    (r"\b\d{2,3}\s*(mph|km/?h|kph)\b", "speed callout — speed may not be the payoff; posted footage is routinely the case file"),
    (r"\bstand[- ]?up\s+wheelie", "stand-up wheelie — Limited Ads tier on YouTube, squid-coded across ADV/cruiser/touring"),
    (r"\b(tag someone who|try this at home|dare you to|bet you can'?t)\b", "challenge/dare — Meta removes high-risk challenge imagery REGARDLESS of context"),
    (r"\b(crazy accident|lots of blood|brutal crash|gnarly wreck)\b", "shock-bait titling — named removal trigger on YouTube"),
    (r"\b(dpf|egr)\s*delete\b|\bcatless\s+downpipe\b|\bdefeat\s+tune\b", "emissions-defeat content — EPA fines under the Clean Air Act"),
    (r"\bi\s+(was|were)\s+doing\s+\d{2,3}\b", "first-person admission of an offence — charging aid and insurance-coverage-denial aid"),
]

# --- Marketing tells ---------------------------------------------------------
BANNED = [
    (r"\btag a friend\b", "generic engagement bait — TikTok eligibility issue, not a taste issue"),
    (r"\bfollow for more\b", "the marketing tell the audience is scanning for"),
    (r"\bcomment below\b", "generic CTA — a nitpickable detail outperforms an explicit CTA question"),
    (r"^\s*(hey guys|welcome back|what'?s up guys)", "self-introduction — anti-pattern without established brand equity"),
]

PLACEHOLDER = re.compile(r"\[(?:PLACEHOLDER|TODO|UNFILLED|TBD|XXX)[^\]]*\]", re.I)

# A statistic with no tier tag anywhere nearby.
STAT = re.compile(r"(?<![\w.])\d{1,3}(?:\.\d+)?\s*%")
TIER = re.compile(r"\[T[1-5][^\]]*\]|\bT[1-5]\b|working guidance", re.I)


def check(text: str) -> list[str]:
    errs: list[str] = []
    low = text.lower()

    for pat, why in KILL_LIST:
        m = re.search(pat, low, re.M)
        if m:
            errs.append(f"FABRICATED STAT  {m.group(0)!r} — {why}")

    for pat, why in RISK:
        m = re.search(pat, low, re.M)
        if m:
            errs.append(f"RISK  {m.group(0)!r} — {why}")

    for pat, why in BANNED:
        m = re.search(pat, low, re.M)
        if m:
            errs.append(f"BANNED  {m.group(0)!r} — {why}")

    for m in PLACEHOLDER.finditer(text):
        errs.append(f"PLACEHOLDER  unresolved {m.group(0)!r}")

    # Untiered percentages, checked per line so a tier tag on the same line counts.
    for i, line in enumerate(text.splitlines(), 1):
        if STAT.search(line) and not TIER.search(line):
            errs.append(
                f"UNTIERED STAT  line {i}: {line.strip()[:80]!r} — "
                "cite the tier inline, or do not state the number"
            )

    # Faceless credibility: sensory claims need footage that substantiates them.
    if re.search(r"\bfaceless\b|\bvoiceover\b|\bvo:\b", low):
        for pat in (r"\blisten to (that|this)\b", r"\byou can feel\b", r"\bi heard\b"):
            m = re.search(pat, low)
            if m:
                errs.append(
                    f"FABRICATION RISK  {m.group(0)!r} in a faceless script — "
                    "never write a sensory claim the footage cannot substantiate"
                )
    return errs


def targets_from_stdin() -> list[tuple[str, str]]:
    raw = sys.stdin.read().strip()
    if not raw:
        return []
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        return []
    ti = payload.get("tool_input") or {}
    path = ti.get("file_path") or ""
    content = ti.get("content") or ti.get("new_string") or ""
    return [(path, content)] if path else []


def in_scope(path: str) -> bool:
    return "/drafts/" in path.replace("\\", "/") or path.startswith("drafts/")


def main() -> int:
    pairs: list[tuple[str, str]] = []
    hook_mode = False

    if len(sys.argv) > 1:
        for p in sys.argv[1:]:
            try:
                pairs.append((p, Path(p).read_text(encoding="utf-8", errors="replace")))
            except OSError as exc:
                print(f"skip {p}: {exc}", file=sys.stderr)
    else:
        hook_mode = True
        pairs = targets_from_stdin()

    all_errs: list[str] = []
    for path, content in pairs:
        if hook_mode and not in_scope(path):
            continue
        for e in check(content):
            all_errs.append(f"{Path(path).name}: {e}")

    if all_errs:
        print("platform_check FAILED:", file=sys.stderr)
        for e in all_errs:
            print(f"  - {e}", file=sys.stderr)
        print(
            "\nFix these before writing. See craft/evidence-standards.md and "
            "niche/risk.md.", file=sys.stderr,
        )
        return 2

    if not hook_mode:
        print("platform_check: clean")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
