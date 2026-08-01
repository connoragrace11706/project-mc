#!/usr/bin/env python3
"""Register linter: measures the DISTRIBUTION of a draft, not its vocabulary.

Register regression is a distributional failure. A draft can satisfy every
stated rule and still read as machine-written because the statistics of the
prose are wrong. Variance collapse is the strongest measurable tell and the only
one that is reliably scriptable.

Advisory. Prints a report; always exits 0. The hard gate is platform_check.py.

Usage:
    register_lint.py <file>...
    cat draft.md | register_lint.py -
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from statistics import mean, pstdev

# PLACEHOLDER thresholds, calibrated to the niche research rather than to Sam.
# Recalibrate against voice/corpus.md once it has real entries — the linter
# should be measuring HIS distribution, not a generic one.
THRESHOLDS = {
    "sentence_len_stdev": (4.0, "at least", "variance collapse — the strongest AI tell"),
    "opener_diversity": (0.70, "at least", "too many sentences start the same way"),
    "proper_nouns_per_100": (2.0, "at least", "too few named things — likely topic-swappable"),
    "numerals_per_100": (1.5, "at least", "no numbers; automotive scripts should be dense with them"),
    "em_dash_per_200": (1.0, "at most", "em-dash overuse"),
    "max_sentence_len": (28.0, "at most", "too long for spoken delivery"),
}

# Spoken scripts spell numbers out. Counting only digits undercounts specificity
# badly on exactly the copy this linter exists to measure.
SPELLED_NUMBERS = r"""\b(?:
    zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|
    thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|
    twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety|
    hundred|thousand|million|billion|
    half|quarter|third|double|triple|dozen
)\b"""

BANNED_OPENERS = [
    "hey guys", "welcome back", "in this video", "today i'm going to",
    "today i am going to", "what's up guys", "hey everyone",
]

BANNED_PHRASES = [
    "game-changer", "game changer", "you won't believe", "this changes everything",
    "let me tell you", "tag a friend", "follow for more", "comment below",
    "buckle up", "dive into", "leverage", "utilize", "delve",
]

# First-person sensory claims — fabrication risk in a faceless script.
SENSORY = [
    r"\blisten to (that|this)\b", r"\byou can feel\b", r"\bi heard\b",
    r"\bfeel that\b", r"\bhear that\b",
]

STAGE_DIRECTION = re.compile(r"^\s*[\[(](?:B-ROLL|SHOT|CUT|VO|ON SCREEN|TEXT)", re.I)


def read(path: str) -> str:
    if path == "-":
        return sys.stdin.read()
    return Path(path).read_text(encoding="utf-8", errors="replace")


def spoken_lines(text: str) -> str:
    """Strip markdown chrome and stage directions so we measure the delivered words."""
    out = []
    for line in text.splitlines():
        if line.startswith("#") or line.startswith("---") or line.startswith("|"):
            continue
        if STAGE_DIRECTION.match(line):
            continue
        out.append(line)
    body = "\n".join(out)
    body = re.sub(r"`[^`]*`", " ", body)
    body = re.sub(r"[*_>]", "", body)
    return body


def sentences(text: str) -> list[str]:
    parts = re.split(r"(?<=[.!?])\s+|\n{2,}", text)
    return [p.strip() for p in parts if len(p.strip().split()) >= 2]


def analyse(text: str) -> dict:
    body = spoken_lines(text)
    sents = sentences(body)
    words = re.findall(r"[A-Za-z0-9'\-]+", body)
    n_words = len(words) or 1

    lengths = [len(s.split()) for s in sents]
    openers = [" ".join(s.split()[:2]).lower() for s in sents]

    # Proper nouns: capitalised tokens not at sentence start, plus alphanumeric
    # model/engine codes (2JZ, E46, ZX-4RR, R1300GSA).
    proper = len(re.findall(r"(?<![.!?]\s)(?<!^)\b[A-Z][a-z]{2,}\b", body))
    proper += len(re.findall(r"\b(?=[A-Za-z]*\d)(?=[\dA-Za-z\-]*[A-Za-z])[A-Z0-9][A-Z0-9\-]{1,9}\b", body))
    numerals = len(re.findall(r"\b\d[\d,.]*\b", body))
    numerals += len(re.findall(SPELLED_NUMBERS, body, re.I | re.X))

    low = body.lower()
    return {
        "sentences": len(sents),
        "words": n_words,
        "sentence_len_mean": round(mean(lengths), 1) if lengths else 0.0,
        "sentence_len_stdev": round(pstdev(lengths), 2) if len(lengths) > 1 else 0.0,
        "max_sentence_len": float(max(lengths)) if lengths else 0.0,
        "opener_diversity": round(len(set(openers)) / len(openers), 2) if openers else 1.0,
        "proper_nouns_per_100": round(proper * 100 / n_words, 1),
        "numerals_per_100": round(numerals * 100 / n_words, 1),
        "em_dash_per_200": round(body.count("—") * 200 / n_words, 2),
        "colon_per_200": round(body.count(":") * 200 / n_words, 2),
        "banned_openers": [b for b in BANNED_OPENERS if low.lstrip().startswith(b) or f"\n{b}" in low],
        "banned_phrases": [b for b in BANNED_PHRASES if b in low],
        "sensory_claims": [m.group(0) for p in SENSORY for m in re.finditer(p, low)],
    }


def report(path: str, m: dict) -> None:
    print(f"\n\033[1m{path}\033[0m  ({m['words']} words, {m['sentences']} sentences)")
    fails = []
    for key, (limit, direction, why) in THRESHOLDS.items():
        val = m[key]
        ok = val >= limit if direction == "at least" else val <= limit
        mark = " ok " if ok else "FAIL"
        print(f"  [{mark}] {key:<24} {val:>7}   ({direction} {limit} — {why})")
        if not ok:
            fails.append(key)

    for label, items in (
        ("banned opener", m["banned_openers"]),
        ("banned phrase", m["banned_phrases"]),
        ("first-person sensory claim", m["sensory_claims"]),
    ):
        for it in items:
            print(f"  [FAIL] {label}: {it!r}")
            fails.append(label)

    print(f"  ---- mean sentence {m['sentence_len_mean']} words, "
          f"colons {m['colon_per_200']}/200w")

    if "sentence_len_stdev" in fails:
        print("  \033[33mNOTE\033[0m Fix variance by rewriting, not by inserting a short "
              "sentence. Uniform length is the tell; a token fix does not remove it.")
    if any(k in fails for k in ("proper_nouns_per_100", "numerals_per_100")):
        print("  \033[33mNOTE\033[0m Low specificity. Run the topic-swap test in "
              "craft/ai-tells.md: could this narration sit under different footage?")
    if not fails:
        print("  \033[32mclean\033[0m")


def main() -> int:
    args = [a for a in sys.argv[1:] if a != "--json"]
    as_json = "--json" in sys.argv[1:]
    if not args:
        print(__doc__)
        return 0

    results = {}
    for path in args:
        try:
            metrics = analyse(read(path))
        except OSError as exc:
            print(f"skip {path}: {exc}", file=sys.stderr)
            continue
        results[path] = metrics
        if not as_json:
            report(path, metrics)

    if as_json:
        print(json.dumps(results, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
