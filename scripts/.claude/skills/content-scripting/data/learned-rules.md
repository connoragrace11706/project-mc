# Learned rules

**Machine-written. Append-only. Never hand-edit.**

Overrides `voice/rules.md` on conflict.

Populated by the reflection loop: after Sam edits a draft, compare
`{ORIGINAL}` vs `{EDITED}` vs `{SAM'S COMMENT}` and ask whether the delta
generalises.

## Reflection guardrails — keep these verbatim

Without these clamps, a reflection loop fills with noise inside a week.

- **Do not infer or assume rules beyond what's explicitly stated.**
- **Do not add rules based on implicit feedback.**
- **Do not overgeneralize.**
- **Do not generate a rule that is specific to this one post.**

If the edit does not clearly generalise, write nothing. A blank file is correct
until there is real signal in it.

## Format

```markdown
### YYYY-MM-DD — <one-line rule>
**Observed:** [what Sam changed, quoting both versions]
**Generalises because:** [why this is not post-specific]
**Supersedes:** [rule in voice/rules.md, or "none"]
```

---

*(empty)*
