---
name: pt-schools
description: How to get and read official data on Portuguese schools (ensino básico and secundário) — the InfoEscolas files by school, school cluster and municipality from DGEEC, with "observed vs expected" indicators for pupils of a similar profile, retention, completion on time, internal grades, equity for pupils with social support — and how to compare schools fairly. Use for questions about a school's results, choosing or comparing schools, or school maps. Escolas, agrupamentos, InfoEscolas, DGEEC, rankings, exames, sucesso escolar.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Portuguese schools

Part of the `portugal-open-data` skills. The richest official source is **InfoEscolas** (DGEEC, Ministry of Education statistics): about 100 indicators for every public and private school on the mainland, published as spreadsheets. There is no API, but the files have stable URLs.

**Domains used:** `infoescolas.medu.pt`, `dados.gov.pt`.

## InfoEscolas files

- **Listing:** `https://infoescolas.medu.pt/bds.asp` ("Bases de dados"), no login. Licence: CC BY (DGEEC, dataset "Infoescolas" on dados.gov.pt).
- **Latest edition:** "Dados Infoescolas em fevereiro de 2025", school years 2019/20–2022/23 (published about two years late). Editions back to 2017.
- **URL pattern (2022 onwards):**
  `https://infoescolas.medu.pt/docs/{YEAR}/InfoEscolas{YEAR}_{Level}_DadosPor{Escola|Regiao|UO}.xlsx` (also `.ods`), where `{YEAR}` is the folder year (`2024` = February 2025 edition) and `{Level}` ∈ `1Ciclo`, `2Ciclo`, `3Ciclo`, `Secundario_CH` (general/academic), `Secundario_Profissional` (vocational).
- **Older editions use other names** (`docs/2020/2020_SecundarioCH_DadosPorEscola.xlsx`, `docs/2019_3Ciclo_DadosPorEscola.xlsx` at the root). Use a URL map, not the pattern, for history.
- **Granularity:** `DadosPorEscola` (school), `DadosPorUO` (unidade orgânica = school cluster/agrupamento, non-grouped public school, or private school), `DadosPorRegiao` (municipality and NUTS III).
- **Size (Feb 2025 edition, school files):** 1.º ciclo 3 763 schools, 2.º 1 086, 3.º 1 235, secundário CH 594, profissional 705 — 4 950 distinct schools, 716 private. 856 units in the UO files.

Sheets and columns: [references/infoescolas-sheets.md](references/infoescolas-sheets.md).

## What makes it valuable: "observed vs expected"

For completion on time (`ConclusãoTempoEsperado`) and, in the 3.º ciclo, "percursos diretos de sucesso" (no retention + positive marks in both national tests), each school has:
- the **observed** percentage of its pupils, and
- the **expected** percentage: pupils across the country with a similar profile (age, social support, previous path).

Observed − expected is the fairest single comparison available: it asks whether the school does better or worse than usual **with the pupils it has**. In the secondary CH file, internal grades by course (0–20) also come as observed vs expected; a school above expected may grade more generously, not teach better — present it as a pattern, never as an accusation.

## Traps

1. **Header rows.** Each sheet has ~5 title rows, then one or two header rows, then a `TOTALPT` row (national total), then schools. Detect the header row; do not hard-code `skiprows`.
2. **Suppressed values.** `*` = suppressed (fewer than 15 pupils in the sample, or fewer than 20 enrolled); `-` = not applicable. Neither is zero. Count them and exclude them from averages.
3. **Small samples.** A school with 20 pupils moves several points with one pupil. Show the sample size (`Número de alunos da escola na amostra`) next to every percentage.
4. **Private schools** are only identifiable in the UO files (`Natureza da Unidade` = "Privada"); the school files do not say it. Join on the school code.
5. **The UO files have the district, not the municipality.** The municipality usually is the suffix of the unit name ("Escolas de S. Bento, Vizela"); ~6% of units do not match that way.
6. **Column names vary between sheets** ("Município" vs "Munícipio", "Código Escola DGEEC" vs "Código da Escola"). Normalise.
7. **Retention is per curricular year.** To get one rate per school, weight each year by its enrolment (from the `Populacao` sheet), do not average the rates.
8. **No national exam results by subject** in these files. For "internal mark vs exam by subject", the separate exam database (Ministry/JNE) is needed; it is shared with newspapers before it is public and often published with about a year's delay.
9. **Two years late.** Always label the school year; never present February 2025 data as "this year".

## Keys for joining
- **Código Escola DGEEC** (6 digits, e.g. `603211`) in every sheet — the key to join with exams, inspection reports and locations.
- **Código do Agrupamento** in UO files.
- Municipality name → DICO via `pt-territory`.

## Other sources
- **DGEEC on dados.gov.pt** (34 datasets) and `https://www.dgeec.medu.pt/` (reports, tables; requests for more detailed data via its data-request form).
- **IGEC external evaluation reports** (one PDF per school cluster: three domains on a five-level scale, strengths and areas to improve) — text, not data; good input for structured extraction, to verify per case.
- **Newspaper rankings** (Público, Expresso, Observador with Nova SBE, Renascença) are built on the exam database; they are secondary sources.

## Method for "compare schools near me"
1. Download the needed level's `DadosPorEscola` and `DadosPorUO` files; save as Parquet.
2. Filter by municipality; join UO data by school code for public/private.
3. For each school show: pupils, observed vs expected completion (latest year and trend over four), retention, and for secondary the courses offered and internal grades vs expected.
4. Sort by observed − expected, not by raw averages; show sample sizes; mark suppressed values.
5. Run `pt-data-checks`. Footer: "Source: InfoEscolas, DGEEC, edition Feb 2025 (CC BY); school years 2019/20–2022/23".
6. Never use or publish individual pupil data; these files are aggregates only.
