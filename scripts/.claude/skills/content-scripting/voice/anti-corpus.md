# Anti-corpus

The **same content** as `corpus.md`, rewritten in generic-LLM register, paired.
The contrast does more work than either file alone — it shows the model exactly
what it is drifting toward.

## Status

**`[EMPTY — populate alongside corpus.md]`**

Each entry pairs by index with a `corpus.md` entry.

## Format

````markdown
<anti-example index="1" pairs-with="1">
[The same idea, written the way an LLM writes it by default. Do not
exaggerate it into a strawman — write the version that would plausibly pass
review, because that is the one that actually needs to be recognisable.]
</anti-example>

**What died:** [the specific thing lost — a rhythm, a concrete noun, a stake, a
piece of first-hand knowledge]
**Which tell:** [topic-swappable / variance collapse / hedged / hyperbolic /
generic vocabulary — cross-reference `craft/ai-tells.md`]
````

## A worked example of the pairing

Not from Sam's voice — a demonstration of what the contrast is supposed to
expose.

````
<example>
Torqued to spec. Clicked at seventy-six. Then I looked at the other three and
realised whoever did this last used an impact and just leaned on it.
</example>

<anti-example>
It's crucial to ensure your lug nuts are properly torqued to the manufacturer's
specification. Improper torquing can lead to a variety of serious issues that
compromise both safety and performance.
</anti-example>
````

**What died:** the number (76), the physical event (the click), the diagnosis
from evidence, the implied character of the previous mechanic. Four concrete
things replaced by one abstraction.

**Which tell:** topic-swappable — the anti-example works verbatim for brake
calipers, head bolts, or anything else with a torque spec. That is the
load-bearing test in `craft/ai-tells.md`.
