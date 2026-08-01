#!/usr/bin/env python3
"""Aggregate logged posts by pattern so the feedback loop answers WHY, not just WHETHER.

Compares the top and bottom performers on each tagged dimension (archetype,
hook pattern, trigger, tribe). Emits final markdown — it is injected into
SKILL.md via a !`cmd` block, and injected output is not re-scanned, so it cannot
emit another placeholder.

Metric per platform is fixed and not configurable, because the wrong denominator
makes the whole loop lie:
    tiktok  -> retention_rate
    reels   -> sends_per_reach
    shorts  -> engaged_views

Usage:
    perf_digest.py [--days 30] [--top 5] [--at 7d]
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from datetime import datetime, timedelta, timezone
from pathlib import Path

STORE =Path(__file__).resolve().parent.parent / "data" / "posts.json"

PRIMARY = {
    "tiktok": "retention_rate",
    "reels": "sends_per_reach",
    "shorts": "engaged_views",
}

DIMENSIONS = ["archetype", "hook_pattern", "trigger", "tribe", "surface"]


def load() -> list[dict]:
    if not STORE.exists():
        return []
    try:
        return json.loads(STORE.read_text()).get("posts", [])
    except json.JSONDecodeError:
        return []


def score(post: dict, at: str) -> float | None:
    metric = PRIMARY.get(post.get("platform", ""))
    if not metric:
        return None
    snaps = post.get("snapshots") or {}
    # Prefer the requested window, fall back to the latest available.
    for key in (at, "30d", "7d", "24h", "1h"):
        if key in snaps and metric in snaps[key]:
            return float(snaps[key][metric])
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--days", type=int, default=30)
    ap.add_argument("--top", type=int, default=5)
    ap.add_argument("--at", default="7d")
    a = ap.parse_args()

    posts = load()
    if not posts:
        print("_No performance data logged yet. Scripting proceeds on craft alone; "
              "the loop starts once `log_post.py --snapshot` has real numbers in it._")
        return 0

    cutoff = datetime.now(timezone.utc) - timedelta(days=a.days)
    recent = []
    for p in posts:
        try:
            ts = datetime.strptime(p["logged_at"], "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
        except (KeyError, ValueError):
            continue
        if ts >= cutoff:
            recent.append(p)

    scored = [(p, s) for p in recent if (s := score(p, a.at)) is not None]
    if not scored:
        print(f"_{len(recent)} posts logged in the last {a.days}d, none with "
              f"engagement snapshots yet. Run `log_post.py --snapshot <id> --at {a.at} "
              f"--metric ...` to make them answerable._")
        return 0

    # Per-platform, since the metrics are not comparable across platforms.
    by_platform: dict[str, list[tuple[dict, float]]] = defaultdict(list)
    for p, s in scored:
        by_platform[p["platform"]].append((p, s))

    for platform, rows in sorted(by_platform.items()):
        rows.sort(key=lambda r: r[1], reverse=True)
        metric = PRIMARY[platform]
        print(f"**{platform}** — ranked on `{metric}` at {a.at}, {len(rows)} posts")
        for p, s in rows[: a.top]:
            bits = " · ".join(
                str(p.get(d)) for d in ("archetype", "hook_pattern", "trigger") if p.get(d)
            )
            print(f"- `{s:g}` {bits or '(untagged)'} — {p.get('particular', '')[:60]}")

        if len(rows) >= 4:
            n = max(1, len(rows) // 4)
            top, bottom = rows[:n], rows[-n:]
            print(f"\n  _Top {n} vs bottom {n}:_")
            for dim in DIMENSIONS:
                t = {str(p.get(dim)) for p, _ in top if p.get(dim)}
                b = {str(p.get(dim)) for p, _ in bottom if p.get(dim)}
                only_top = t - b
                if only_top:
                    print(f"  - `{dim}`: {', '.join(sorted(only_top))} appears only in the top")
        print()

    untagged = sum(1 for p, _ in scored if not p.get("archetype"))
    if untagged:
        print(f"_{untagged} scored posts are untagged — their numbers cannot be "
              f"attributed to anything. Tag at pass 8._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
