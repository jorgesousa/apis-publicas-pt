---
name: portugal-open-data
description: Entry point for Portuguese and EU public data. Lists the verified sources (dados.gov.pt, INE, IPMA, Banco de Portugal, Parliament, Eurostat, ECB, data.europa.eu) with endpoint, auth, licence and limits, sets the rules for calling them, and routes to the domain skills (public procurement, territory, schools, local finance, council meetings, web archive, mobility, health, environment). Use when choosing, calling or citing open data about Portugal or the EU. Dados abertos de Portugal e da UE, APIs públicas, estatística, dados.gov.pt.
license: MIT
metadata:
  version: "2.0.0"
  verified: "2026-11-04"
---

# Portugal Open Data

The entry point to a set of skills for Portuguese (and EU) public data. This file holds the rules, the general-purpose sources and a map of the domain skills. Domain detail (fields, pitfalls, methods) lives in the domain skill, not here.

Official names stay in Portuguese (e.g. "Portal BASE", "População residente"): they are what the sources return and what people search for.

## Rules

1. **This skill gives no network access.** It only describes the sources. If the environment uses an allowlist of domains, access depends on it.
2. **Make one test call before building.** If the environment refuses the request (e.g. `CONNECT tunnel failed, response 403`, or a "domain not allowed" error), stop, tell the user the exact domain and wait for their decision. Do not work around it (other commands, mirrors, caches, proxies) and do not change network permissions.
3. **No credentials.** Every source here is readable without a key. If one starts asking for a key, ask the user; never put keys in URLs or in versioned files.
4. **Licence and attribution in every output.** Always show "Source: …" and the extraction date. On dados.gov.pt the licence is per dataset (`license` field); `notspecified` means confirm before publishing.
5. **Explicit reference year.** Official statistics lag (INE and Eurostat publish year N in N+1 or N+2). Never use "latest period" without checking it has values.
6. **Keep the raw data.** Download to a file (csv/json/parquet) and compute in code; do not page large results through the conversation.
7. **Before answering with numbers, run `pt-data-checks`** (reference years, units, coverage, licences).
8. **Personal data stays out.** Some open datasets list named people (professionals, members of the public in council minutes). Aggregate them; do not republish names and contacts for a new purpose.

## Which skill to use

| Question is about | Skill |
|---|---|
| Public contracts, tenders, suppliers, Portal BASE, TED | `pt-public-procurement` |
| Maps, municipalities, parishes, codes (DICO/DICOFRE, INE geography), CAOP, land registry | `pt-territory` |
| Schools, pupils, results "observed vs expected", InfoEscolas | `pt-schools` |
| Municipal revenue, expenditure, debt, budgets, transfers, IMI | `pt-local-finance` |
| Council meetings, minutes (atas), agendas, videos, OpenCouncil | `pt-council-meetings` |
| Old versions of Portuguese websites, Arquivo.pt | `pt-web-archive` |
| Public transport timetables (GTFS/NeTEx), bike sharing, EV charging, road/rail networks | `pt-mobility` |
| SNS activity, waiting times, medicines, emergency, health professionals | `pt-health` |
| Water, air quality, emissions, hydrology, civil protection | `pt-environment` |
| Checking a number before publishing it | `pt-data-checks` |

If a domain skill is not installed, use the sources below and dados.gov.pt search, and still apply the rules.

## Network: domains

If the environment uses an allowlist, ask only for the domains the task needs. General sources:

| Source | Domain |
|---|---|
| dados.gov.pt | `dados.gov.pt` |
| INE | `www.ine.pt` |
| IPMA | `api.ipma.pt` |
| Banco de Portugal | `bpstat.bportugal.pt` |
| Assembleia da República | `www.parlamento.pt`, `app.parlamento.pt` |
| Eurostat | `ec.europa.eu` |
| ECB | `data-api.ecb.europa.eu` |
| data.europa.eu | `data.europa.eu` |
| Open-Meteo | `api.open-meteo.com` |

Each domain skill lists its own extra domains.

## General sources

### dados.gov.pt — national open-data portal (udata API v1)
- **Endpoint:** `https://dados.gov.pt/api/1/` (Swagger: `/api/1/swagger.json`)
- **Auth:** none for reading. Writing needs `X-API-KEY` (out of scope).
- **Licence:** per dataset and sometimes per copy: the same data can appear twice, once `cc-by` and once `notspecified` (common for SNS datasets). Values seen: `cc-by`, `cc-by-sa`, `cc-zero`, `other-pd`, `other-open`, `other-at`, `notspecified`, `unknown`.
- **Limits:** not documented. Paginate with `page_size` and follow `next_page`.
- **Size (2026-11-03):** 20 983 datasets, 45 173 resources, 442 organisations, 6 registered data services. About two thirds (13 710) are INE indicators that link to the INE API; most of the rest are files, not APIs.
- **Useful calls:**
  ```bash
  curl -s "https://dados.gov.pt/api/1/datasets/?q=contratos%20publicos&page_size=5"     # search
  curl -s "https://dados.gov.pt/api/1/datasets/{slug}/"                                 # resources[].url = files
  curl -s "https://dados.gov.pt/api/1/organizations/?q=INFARMED"                         # find an organisation
  curl -s "https://dados.gov.pt/api/1/datasets/?organization={org_id}&sort=-views"      # its datasets
  curl -s "https://dados.gov.pt/api/1/dataservices/"                                     # registered APIs
  ```
- **Pitfalls:** many datasets are harvested from other portals (INE, Transparência SNS, municipal CKANs, DGT), so the file URL points elsewhere and needs that domain; `last_update` is the catalogue record, not always the data; several "national" datasets are old snapshots (e.g. "Concelhos de Portugal", 2018) — check the date.

### INE — Statistics Portugal
- **Endpoint:** data `https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd={code}&lang=PT|EN&Dim1=…&Dim2=…`; metadata `https://www.ine.pt/ine/json_indicador/pindicaMeta.jsp?varcd={code}&lang=PT|EN`
- **Auth:** none.
- **Licence:** INE indicators on dados.gov.pt are `cc-by`; cite "Source: INE" and the indicator code.
- **Limits:** none published; large indicators return huge responses → always filter by `Dim1` (period, e.g. `S7A2023`) and `Dim2` (geography, e.g. `11A0104` = Arouca, `16E0603` = Coimbra; see `pt-territory` for codes). Read the metadata call first: it gives dimensions, unit and last period.
- **Response:** list with `IndicadorCod`, `IndicadorDsg`, `DataUltimoAtualizacao`, `UltimoPref` (latest period) and `Dados{year:[{geocod, geodsg, dim_3, dim_4, valor}]}`.
- **Useful indicator:** `0008273` resident population by municipality, sex and age (latest: 2023). Municipal finance indicators are in `pt-local-finance`.
- **Pitfalls:** finding a code: search dados.gov.pt (`q=` the indicator name) — INE records there carry the JSON links. Since 2021 the annual population is an estimate on an administrative basis, so 2021 estimate ≠ Census 2021.
- **Example:**
  ```bash
  curl -s "https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0008273&Dim1=S7A2023&Dim2=11A0104&Dim3=T&Dim4=T&lang=PT"   # Arouca: 21 360
  ```

### IPMA — weather, warnings, earthquakes, fire risk
- **Endpoint:** `https://api.ipma.pt/open-data/`
- **Auth:** none. IPMA asks users to email webmaster@ipma.pt describing their use.
- **Licence/terms:** free for personal or public use **without profit**; cite the source; logo with link on web pages. ⚠ A commercial product needs permission or another source.
- **Limits:** not published. Forecasts twice a day (00 and 12 UTC); hourly observations; times in UTC; `-99.0` = no data.
- **Useful endpoints:** `forecast/meteorology/cities/daily/{globalIdLocal}.json` (5 days), `forecast/warnings/warnings_www.json`, `observation/seismic/{3|7}.json` (3 = Azores, 7 = mainland and Madeira), `forecast/meteorology/rcm/rcm-d{0..2}.json` (fire risk). Location ids in `distrits-islands.json`.
- **Example (Coimbra, globalIdLocal 1060300):** `curl -s "https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/1060300.json"`

### Banco de Portugal — BPstat
- **Endpoint:** `https://bpstat.bportugal.pt/data/v1`
- **Auth:** none.
- **Licence:** ESCB statistics — free reuse, including commercial, citing the source and without altering the data (confirm it applies to BPstat before publishing).
- **Limits:** not published. Pagination in `extension.next_page`.
- **Endpoints:** `/domains`, `/domains/{d}/datasets`, `/domains/{d}/datasets/{ds}` (observations, JSON-stat), `/series`. Parameters: `lang`, `series_ids`, `obs_since`, `obs_to`, `obs_last_n`.
- **Example:** `curl -s "https://bpstat.bportugal.pt/data/v1/domains/?lang=EN"`

### Assembleia da República — parliament open data
- **What:** XML and JSON files per theme and legislature: Iniciativas, Atividades, Intervenções, Diário da AR, Registo Biográfico, Composição de Órgãos, Petições, Perguntas e Requerimentos, Orçamento do Estado, Agenda Parlamentar.
- **Endpoint:** listing at `https://www.parlamento.pt/Cidadania/Paginas/DadosAbertos.aspx` (each theme has its own page with file links). No official API.
- **Auth:** none. **Licence:** free reuse, attribution to the Assembleia da República required.
- **Pitfalls:** server slow around 04:00–06:00 Lisbon time; files can return an HTML "Recurso Não Encontrado" page instead of data — validate before overwriting a good copy.
- **Community mirror:** github.com/rfsbraz/parlamento-aberto (Parquet/CSV, CC BY 4.0, personal tax numbers masked). `api.openar.pt` was archived in August 2026 — do not build on it.

### Eurostat — Statistics API
- **Endpoint:** `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/{dataset}?{filters}` (JSON-stat 2.0).
- **Auth:** none. **Licence:** free reuse incl. commercial (Decision 2011/833/EU); cite and state changes.
- **Limits:** none published; large requests → asynchronous endpoint. Updated 11:00 and 23:00 CET.
- **Pitfall:** `lastTimePeriod=1` can return an **empty** latest year (`value: {}`). Request a range and pick the last year with values.
- **Example:** `curl -s "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_r_pjanaggr3?geo=PT16D&sex=T&age=TOTAL&sinceTimePeriod=2020"`

### European Central Bank — ECB Data Portal
- **Endpoint:** `https://data-api.ecb.europa.eu/service/data/{flowRef}/{key}` (SDMX 2.1 REST)
- **Auth:** none. **Licence:** free reuse incl. commercial; cite "Source: ECB statistics"; do not alter the data.
- **Example (daily USD/EUR):** `curl -s "https://data-api.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?startPeriod=2026-01-01&format=csvdata"`

### data.europa.eu — European data portal (to verify)
- Aggregates national portals (including dados.gov.pt). Search at `https://data.europa.eu/api/hub/search/search?q=…`. Licence per dataset. Responds; query syntax and fields not yet checked.

### Open-Meteo — global weather (alternative to IPMA)
- **Endpoint:** `https://api.open-meteo.com/v1/forecast?latitude=…&longitude=…`
- **Licence/limits:** non-commercial only (600/min, 10 000/day); CC BY 4.0. Commercial use = paid plan.

## Adding a source
A source joins with: a tested endpoint (or marked "to verify"), auth, licence with a link, limits (or "not published"), an example call and the verification date. Domain sources go in their domain skill; only general-purpose sources go here.
