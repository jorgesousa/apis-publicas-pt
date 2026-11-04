---
name: pt-mobility
description: Where to find Portuguese public transport and mobility data — GTFS and NeTEx timetables (Metro de Lisboa, Carris Metropolitana, Braga, Coimbra SMTUC, Metro Mondego, Região de Coimbra), real-time feeds, bike sharing (GIRA), EV charging points, the national road and rail networks — and the traps in them (expired feeds, missing calendars, licences). Use for routes, stops, timetables, accessibility to transport, or mobility maps. Transportes públicos, horários, paragens, GTFS, autocarros, metro, comboio, ciclovias.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Mobility and public transport in Portugal

Part of the `portugal-open-data` skills. There is no national timetable feed: each operator or transport authority publishes its own, mostly as GTFS files, some as NeTEx. Most are listed on dados.gov.pt.

**Domains used:** `dados.gov.pt` (most files are hosted there), plus each operator's host (`github.com`, `www.tub.pt`, `geoportal.tmlmobilidade.pt`, `api.planner.agit.pt`).

## Timetable feeds (checked on dados.gov.pt, 2026-11-04)

| Operator / area | Format | dados.gov.pt slug | Licence | Notes |
|---|---|---|---|---|
| Metropolitano de Lisboa | GTFS | `gtfs-do-metropolitano-de-lisboa` | CC BY | File updated Oct 2026 |
| Carris Metropolitana (Lisbon metro area buses, TML) | GTFS | `gtfs-carris-metropolitana` | `notspecified` | Live file in the operator's GitHub repo `carrismetropolitana/gtfs`; stops and shapes also as OGC API at `geoportal.tmlmobilidade.pt/ogc-api/collections/gtfs_stops` (CC BY) |
| TUB — Transportes Urbanos de Braga | GTFS | `gtfs-transportes-urbanos-de-braga` | `notspecified` | Feed at `https://www.tub.pt/developer/gtfs/feed/tub.zip` |
| SMTUC — Coimbra urban buses | GTFS (+ NeTEx, SIRI from AGIT) | `gtfs-estaticos-servicos-municipalizados-de-transportes-urbanos-de-coimbra` | `notspecified` | Monthly; verified below |
| Metro Mondego (Coimbra) | GTFS + NeTEx | `metro-mondego`, `metro-mondego-netex` | CC BY | AGIT |
| Região de Coimbra intermunicipal network | NeTEx | `sistema-intermunicipal-de-transportes-da-regiao-de-coimbra-netex` | CC BY | AGIT; also a planner API (`https://api.planner.agit.pt/v1/`, registered on dados.gov.pt, to verify) |
| Águeda municipal network | GTFS | `rede-de-transportes-publicos-municipal` | CC BY | 2019 — outdated |

Not on dados.gov.pt at last check: CP (national rail), Metro do Porto, STCP. Look for them on the operators' own sites and mark them "to verify".

**Verified example (SMTUC, file of 2026-10-12):** 9 standard files (agency, feed_info, calendar, calendar_dates, routes, trips, stop_times, stops, shapes), ~22 MB unzipped; `feed_info.txt` valid **2026-09-18 → 2026-11-12**; `calendar.txt` has only the header — services are defined entirely in `calendar_dates.txt`.

## Other mobility data
- **GIRA bike sharing (Lisbon, EMEL):** stations (`estacoes-gira`, CC BY; `girastations`, CC BY-SA).
- **EV charging:** EMEL LEVE points (`eletriccharging`, `notspecified`), Lisbon Mobi.E points (`postos-de-carregamento-mobi-e`, CC0), a national indicator from AMA (`enti-indicador-disponibilizacao-e-localizacao-de-postos-de-carregamento-de-veiculos-eletricos`, CC BY). The full Mobi.E network is run by Mobi.E S.A.; its data access is to verify.
- **Road and rail networks (Infraestruturas de Portugal, CC BY, quarterly):** `rede-rodoviaria-nacional`, `rede-ferroviaria-nacional`, `estacoes-e-apeadeiros`, `ecopistas`.
- **TML (Lisbon metro area):** monthly aggregated ticket validations, cycle network, parking, occurrences — on dados.gov.pt, CC BY.

## Traps
1. **Feeds expire.** Read `feed_info.txt` (`feed_start_date`, `feed_end_date`) and `calendar`/`calendar_dates` before answering "is there a bus on date X". An expired feed gives confident wrong answers.
2. **Empty `calendar.txt`.** Some feeds use only `calendar_dates.txt`. Libraries that assume weekly calendars return no service.
3. **Licences vary per operator**, and several are `notspecified`. Fine for analysis; confirm before a product.
4. **Stable links can move.** The Carris Metropolitana link on dados.gov.pt points to a GitHub raw file that redirects; fetch the operator's repository if it fails.
5. **Timetable ≠ reality.** GTFS is the plan. Real-time (GTFS-RT, SIRI) exists only for some operators (AGIT publishes SMTUC SIRI) — check before promising "live".
6. **Stops are not unique across feeds.** The same physical stop has different ids in different operators' feeds; merge by distance and name, not by id.

## Method for "how well served is place X"
1. Collect the feeds that cover X; check validity dates.
2. Count departures per stop within a radius for a chosen weekday (from `stop_times` + `calendar_dates`), stating the date used.
3. Join stops to parishes or municipalities with CAOP (`pt-territory`).
4. Run `pt-data-checks`; footer with each operator, feed date and licence.
