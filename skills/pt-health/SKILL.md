---
name: pt-health
description: Where to find Portuguese health service (SNS) data — the Transparência SNS portal (hospital and primary care activity, emergency attendances, waiting times, staff, medicines, emergency medical calls) and its copies on dados.gov.pt, INFARMED, ACSS, INEM, plus public lists such as the Cheque Cuida-te psychologists — with the traps (duplicate copies with different licences, aggregated-only data, personal data in lists of professionals). Use for questions about SNS activity, hospitals, health centres, medicines or health professionals. Saúde, SNS, hospitais, centros de saúde, urgências, medicamentos, listas de espera.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Health (SNS) data in Portugal

Part of the `portugal-open-data` skills. Most SNS open data is published on **Transparência SNS** (`transparencia.sns.gov.pt`, an Opendatasoft portal fed by ACSS, SPMS, INFARMED, INEM and others). dados.gov.pt harvests it, so the same dataset appears in both places.

**Domains used:** `transparencia.sns.gov.pt` (data), `dados.gov.pt` (catalogue and a few files).

## Transparência SNS (Opendatasoft)

- **Datasets:** each has an id visible in its URL, e.g. `atendimentos-em-urgencia-triagem-manchester`, `atendimentos-por-tipo-de-urgencia-hospitalar-link`, `acesso-de-consultas-medicas-pela-populacao-inscrita`, `atividade-de-internamento-hospitalar`, `acionamentos-de-meios-de-emergencia-medica`, `agregados-economico-financeiros`, `antibioticos`, `portal-base` (public contracts in health).
- **Exports (pattern seen in dados.gov.pt resources):**
  `https://transparencia.sns.gov.pt/explore/dataset/{id}/download?format=csv|json&timezone=Europe/Lisbon&use_labels_for_header=true`
- **API (Opendatasoft v2.1):**
  `https://transparencia.sns.gov.pt/api/explore/v2.1/catalog/datasets?limit=20` (catalogue) and
  `https://transparencia.sns.gov.pt/api/explore/v2.1/catalog/datasets/{id}/records?limit=100&where=…&order_by=…` (records; `limit` max 100 per call — use the exports for full tables).
- **Auth:** none. **Licence:** shown per dataset on the portal; check each one (see trap 1).
- **Status:** the catalogue endpoint answered 200 in the weekly check (2026-11-04); the export links are confirmed through dados.gov.pt. The `records` query parameters follow the Opendatasoft standard and have not been tested record by record.

## Who publishes what (dataset counts on dados.gov.pt, 2026-11-03)

| Body | Datasets | Examples |
|---|---|---|
| ACSS | 131 | Hospital and primary-care activity, enrolled patients, emergency attendances, surgery, staff by group, overtime, SNS accounts, debt and payment delays |
| SPMS | 76 (two organisation records) | Information systems, SNS 24 |
| INFARMED | 41 | Medicine spending (hospital and outpatient), generics, biosimilars, antibiotics, average pack price, clinical trials, strategic reserve |
| INEM | 34 | Emergency medical calls and vehicle dispatches |
| DE-SNS (Executive Directorate) | 33 | SNS-wide indicators |
| Ordem dos Psicólogos | 3 | Cheque Cuida-te / Cheque Psicólogo provider lists |

## Traps
1. **Two copies, two licences.** Many SNS datasets appear twice on dados.gov.pt: one `cc-by` (frequency "unknown") and one `notspecified` (monthly). Same data. Take the licence from Transparência SNS itself and cite it.
2. **The catalogue date is not the data date.** Many records show `last_update` in February 2026 from a re-harvest; read the period inside the data.
3. **Reorganisation of the SNS.** Since 2024 hospitals and health centres are grouped in ULS (Unidades Locais de Saúde). Series that span the change mix old institutions (ARS, ACES, hospital centres) with ULS — map them before comparing over time.
4. **Aggregates only.** Data are by institution and month. Small cells may be suppressed. There is no patient-level data, and there should not be.
5. **Waiting times** shown for emergency departments are per triage colour and moment; they are not a "time to be seen" for a given person. Surgery waiting lists (LIC, TMRG) have their own definitions — quote the definition with the number.
6. **Lists of professionals are personal data.** The Cheque Cuida-te dataset (Ordem dos Psicólogos, `other-pd`, monthly) lists psychologists who signed up as providers: name, licence number, address, e-mail, phone. Use it for aggregates (providers per municipality, share offering online sessions). Do not copy contacts into a marketing list or a new product: the open licence does not change the purpose for which the data were given. Count people by licence number (`Cedula Profissional`), not rows: in Oct 2026 the file had 4 754 rows for 3 865 psychologists. The file is UTF-8 with BOM, semicolon-separated.

## Method for "how is hospital/area X doing"
1. Find the dataset id on Transparência SNS (or via dados.gov.pt search).
2. Export CSV for the period; keep the raw file.
3. Map institutions to ULS and to municipalities (`pt-territory`) if comparing areas.
4. Compare like with like (same month, same definition); show the trend, not one month.
5. Run `pt-data-checks`. Footer: "Source: Transparência SNS, dataset <id>, licence, extracted YYYY-MM-DD".
