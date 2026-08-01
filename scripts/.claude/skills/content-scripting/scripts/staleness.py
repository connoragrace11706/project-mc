#!/usr/bin/env python3
"""Flag reference files whose last-verified date has rotted.

Platform mechanics rot in weeks to months. Niche culture rots in about a year.
Craft does not rot and carries no date. This script enforces that split.

Exit 1 if anything is past its window, so it can gate a session or a cron.

Usage:
    staleness.py [--days 90]
"""

from __future__ import annotations

import argparse
import re
from datetime import date, datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

WINDOWS = {
    "platforms": 90,   # mechanics rot fast
    "niche": 365,      # culture and policy rot slower
}

DATE_RE = re.compile(r"^last-verified:\s*(\d{4}-\d{2}-\d{2})", re.M)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--days", type=int, default=None,
                    help="override every window with a single value")
    a = ap.parse_args()

    today = date.today()
    stale, ok, undated = [], [], []

    for folder, default_window in WINDOWS.items():
        window = a.days if a.days is not None else default_window
        d = ROOT / folder
        if not d.is_dir():
            continue
        for f in sorted(d.glob("*.md")):
            if f.name.startswith("_"):
                continue
            m = DATE_RE.search(f.read_text(encoding="utf-8", errors="replace"))
            if not m:
                undated.append((folder, f.name))
                continue
            verified = datetime.strptime(m.group(1), "%Y-%m-%d").date()
            age = (today - verified).days
            (stale if age > window else ok).append((folder, f.name, m.group(1), age, window))

    for folder, name, when, age, window in ok:
        print(f"  ok    {folder}/{name:<20} verified {when} ({age}d, window {window}d)")

    for folder, name in undated:
        print(f"  ?     {folder}/{name:<20} NO last-verified field")

    for folder, name, when, age, window in stale:
        print(f"  STALE {folder}/{name:<20} verified {when} ({age}d, window {window}d)")

    if stale:
        print(f"\n{len(stale)} file(s) past their re-verification window.")
        print("Re-verify against PRIMARY sources only — platform newsrooms, help "
              "pages, transparency centers, published code. Never a search summary; "
              "see craft/evidence-standards.md. A policy page that renders empty is "
              "not a page that says nothing (some serve body text inside a JS payload).")
        return 1

    if undated:
        print(f"\n{len(undated)} file(s) missing a last-verified field. Add one, or "
              f"move the content to craft/ if it genuinely does not rot.")
    print("\nAll dated reference files are within window.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
