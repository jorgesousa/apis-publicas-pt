---
name: pt-territory
description: How to work with Portugal's administrative geography — official boundaries (CAOP from the Direção-Geral do Território), municipality and parish codes (DICO/DICOFRE, INE geography codes, NUTS), the 2025 parish restoration, map projections and simplification, plus BUPi land parcels. Use when drawing maps, joining data by municipality or parish, or converting between names and codes. Concelhos, freguesias, distritos, NUTS, CAOP, códigos INE, mapas.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Portuguese territory: boundaries and codes

Part of the `portugal-open-data` skills. Almost every Portuguese dataset is reported by municipality (concelho/município) or parish (freguesia). Joining them right is most of the work.

**Domains used:** `geo2.dgterritorio.gov.pt` and `ogcapi.dgterritorio.gov.pt` (CAOP), `dados.gov.pt`, `json.geoapi.pt` (optional), `geo.bupi.gov.pt` (optional).

## The units

| Level | Count | Notes |
|---|---|---|
| Distritos | 18 (mainland) | Still used in many datasets, but not an administrative level with its own bodies. Azores and Madeira are autonomous regions, not districts. |
| Municípios / concelhos | 308 (278 mainland, 19 Azores, 11 Madeira) | Stable. |
| Freguesias | changed in 2025 | About 300 parishes merged in 2013 were restored by Lei 25-A/2025, effective with the October 2025 local elections. Take the count from the CAOP version you use; never mix pre- and post-2025 parish lists. |
| NUTS II / III | EU statistical regions | Revised for NUTS 2024 (e.g. the Lisbon region split into Grande Lisboa and Península de Setúbal). INE and Eurostat series can use different NUTS versions — check the code list. |

## Codes (join on these, never on names)

- **DICO** — 4-digit municipality code: district (2) + municipality (2). Coimbra = `0603`, Arouca = `0104`. **DICOFRE** adds the parish (2 more digits). In the islands the first two digits are the island, not a district (Madeira `31`–`32`, Azores `41`–`49`).
- **INE geography codes** — used in the INE API `Dim2`, e.g. `16E0603` (Coimbra), `11A0104` (Arouca): NUTS III code + DICO. Get them from the INE metadata call (`pindicaMeta.jsp`).
- **NUTS** — `PT16D` (Região de Aveiro), etc. Portal BASE contracts carry NUTS III codes, not DICO.
- **Names are unsafe:** accents, hyphens ("Vila Nova de Gaia" vs "V. N. Gaia"), "Município de X" vs "Câmara Municipal de X", same-name parishes in different municipalities, and upper-case files (CAOP uses "ÁGUEDA"). If you must match names, normalise (strip accents, upper-case, hyphens → spaces) and check every non-match by hand.

## Boundaries: CAOP (official)

- **What:** Carta Administrativa Oficial de Portugal, by the Direção-Geral do Território (DGT), published yearly; licence CC BY. Three datasets: Continente, RAA (Azores), RAM (Madeira).
- **Downloads (CAOP2025):** `https://geo2.dgterritorio.gov.pt/caop/CAOP_Continente_2025-gpkg.zip` (also `CAOP_RAA_2025`, `CAOP_RAM_2025`), WMS `https://geo2.dgterritorio.gov.pt/geoserver/caop_continente/wms`, OGC API Features `https://ogcapi.dgterritorio.gov.pt/`. dados.gov.pt slug: `carta-administrativa-oficial-de-portugal-caop2025-continente`.
- **Projection:** mainland data is in **PT-TM06/ETRS89 (EPSG:3763)**, not latitude/longitude. Reproject to WGS84 (EPSG:4326) for web maps. Azores and Madeira use their own systems.
- **Extraordinary version:** CAOP2024.1 was issued to reflect the 2025 parish restoration.
- **For web maps:** simplify. A mainland municipality GeoJSON is ~35 MB; with mapshaper:
  `mapshaper in.geojson -proj from=EPSG:3763 wgs84 -simplify 3% keep-shapes -o format=topojson out.topo.json` → ~250 KB, all 278 shapes kept.

## Other sources and their traps

- **dados.gov.pt "Concelhos de Portugal" / "Freguesias de Portugal"** (AMA, 2018): based on **CAOP2017** — outdated parishes. Fine for municipalities in a quick prototype; never for parishes.
- **Community GeoJSON on GitHub** (e.g. `nmota/caop_GeoJSON`): convenient, but check the CAOP year, the projection (often EPSG:3763) and encoding — one file starts with a UTF-8 BOM, so read with `utf-8-sig`.
- **GeoAPI.pt** (`https://json.geoapi.pt/`): unofficial, no auth, built on CAOP 2024.1 plus CTT/INE postcodes and census data. Good for lookups ("which parish is this point in", postcode → municipality) in prototypes; licence not stated, so prefer CAOP/INE in production. Paths to confirm in geoapi.pt/docs.
- **Postcodes:** CTT's full postcode file is not open data on dados.gov.pt (0 results). Use GeoAPI.pt for prototypes or the user's own licensed copy.
- **BUPi** (land parcels outside the old cadastre): "Representação Gráfica Georreferenciada" (GeoPackage, WFS `https://geo.bupi.gov.pt/gisbupi/services/opendata/RGG_DadosGovPT/MapServer/WFSServer`, CC BY, updated twice a month) and "Progresso da Georreferenciação" (JSON/CSV by municipality and parish, monthly). Coverage is partial by design.
- **Cadastro Predial** (DGT, CC BY): official cadastre, only where it exists.

## Checks
- State the CAOP version (year) under every map and every parish table.
- After a join, count non-matches; 0 is the target for municipalities.
- Parish data before and after October 2025 do not line up one-to-one: aggregate to municipality or map old unions to new parishes explicitly.
- Footer: "Boundaries: CAOP YYYY, Direção-Geral do Território (CC BY)".
