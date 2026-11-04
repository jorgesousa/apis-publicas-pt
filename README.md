<div align="center">

# portugal-open-data

**Portugal's public data, ready for your AI agent.**

Eleven skills for Claude, Claude Code and other agents that read `SKILL.md`: an entry point to Portuguese and EU open-data sources, nine domain skills that know where each kind of data lives and where it lies, and a checklist that stops the agent from publishing a misleading number.

[![License: MIT](https://img.shields.io/badge/license-MIT-2fa36b)](LICENSE)
[![Verified](https://img.shields.io/badge/verified-2026--11--04-2fa36b)](skills/portugal-open-data/SKILL.md)
[![Endpoints](https://github.com/jorgesousa/portugal-open-data/actions/workflows/check-endpoints.yml/badge.svg)](https://github.com/jorgesousa/portugal-open-data/actions/workflows/check-endpoints.yml)

<img src="docs/demo.gif" alt="Demo recorded with version 1: finding the INE source for municipal population, checking a draft chart before publishing, and finding the videos and minutes of Matosinhos council meetings" width="860">

<sub>Demo recorded with version 1 (three skills, old names).</sub>

**[Leia em português](README.pt.md)**

</div>

---

## The skills

| Skill | What it covers |
|---|---|
| [`portugal-open-data`](skills/portugal-open-data/SKILL.md) | **Start here.** Rules for calling public sources, the general ones (dados.gov.pt, INE, IPMA, Banco de Portugal, Parliament, Eurostat, ECB) and which domain skill to use. |
| [`pt-data-checks`](skills/pt-data-checks/SKILL.md) | Eight checks before publishing a number: reference years, units, what it measures, gaps, outliers, duplicated entities, fair comparison, licence. |
| [`pt-public-procurement`](skills/pt-public-procurement/SKILL.md) | Portal BASE contracts, notices, modifications and entities; TED. Field meanings and fill rates, signing year vs publication date, suppliers by tax number. |
| [`pt-territory`](skills/pt-territory/SKILL.md) | CAOP boundaries, municipality and parish codes, NUTS, the 2025 parish restoration, projections, BUPi. |
| [`pt-schools`](skills/pt-schools/SKILL.md) | InfoEscolas files for every school: "observed vs expected" for pupils of a similar profile, retention, internal grades, equity. |
| [`pt-local-finance`](skills/pt-local-finance/SKILL.md) | Municipal revenue, expenditure and debt (INE/DGAL), budgets, transfers, IMI — and why contracts are not spending. |
| [`pt-council-meetings`](skills/pt-council-meetings/SKILL.md) | Council meetings: OpenCouncil's public MCP, official minutes and videos, transcription, CNPD privacy rules, OParl. |
| [`pt-web-archive`](skills/pt-web-archive/SKILL.md) | Arquivo.pt: full-text search and version history of Portuguese websites since 1996. |
| [`pt-mobility`](skills/pt-mobility/SKILL.md) | GTFS and NeTEx timetables by operator, bike sharing, EV charging, road and rail networks. |
| [`pt-health`](skills/pt-health/SKILL.md) | Transparência SNS, ACSS, INFARMED, INEM; duplicate copies with different licences; lists of professionals as personal data. |
| [`pt-environment`](skills/pt-environment/SKILL.md) | APA water and air data, emissions, flood risk, rural fires, civil protection. |

The entry point routes, the domain skills go deep, and the checklist makes the answer honest. Each skill loads only when a request needs it, so installing all of them costs nothing until they are used.

## Why

The best-known API list on GitHub, [public-apis](https://github.com/public-apis/public-apis), has 2,000+ entries and almost nothing for Portugal. [devpt-org/public-data-portugal](https://github.com/devpt-org/public-data-portugal) lists 57 Portuguese sources, as links. Neither tells your agent:

- whether a source needs a key, and whether you may use it in a commercial product;
- that INE's municipal finance figures are in **thousands** of euros;
- that the `Ano` field in Portal BASE is the year a contract was **signed**, not published, and that the price actually paid is filled in for only 8% of contracts;
- that school results only make sense compared with pupils of a **similar profile**, and that `*` means suppressed, not zero;
- that a GTFS feed can expire next week, or that a list of psychologists with an open licence is still personal data.

That is what these skills carry. Every pitfall comes from real work, with the date it was checked.

## Install

### Claude Code (plugin)
```
/plugin marketplace add jorgesousa/portugal-open-data
/plugin install portugal-open-data@portugal-open-data
```
The skills then appear as `portugal-open-data:pt-schools`, `portugal-open-data:pt-public-procurement`, and so on.

### claude.ai (web, desktop, mobile)
1. Download the zips from [`dist/`](dist/) — one per skill. Start with `portugal-open-data.zip` and `pt-data-checks.zip`, then add the domains you need.
2. Upload them in the skills section of your claude.ai settings.
3. If your plan restricts network access, allow the domains each skill lists.

### Other agents (`skills` CLI: Cursor, Codex and others)
```bash
npx skills add jorgesousa/portugal-open-data
```

### By hand
```bash
git clone https://github.com/jorgesousa/portugal-open-data.git
mkdir -p ~/.claude/skills && cp -r portugal-open-data/skills/* ~/.claude/skills/
```

## Try it

Ask in English or Portuguese:

- "What was Coimbra's resident population in 2023? Cite the source."
- "Which suppliers got the most from Arouca council in 2025? Join them by tax number."
- "Compare the secondary schools in Coimbra fairly."
- "How much does Braga council owe per resident, compared with similar municipalities?"
- "What did the Coimbra council website say about the Metro Mondego in 2015?"
- "How many bus departures does this parish get on a weekday?"
- "Can I use IPMA weather data in a paid app?"

## Network

The skills make no requests themselves: they tell the agent where and how to ask. Each skill lists the domains it uses. If a domain is blocked, the agent is told to stop and name it, never to get around the block.

## Principles

- **Text only.** Each skill is a `SKILL.md`, sometimes with a reference file. No scripts to run, no dependencies, no keys.
- **Licences up front.** Every answer cites source, licence and extraction date.
- **Honest about gaps.** Anything untested is marked "to verify".
- **No personal data.** Aggregate lists of named people; never republish them for a new purpose.

## Keeping it current

- **Weekly check:** a [GitHub Actions workflow](.github/workflows/check-endpoints.yml) calls every endpoint on Mondays. Run `./scripts/check-endpoints.sh` locally.
- **Validation:** `python3 scripts/validate-skills.py` checks names, descriptions, lengths and links; it runs on every pull request.
- **Verification date:** each skill carries `metadata.verified`. Re-check anything older than six months before relying on it.

## Contributing

A source joins only with a tested endpoint (or marked "to verify"), auth, licence with a link to the terms, limits (or "not published"), an example call and the verification date. Domain sources go in their domain skill; general ones in `portugal-open-data`. After editing, run `python3 scripts/validate-skills.py` and `./scripts/build-zip.sh`.

## Layout

```
.claude-plugin/            plugin and marketplace manifests
skills/<name>/SKILL.md     one folder per skill (some with references/)
dist/*.zip                 the same skills, one zip each, for claude.ai
scripts/                   endpoint check, skill validator, zip builder
.github/workflows/         weekly endpoint check and pull-request validation
docs/                      README images
README.pt.md               Portuguese README
```

## Changes from `apis-publicas-pt`

Version 2.0.0 renames the project and splits the old catalog into an entry point and domain skills. `apis-publicas-pt` → `portugal-open-data`, `verificar-dados-publicos` → `pt-data-checks`, `reunioes-municipais-pt` → `pt-council-meetings`. If you installed the old zips, remove them and install the new ones.

## License

[MIT](LICENSE) © 2026 [Jorge Sousa](https://github.com/jorgesousa)

Not affiliated with any of the sources listed. The data belongs to each source and follows its own terms.
