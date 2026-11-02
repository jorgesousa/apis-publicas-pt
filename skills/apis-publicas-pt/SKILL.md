---
name: apis-publicas-pt
description: Curated catalog of Portuguese and EU public-data APIs (dados.gov.pt, INE, IPMA, Banco de Portugal, Eurostat, ECB, TED, Parliament, local councils) with endpoint, auth, licence, limits and a working example. Use when choosing, calling or citing open data about Portugal or the EU. Catálogo de APIs públicas de Portugal e da UE (dados abertos, câmaras municipais, estatística, meteorologia, contratos públicos).
license: MIT
metadata:
  version: "1.2.0"
  verified: "2026-11-02"
---

# Public APIs for Portugal and the EU

A short, verified catalog of open-data sources for Portugal and the European Union. The value is the curation (licence, limits, pitfalls), not the count. For anything missing here, search the dados.gov.pt catalog first, then github.com/public-apis/public-apis (which has almost no Portuguese or EU statistical sources).

Last verified: 2026-11-02. Re-verify any entry older than six months before building on it.

Official names stay in Portuguese (e.g. "Portal BASE", "População residente"): they are what the APIs return and what people search for.

## Rules

1. **This skill gives no network access.** It only describes the APIs. If the environment uses an allowlist of domains, access depends on it.
2. **Make one test call before building.** If the environment refuses the request (e.g. `CONNECT tunnel failed, response 403`, or a "domain not allowed" error), stop, tell the user the exact domain and wait for their decision. Do not work around it (other commands, mirrors, caches, proxies) and do not change network permissions.
3. **No credentials.** Every source here is readable without a key. If one starts asking for a key, ask the user; never put keys in URLs or in versioned files.
4. **Licence and attribution in every output.** Always show "Source: …" and the extraction date. On dados.gov.pt the licence is per dataset (`license` field); `notspecified` means confirm before publishing.
5. **Explicit reference year.** Official statistics lag (INE and Eurostat publish year N in N+1 or N+2). Never use "latest period" without checking it has values.
6. **Keep the raw data.** Download to a file (csv/json/parquet) and compute in code; do not page large results through the conversation.
7. **Before answering with numbers, run the checks** in the `verificar-dados-publicos` skill if it is installed (reference years, units, coverage, licences).

## Network: domains used

If the environment uses an allowlist, these are the domains this catalog needs (ask the user only for the ones the task requires):

| Source | Domain |
|---|---|
| dados.gov.pt | `dados.gov.pt` |
| INE | `www.ine.pt` |
| IPMA | `api.ipma.pt` |
| Banco de Portugal | `bpstat.bportugal.pt` |
| GeoAPI.pt | `json.geoapi.pt` |
| Assembleia da República | `www.parlamento.pt`, `app.parlamento.pt` |
| OpenCouncil Portugal | `pt.opencouncil.eu` |
| Eurostat | `ec.europa.eu` |
| ECB | `data-api.ecb.europa.eu` |
| TED | `api.ted.europa.eu` |
| data.europa.eu | `data.europa.eu` |
| Open-Meteo | `api.open-meteo.com` |

## Portugal

### dados.gov.pt — national open-data portal (udata API v1)
- **Endpoint:** `https://dados.gov.pt/api/1/` (Swagger: `/api/1/swagger.json`)
- **Auth:** none for reading. Writing needs `X-API-KEY` (out of scope).
- **Licence:** per dataset (`license`: `cc-by`, `other-pd`, `other-open`, `notspecified`, …).
- **Limits:** not documented. Paginate with `page`, `page_size` and `next_page` (follow the `next_page` URL; do not compute pages).
- **Good for:** public contracts (Portal BASE/IMPIC, yearly files, `other-pd` = public domain), municipal and agency datasets, and discovering INE indicators (many INE datasets here link straight to the INE JSON API).
- **Example:**
  ```bash
  curl -s "https://dados.gov.pt/api/1/datasets/?q=contratos%20publicos&page_size=5"
  curl -s "https://dados.gov.pt/api/1/datasets/contratos-publicos-portal-base-impic-contratos-de-2012-a-2026/"   # resources[].url = files to download
  ```

### INE — Statistics Portugal
- **Endpoint:** data `https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd={code}&lang=PT|EN&Dim1=…&Dim2=…`; metadata `https://www.ine.pt/ine/json_indicador/pindicaMeta.jsp?varcd={code}&lang=PT|EN`
- **Auth:** none.
- **Licence:** INE indicators republished on dados.gov.pt are tagged `cc-by`; cite "Source: INE" and the indicator code.
- **Limits:** none published; large indicators return huge responses → always filter by `Dim1` (period, e.g. `S7A2023`) and `Dim2` (geography, e.g. municipality code `11A0104` = Arouca, `16E0603` = Coimbra). Read the metadata call first: it gives dimensions, unit and last period.
- **Response:** list with `IndicadorCod`, `IndicadorDsg`, `DataUltimoAtualizacao`, `UltimoPref` (latest period) and `Dados{year:[{geocod, geodsg, dim_3, dim_4, valor}]}`.
- **Useful indicators:**
  - `0008273` resident population by municipality, sex and age (latest: 2023).
  - `0013908` municipal council **revenue** (€) by economic classification — source DGAL (latest: 2023).
  - `0013909` municipal council **expenditure** (€) by economic classification — source DGAL (2021–2023).
- **Pitfalls (verified):** the DGAL finance indicators are in **thousands of euros** (power of 10 = 3) and on a **cash basis**; the latest year is flagged "Dado preliminar"; some municipalities are missing in some years (e.g. Penedono, marked "dado não disponível").
- **Example:**
  ```bash
  curl -s "https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0008273&Dim1=S7A2023&Dim2=11A0104&Dim3=T&Dim4=T&lang=PT"   # Arouca: 21 360
  curl -s "https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0013908&Dim2=11A0104&lang=PT"                             # Arouca revenue 2023: 23 754 (thousand €)
  ```

### IPMA — weather, warnings, earthquakes, fire risk
- **Endpoint:** `https://api.ipma.pt/open-data/`
- **Auth:** none. IPMA asks users to email webmaster@ipma.pt describing their use (internal statistics).
- **Licence/terms:** free for personal or public use **without profit**; always cite the source; logo with link on web pages. ⚠ A commercial product needs permission or another source.
- **Limits:** not published. Forecasts twice a day (00 and 12 UTC); hourly observations; times in UTC; `-99.0` = no data.
- **Useful endpoints:** `forecast/meteorology/cities/daily/{globalIdLocal}.json` (5 days), `forecast/warnings/warnings_www.json`, `observation/seismic/{3|7}.json` (3 = Azores, 7 = mainland and Madeira), `forecast/meteorology/rcm/rcm-d{0..2}.json` (fire risk), daily CSVs per municipality under `observation/climate/…`. Location ids in `distrits-islands.json`.
- **Example (Coimbra, globalIdLocal 1060300):**
  ```bash
  curl -s "https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/1060300.json"
  ```

### Banco de Portugal — BPstat
- **Endpoint:** `https://bpstat.bportugal.pt/data/v1`
- **Auth:** none.
- **Licence:** ESCB statistics — free reuse, including commercial, citing the source and without altering the data (confirm it applies to BPstat before publishing).
- **Limits:** not published. Pagination in `extension.next_page`.
- **Endpoints:** `/domains`, `/domains/{d}/datasets`, `/domains/{d}/datasets/{ds}` (observations, JSON-stat), `/domains/{d}/dimensions`, `/series`. Parameters: `lang`, `series_ids`, `obs_since`, `obs_to`, `obs_last_n`, `obs_published_since`.
- **Example:**
  ```bash
  curl -s "https://bpstat.bportugal.pt/data/v1/domains/?lang=EN"
  curl -s "https://bpstat.bportugal.pt/data/v1/domains/54/datasets/ce3e4e50cda325537eff729ef64037cd?lang=EN&series_ids=12518356&obs_last_n=12"
  ```

### GeoAPI.pt — administrative areas, postcodes, census
- **Endpoint:** `https://json.geoapi.pt/` (docs at geoapi.pt/docs)
- **Auth:** none on the JSON API.
- **Licence:** not stated. Sources: CAOP 2024.1 (DGT), CTT/INE (postcodes), Census 2011/2021, IPMA, APA. Unofficial project → fine for prototypes; in production prefer the official source (CAOP/DGT, INE).
- **Limits:** not published.
- **Example:** `curl -s "https://json.geoapi.pt/municipio/coimbra"` (path to confirm in the docs).

## Local government and parliament

### OpenCouncil Portugal — council meetings, transcribed (Schema Labs)
- **What:** transcripts of Câmara and Assembleia Municipal meetings, split into subjects with speakers, summaries and map locations. Greek non-profit project (open source, AGPL-3.0); in Portugal, **only Cascais so far** — 2 released meetings (20/10/2026 and 28/09/2026), not an official partnership with the municipality (verified 2026-11-02).
- **Endpoints:** site `https://pt.opencouncil.eu`; public **MCP server** `https://pt.opencouncil.eu/mcp` (Streamable HTTP; tools such as `list_cities`, `list_meetings`, `get_meeting`, `get_subject_transcript`, `search`, `list_nearby_subjects`); API docs at `https://pt.opencouncil.eu/en/docs` (contents not verified).
- **Auth:** none for the read-only MCP tools; unreleased cities and highlight tools need a personal token.
- **How to use it:** see the `reunioes-municipais-pt` skill if installed.
- **Licence/terms:** terms allow free use and redistribution of the information; source videos stay public domain; logo and design are protected. Transcripts are AI-generated and **not official minutes** — always say so when quoting.
- **Limits:** not published.
- **Good for:** what a council discussed about a subject or place, who spoke, and quoting with a timestamp. For other municipalities, use the council's own minutes (PDF) and videos.

### Assembleia da República — parliament open data
- **What:** official open data in XML and JSON, one file per theme and legislature: Iniciativas, Atividades, Intervenções, Diário da AR, Registo Biográfico, Composição de Órgãos, Petições, Perguntas e Requerimentos, Orçamento do Estado, Agenda Parlamentar, and more.
- **Endpoint:** listing at `https://www.parlamento.pt/Cidadania/Paginas/DadosAbertos.aspx` (each theme has its own page with file links). No official API.
- **Auth:** none.
- **Licence:** free reuse by anyone, **attribution to the Assembleia da República required** (no named licence).
- **Limits/pitfalls:** past legislatures updated monthly; the server is slow around 04:00–06:00 Lisbon time; files can temporarily return an HTML "Recurso Não Encontrado" page instead of data — validate before overwriting a good copy.
- **Community mirror:** github.com/rfsbraz/parlamento-aberto (git-versioned copy, cleaned tables in Parquet/CSV under CC BY 4.0, personal tax numbers masked). The community API `api.openar.pt` was **archived in August 2026 — do not build on it**.

### OParl — data model for council information (reference, not a Portuguese source)
- **What:** German standard (version 1.1, `https://schema.oparl.org/1.1/`) for read-only APIs of council information systems: `System`, `Body`, `LegislativeTerm`, `Organization`, `Person`, `Membership`, `Meeting`, `AgendaItem`, `Paper`, `Consultation`, `File`, `Location`. Spec: dev.oparl.org/spezifikation.
- **Why it is here:** Portuguese councils have no common API. When you structure meetings, agenda items, documents or councillors, **use OParl's object names and fields** so the data stays interoperable (German city APIs, OpenCouncil-style tools). Pagination pattern: `data` + `pagination` + `links.next`; incremental sync with `modified_since`.

## European Union

### Eurostat — Statistics API
- **Endpoint:** `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/{dataset}?{filters}` (JSON-stat 2.0). SDMX 2.1/3.0 under `/api/dissemination/sdmx/…`.
- **Auth:** none.
- **Licence:** free reuse, including commercial (Decision 2011/833/EU; editorial content CC BY 4.0). Cite the source and state any changes. Exceptions: third-party data and data for countries outside the EU, EFTA and candidate countries.
- **Limits:** none published; large requests take minutes → use the asynchronous endpoint. Updated twice a day (11:00 and 23:00 CET). Labels in EN, FR, DE.
- **Pitfall (verified):** `lastTimePeriod=1` can return an **empty** latest year (`value: {}`). Request a range and pick the last year with values.
- **Example (population, NUTS 3 Região de Aveiro):**
  ```bash
  curl -s "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_r_pjanaggr3?geo=PT16D&sex=T&age=TOTAL&sinceTimePeriod=2020"
  ```

### European Central Bank — ECB Data Portal
- **Endpoint:** `https://data-api.ecb.europa.eu/service/data/{flowRef}/{key}` (SDMX 2.1 REST)
- **Auth:** none.
- **Licence:** free reuse, including commercial; cite "Source: ECB statistics"; do not alter the data.
- **Limits:** not published. Parameters `startPeriod`, `endPeriod`, `lastNObservations`, `format=jsondata|csvdata`, `detail=dataonly`, `updatedAfter`; `If-Modified-Since` returns 304.
- **Example (daily USD/EUR):**
  ```bash
  curl -s "https://data-api.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?startPeriod=2026-01-01&format=csvdata"
  ```

### TED — EU public procurement (above EU thresholds)
- **Endpoint:** gateway `https://api.ted.europa.eu/v3/…`; search with `POST /v3/notices/search` (check the Swagger at api.ted.europa.eu/swagger).
- **Auth:** none for searching published notices.
- **Licence/limits:** to confirm in TED's Legal Notice.
- **Good for:** higher-value contracts in any EU country; cross-checking Portal BASE.
- **Example (query syntax to confirm):**
  ```bash
  curl -s -X POST "https://api.ted.europa.eu/v3/notices/search" \
    -H "Content-Type: application/json" \
    -d '{"query":"buyer-country=PRT","fields":["publication-number","notice-title"],"limit":10}'
  ```

### data.europa.eu — European data portal (to verify)
- Catalog that aggregates national portals (including dados.gov.pt). Search at `https://data.europa.eu/api/hub/search/search?q=…`. Licence per dataset. The endpoint responds; query syntax and fields not yet checked.

### Open-Meteo — global weather (alternative to IPMA)
- **Endpoint:** `https://api.open-meteo.com/v1/forecast?latitude=…&longitude=…`
- **Auth:** none.
- **Licence/limits:** free for non-commercial use only (600/min, 10,000/day, 300,000/month); CC BY 4.0 attribution. Commercial use = paid plan.

## To verify (do not use in production before testing)
- **Transparência SNS** — `https://transparencia.sns.gov.pt/api/explore/v2.1/` (Opendatasoft platform). Licence and limits to confirm.

## Adding a source
An API only joins the catalog with: a tested endpoint (or marked "to verify"), auth, licence with a link, limits (or "not published"), an example call and the verification date.
