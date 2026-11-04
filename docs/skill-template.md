# Skill template

Copy this into `skills/pt-<domain>/SKILL.md`, replace everything in angle brackets, delete what does not apply, and run `python3 scripts/validate-skills.py`.

````markdown
---
name: pt-<domain>
description: <What data this covers and where it comes from, in one or two sentences.> Use for <the questions people ask>. <Portuguese keywords, comma-separated.>
license: MIT
metadata:
  version: "1.0.0"
  verified: "<YYYY-MM-DD>"
---

# <Domain> in Portugal

Part of the `portugal-open-data` skills. <Two or three sentences: who publishes the data, in what shape, and the one thing to know first.>

**Domains used:** `<host>`, `<host>`.

## Sources

| Source | What | Format | Licence | Status |
|---|---|---|---|---|
| <Name> | <What you get> | <API / CSV / XLSX / PDF> | <licence + link> | verified <date> / to verify |

<For each important source: endpoint, auth, limits, one example call.>

```bash
curl -s "<a call that works>"
```

## Traps
1. **<Short name>.** <What goes wrong, with a number or field name, and what to do instead.>
2. ...

## Method for "<a typical question>"
1. <Get the data>
2. <Join / clean, naming the keys>
3. <Compute and compare fairly>
4. Run `pt-data-checks`. Footer: "Source: <source>, <licence>, extracted YYYY-MM-DD".
````
