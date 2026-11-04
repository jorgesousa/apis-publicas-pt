---
name: pt-public-procurement
description: How to get and read Portuguese public procurement data — Portal BASE (IMPIC) contracts, notices, contract modifications and entities on dados.gov.pt, plus TED for contracts above EU thresholds — with the field meanings and the traps (signing year vs publication date, supplier names vs tax numbers, CPV codes, empty effective price). Use for questions about what a public body contracted, who supplies it, how much, and by which procedure. Contratos públicos, ajustes diretos, adjudicações, Portal BASE, fornecedores, câmaras municipais.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Portuguese public procurement

Part of the `portugal-open-data` skills. Every Portuguese public body must publish its contracts on **Portal BASE** (base.gov.pt), run by IMPIC. IMPIC republishes the full database as yearly open-data files on dados.gov.pt. Work from those files, not from the website.

**Domains used:** `dados.gov.pt` (files are served from `dados.gov.pt/s/resources/…`), `api.ted.europa.eu` for TED. `www.base.gov.pt` is the human website; it is not needed for the files.

## The four datasets (all IMPIC, licence `other-pd` = public domain, updated weekly)

| Dataset (dados.gov.pt slug) | What | Formats |
|---|---|---|
| `contratos-publicos-portal-base-impic-contratos-de-2012-a-2026` | Contracts, one file per year | `contratosYYYY.zip` (JSON inside), `.xlsx` |
| `contratos-publicos-portal-base-impic-anuncios-de-2012-a-2026` | Procurement notices (anúncios) | `.json`, `.xlsx` |
| `contratos-publicos-portal-base-impic-modificacoes-contratuais-de-2012-a-2026` | Contract modifications (price, deadline) | `.json`, `.xlsx` |
| `contratos-publicos-portal-base-impic-entidades` | Every entity with totals as buyer and supplier | `.json`, `.xlsx` |

```bash
# list the current file URLs (they change with every weekly upload — never hard-code them)
curl -s "https://dados.gov.pt/api/1/datasets/contratos-publicos-portal-base-impic-contratos-de-2012-a-2026/" \
  | python3 -c "import json,sys;[print(r['title'],r['url']) for r in json.load(sys.stdin)['resources']]"
```

**Do not use:** the OCDS feed (`ocds-portal-base-www-base-gov-pt`), frozen since 2020; the 2020 COVID-regime contracts dataset (frozen 2022) unless the question is about it. "Contratos Públicos na Saúde" on dados.gov.pt is a copy filtered by Transparência SNS, not a separate source.

## Size and shape (2026 file, measured 2026-11-04)

- `contratos2026.zip` ≈ 71 MB → one JSON array of ≈ 202 000 contracts, ≈ 600 MB uncompressed. Stream it or load it once and save Parquet; do not open it in the conversation.
- Nested fields (`adjudicante`, `adjudicatarios`, `CPV`, `Lotes`, `localExecucao`, `NUTs`) are real JSON arrays. Dates are ISO `YYYY-MM-DD` in contracts but `DD/MM/YYYY HH:MM:SS` in modifications. `Ano` is an integer.
- Full field list with fill rates: [references/portal-base-fields.md](references/portal-base-fields.md).

## Traps (each one seen in real work)

1. **Which year.** `Ano` and the yearly file are the **signing** year (`dataCelebracaoContrato`: 0 mismatches in 2026). Publication (`dataPublicacao`) can be in the next year — the 2025 file still gets contracts published in 2026 — and a few are published before signing. Decide: signing year (complete per file) or publication date (what the portal shows). Say which. For "this year so far vs same date last year", use the same date field on both sides.
2. **Names are not identities.** The same buyer or supplier appears with different spellings. Join on the tax number `nifEntContrato`, never on `descEntContrato`. Some municipalities have more than one NIF (2025: 325 NIFs for 308 municipalities).
3. **Suppliers without a tax number.** 11.8% of supplier entries in 2026 have no NIF (`-` or empty): foreign companies and individuals. Keep them, flag them, never invent a match, and do not publish individuals' names out of context.
4. **Money.** `precoContratual` is the signed price (VAT excluded as reported). `PrecoTotalEfetivo` (what was actually paid) is filled in only ~8% of contracts → do not use it as spending. Contracts are **not** a body's total spending (see `pt-local-finance`).
5. **One big contract dominates.** In a small municipality one works contract can be a third of the year. Show the top items and the share of the top 5 suppliers.
6. **CPV codes are unreliable** as a category: they describe the procedure, can be generic, and 1.2% of contracts have several. Use them as a signal; classify by `objectoContrato` + `descContrato` and report the share left "to review".
7. **Procedures.** `tipoprocedimento` values include "Ajuste Direto Regime Geral" (42% of 2026 contracts), "Consulta Prévia", "Concurso público", "Ao abrigo de acordo-quadro (art.º 258.º/259.º)" and "Contratação excluída II". Agreement-based contracts can look like direct awards in a chart but follow a prior tender — keep them separate.
8. **Competition.** `concorrentes` is filled in ~42% of 2026 contracts, `entidadesConvidadas` ~29%. Do not compute "average number of bidders" across all contracts.
9. **Modifications** live in their own file, keyed by `idcontrato`. A contract's final price = initial price + modifications; join before claiming overruns.
10. **Finding a municipality.** Filter `adjudicante[].nifEntContrato` by the council's NIF (get it from the entities file or one known contract). Municipal companies (water, transport) and inter-municipal bodies have their own NIFs: decide whether the "municipal ecosystem" is in scope.

## TED — EU-level notices
- **Endpoint:** `POST https://api.ted.europa.eu/v3/notices/search` (Swagger at api.ted.europa.eu/swagger). No auth for search.
- **Use for:** contracts above EU thresholds, cross-checking Portal BASE, comparing with other EU countries.
- **Licence/limits:** to confirm in TED's Legal Notice. Query syntax to confirm:
  ```bash
  curl -s -X POST "https://api.ted.europa.eu/v3/notices/search" -H "Content-Type: application/json" \
    -d '{"query":"buyer-country=PRT","fields":["publication-number","notice-title"],"limit":10}'
  ```

## Method for "where does body X spend its money"
1. Download the yearly contracts file(s) and the modifications file; save as Parquet.
2. Filter by the body's NIF(s). Choose the date field (trap 1) and write it in the output.
3. Normalise suppliers by NIF; keep a name table (most frequent spelling per NIF).
4. Classify each contract into a small set of categories from its description; keep CPV as a check; report the share "to review".
5. Report totals, top suppliers, procedures and the largest contracts; per resident only with an INE population of a stated year.
6. Run `pt-data-checks`. Footer: "Source: Portal BASE/IMPIC via dados.gov.pt (public domain), extracted YYYY-MM-DD".
