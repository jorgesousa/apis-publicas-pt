---
name: pt-environment
description: Where to find Portuguese environment and civil-protection data — APA (Agência Portuguesa do Ambiente) water resources and monitoring stations (SNIRH), bathing water quality, air quality stations and zones, greenhouse gas inventory, flood risk, INE environment indicators, rural fires and civil-protection occurrences — with the traps (unspecified licences, map services instead of tables, old endpoints). Use for questions about water, rivers, reservoirs, beaches, air pollution, emissions, fires or emergencies. Ambiente, água, qualidade do ar, praias, emissões, incêndios, proteção civil.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Environment and civil protection in Portugal

Part of the `portugal-open-data` skills. APA is the second-largest publisher on dados.gov.pt (4 218 datasets), but most entries are maps (WMS/WFS services, shapefiles) and PDF reports, not tables, and almost all have licence `notspecified`.

**Domains used:** `dados.gov.pt`, `sniambgeoviewer.apambiente.pt` (files), `inspire.apambiente.pt` and `sniambgeoogc.apambiente.pt` (map services), `snirh.apambiente.pt` (water data portal), `www.ine.pt`.

## Main sources

| Topic | Source | Format | Notes |
|---|---|---|---|
| Monitoring stations — hydrometric, meteorological, surface-water quality | APA / SNIRH (Sistema Nacional de Informação de Recursos Hídricos) | Shapefile zips on `sniambgeoviewer.apambiente.pt/GeoDocs/shpzips/…`; WMS/WFS on `inspire.apambiente.pt` | Station locations. The measurements themselves are on the SNIRH portal (`snirh.apambiente.pt`), which has no documented open API — to verify |
| Reservoirs, river basins | APA "Atlas da Água" | Shapefiles | |
| Bathing water quality | APA | Yearly PDF reports per region (59 datasets) | Text, not tables — extraction needed |
| Air quality stations and zones | APA | WMS/WFS + shapefile | The QualAr portal has the readings; access to verify |
| Air quality index | INE `0006693` | INE API | Annual, older series |
| Greenhouse gas emissions by sector | APA, national inventory | XLSX on `sniambgeoviewer…/Emissoes_GEE_Setor_PT.xlsx` | Two copies with different file names; check which is newer |
| Emissions per resident | INE `0014149` | INE API | |
| Flood risk areas (APSFR) | APA | Shapefile | |
| Rural fires (count) | INE `0008386` (source ICNF) | INE API | Annual, by NUTS |
| Civil-protection occurrences | ANEPC "ProCiv - Ocorrências em aberto" | API listed on dados.gov.pt (CC BY) | The listed endpoints on `www.prociv.pt/_vti_bin/…` date from 2021 and point to the old site — likely outdated, to verify |

## Traps
1. **The file server is unstable.** `sniambgeoviewer.apambiente.pt` did not answer from GitHub's servers in the 2026-11-04 check. Retry later, and keep a local copy once a file downloads.
2. **`notspecified` licence** on almost every APA dataset. Fine for analysis and research; ask APA or the user before putting the data in a commercial product.
3. **Maps, not numbers.** Many APA "datasets" are station networks or zones. To get measurements you need the source portal (SNIRH, QualAr), not the WMS.
4. **Duplicates.** The same layer appears with different update dates and frequencies (e.g. two "Rede de estações hidrométricas" records). Prefer the newest file and say which.
5. **Coordinates.** Shapefiles usually come in PT-TM06/ETRS89 (EPSG:3763); reproject (see `pt-territory`).
6. **PDF reports** (bathing water, air quality summaries) need text extraction and a check of every extracted number against the PDF.
7. **Weather is IPMA**, not APA: forecasts, warnings and fire risk are in `portugal-open-data` (IPMA section, non-profit use only).

## Method for "is the water/air near X OK"
1. Find the nearest stations from the APA station layers (distance in a projected CRS).
2. Get the readings from the source portal for a stated period; if unreachable, say so and stop rather than guessing.
3. Compare with the legal limits for the parameter and period, citing the limit's source.
4. Run `pt-data-checks`; footer with station ids, period, source and licence status.
