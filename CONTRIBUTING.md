# Contributing to Portugal Open Data

Thank you for helping. You do not need to be a programmer: most contributions are a few lines of text about a source you know. English or Portuguese, both are fine.

## Ways to help

| Time | What | How |
|---|---|---|
| 5 min | Report a source that broke, moved or changed | [Open an issue](../../issues/new/choose) → "Broken or wrong" |
| 15 min | Verify an entry marked "to verify" | Test it, edit the skill, open a pull request |
| 1 hour | Add a source to an existing skill | Follow "Adding a source" below |
| 1 hour | Add a trap you know ("this field is always empty", "this unit changed in 2022") | Add it to the skill's "Traps" list with the date you checked |
| A weekend | Write a new domain skill | Start from [docs/skill-template.md](docs/skill-template.md); see the Roadmap in the README |

## Rules for every source

A source joins only with:

1. **A tested endpoint** — the exact URL you called and what came back. If you could not test it, mark it **to verify**.
2. **Auth** — "none", or exactly what is needed. Never commit keys.
3. **Licence**, with a link to the terms. On dados.gov.pt the licence is per dataset: copy the `license` field.
4. **Limits** — rate limits, size, update frequency, or "not published".
5. **An example call** that works.
6. **The date** you checked it (`YYYY-MM-DD`).

Domain sources go in their domain skill. Only general-purpose sources go in `skills/portugal-open-data/SKILL.md`.

## Rules for every trap

- Say what goes wrong, why, and what to do instead.
- Back it with something checkable: a count, a field name, a file name, a date. "In the 2026 file, 8% of contracts have `PrecoTotalEfetivo`" is useful; "this field is unreliable" is not.
- Present patterns as patterns. Never accuse a named body or person.

## Rules for every skill

- One domain per skill; folder name = `name` in the frontmatter, lowercase with hyphens, prefixed `pt-`.
- `description` under 1024 characters: what it covers and when to use it, ending with Portuguese keywords people will type.
- `SKILL.md` under 500 lines. Long tables (field lists, sheet lists) go in `references/`.
- Text only: no scripts the agent must run, no dependencies, no credentials.
- Add the skill's domains to its "Domains used" line and, if there is a stable test URL, to `scripts/check-endpoints.sh`.
- Personal data: never republish names and contacts of private people, even from an open dataset.

## Before you open a pull request

```bash
python3 scripts/validate-skills.py   # names, lengths, links, references between skills
./scripts/check-endpoints.sh         # every source still answers
./scripts/build-zip.sh               # rebuild dist/ for claude.ai
```

Then bump `metadata.version` and `metadata.verified` in the skills you changed.

## Code of conduct

Be kind and specific. Disagree with data, not with people. Maintainers may remove comments or contributions that are abusive or that expose private individuals.

---

### Em português

Toda a ajuda conta, e não precisas de programar: a maior parte das contribuições são umas linhas sobre uma fonte que conheces. Reporta uma fonte partida, verifica uma entrada marcada "to verify", acrescenta uma armadilha que conheces (com a data em que a viste) ou escreve uma skill nova a partir de [docs/skill-template.md](docs/skill-template.md). Antes do pull request corre os três comandos acima. Escreve em português ou em inglês, como preferires.
