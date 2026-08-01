#!/usr/bin/env python3
"""Tag and log a draft so its performance is answerable later.

Untagged drafts break the feedback loop: performance data then answers WHETHER a
piece worked and never WHY. That is the failure mode of every content feedback
system in the prior art.

Usage:
    log_post.py --draft drafts/2026-07-31-lugnut.md \\
        --platform shorts --surface feed --goal engaged-views \\
        --archetype A --trigger 3 --hook-pattern macro-object \\
        --particular "over-torqued lug nut off my own wheel" \\
        --tribe truck-overland --provenance owned \\
        [--commercial] [--corpus-examples 3,7] [--debt-schedule "0-2 open / 5 pay"]

    log_post.py --snapshot <id> --at 24h --metric engaged_views=4210 \\
        --metric avg_pct_viewed=61

    log_post.py --list
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

STORE = Path(__file__).resolve().parent.parent / "data" / "posts.json"

# The only metrics worth logging per platform. The wrong denominator makes the
# whole loop lie.
ALLOWED = {
    "tiktok": {"retention_rate", "watched_full_video_rate", "avg_watch_time", "comments", "shares", "saves"},
    "reels": {"avg_watch_time", "likes_per_reach", "sends_per_reach", "reach", "comments"},
    "shorts": {"engaged_views", "viewed_vs_swiped_away", "avg_pct_viewed", "likes", "comments"},
}

FORBIDDEN = {
    "shorts": {
        "views": "raw Views is loop-inflated since 31 Mar 2025 and is not comparable "
                 "to itself across that date. Log engaged_views instead.",
    },
    "reels": {
        "likes": "log likes_per_reach, not raw counts — Mosseri's own framing is ratios.",
        "sends": "log sends_per_reach, not raw counts.",
    },
    "tiktok": {
        "views": "raw views tell you nothing about whether the piece held. Log retention_rate.",
    },
}


def load() -> dict:
    if STORE.exists():
        try:
            return json.loads(STORE.read_text())
        except json.JSONDecodeError:
            print(f"warning: {STORE} is malformed; starting fresh", file=sys.stderr)
    return {"version": 1, "posts": []}


def save(db: dict) -> None:
    STORE.parent.mkdir(parents=True, exist_ok=True)
    STORE.write_text(json.dumps(db, indent=2) + "\n")


def now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def platform_last_verified(platform: str) -> str:
    f = Path(__file__).resolve().parent.parent / "platforms" / f"{platform}.md"
    if not f.exists():
        return "unknown"
    for line in f.read_text().splitlines()[:10]:
        if line.startswith("last-verified:"):
            return line.split(":", 1)[1].strip()
    return "unknown"


def cmd_log(a: argparse.Namespace) -> int:
    if not a.particular:
        print("refusing: --particular is a hard gate. Without something that could "
              "only come from Sam, the piece is generic regardless of craft.",
              file=sys.stderr)
        return 1

    db = load()
    post = {
        "id": f"{datetime.now(timezone.utc):%Y%m%d}-{len(db['posts']) + 1:03d}",
        "logged_at": now(),
        "draft": a.draft,
        "platform": a.platform,
        "surface": a.surface,
        "goal_action": a.goal,
        "archetype": a.archetype,
        "trigger": a.trigger,
        "hook_pattern": a.hook_pattern,
        "debt_schedule": a.debt_schedule,
        "particular": a.particular,
        "tribe": a.tribe,
        "provenance": a.provenance,
        "commercial": a.commercial,
        "corpus_examples": [s.strip() for s in (a.corpus_examples or "").split(",") if s.strip()],
        "platform_file_last_verified": platform_last_verified(a.platform),
        "snapshots": {},
    }
    db["posts"].append(post)
    save(db)
    print(f"logged {post['id']}  ({a.platform} / {a.archetype} / trigger {a.trigger})")
    return 0


def cmd_snapshot(a: argparse.Namespace) -> int:
    db = load()
    post = next((p for p in db["posts"] if p["id"] == a.snapshot), None)
    if not post:
        print(f"no post {a.snapshot}", file=sys.stderr)
        return 1

    platform = post["platform"]
    metrics: dict[str, float] = {}
    for pair in a.metric:
        if "=" not in pair:
            print(f"bad --metric {pair!r}; expected key=value", file=sys.stderr)
            return 1
        k, v = pair.split("=", 1)
        k = k.strip()
        if k in FORBIDDEN.get(platform, {}):
            print(f"refusing metric {k!r} for {platform}: {FORBIDDEN[platform][k]}",
                  file=sys.stderr)
            return 1
        if k not in ALLOWED.get(platform, set()):
            print(f"warning: {k!r} is not a standard {platform} metric "
                  f"(expected one of {sorted(ALLOWED.get(platform, []))})", file=sys.stderr)
        try:
            metrics[k] = float(v)
        except ValueError:
            print(f"bad value for {k}: {v!r}", file=sys.stderr)
            return 1

    post["snapshots"].setdefault(a.at, {}).update(metrics)
    save(db)
    print(f"{a.snapshot} @ {a.at}: {metrics}")
    return 0


def cmd_list() -> int:
    db = load()
    if not db["posts"]:
        print("no posts logged")
        return 0
    for p in db["posts"]:
        snaps = ", ".join(sorted(p["snapshots"])) or "none"
        print(f"{p['id']}  {p['platform']:<7} {str(p.get('archetype')):<4} "
              f"{str(p.get('hook_pattern'))[:24]:<24} snapshots: {snaps}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--draft")
    ap.add_argument("--platform", choices=sorted(ALLOWED))
    ap.add_argument("--surface", default="feed")
    ap.add_argument("--goal")
    ap.add_argument("--archetype")
    ap.add_argument("--trigger")
    ap.add_argument("--hook-pattern", dest="hook_pattern")
    ap.add_argument("--debt-schedule", dest="debt_schedule")
    ap.add_argument("--particular")
    ap.add_argument("--tribe")
    ap.add_argument("--provenance")
    ap.add_argument("--commercial", action="store_true")
    ap.add_argument("--corpus-examples", dest="corpus_examples")
    ap.add_argument("--snapshot")
    ap.add_argument("--at", default="24h")
    ap.add_argument("--metric", action="append", default=[])
    ap.add_argument("--list", action="store_true")
    a = ap.parse_args()

    if a.list:
        return cmd_list()
    if a.snapshot:
        return cmd_snapshot(a)
    if a.draft and a.platform:
        return cmd_log(a)
    ap.print_help()
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
