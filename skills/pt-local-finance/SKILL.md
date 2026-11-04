---
name: pt-local-finance
description: How to get and compare the finances of Portuguese municipalities — revenue, expenditure and debt of câmaras municipais (INE indicators from DGAL data), state transfers, budgets and accounts, IMI tax rates — and how not to confuse them with public contracts. Use for questions about how much a council spends or owes, per resident comparisons, or budgets. Finanças locais, receitas e despesas das câmaras, dívida municipal, orçamento municipal, FEF, IMI, DGAL.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Municipal finance in Portugal

Part of the `portugal-open-data` skills. The official figures on what councils collect, spend and owe come from the DGAL (Direção-Geral das Autarquias Locais), which receives each council's accounts; INE republishes them as indicators with an API. Budgets and accounts as documents stay on each council's site.

**Domains used:** `www.ine.pt`, `dados.gov.pt`; council sites for budgets and accounts.

## Official indicators (INE API, source DGAL, licence CC BY)

| Indicator | Code | Notes |
|---|---|---|
| Revenue of câmaras municipais, by economic classification | `0013908` | 2021–2023 at last check |
| Expenditure of câmaras municipais, by economic classification | `0013909` | 2021–2023 |
| Debt of câmaras municipais (€) | `0009144`, `0009482` | two series; read the metadata to pick |
| Debt per resident (€/hab.) | `0009156` | |
| Medium/long-term bank debt as % of total debt | `0009164` | |

How to call: see the INE section of `portugal-open-data`. Always read `pindicaMeta.jsp?varcd={code}` first for unit, dimensions and last period.

```bash
curl -s "https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0013908&Dim2=11A0104&lang=PT"   # Arouca revenue
# 2023: 23 754 → thousands of euros → €23.8 M
```

## Traps

1. **Thousands of euros.** The DGAL finance indicators come with power of 10 = 3: `23754` = €23.8 M. Read the unit in the metadata every time.
2. **Cash basis.** Revenue and expenditure are on a cash basis (what came in and went out in the year), not commitments or accruals. Say so.
3. **Preliminary.** The latest year is flagged "Dado preliminar" and can be revised.
4. **Gaps.** Some municipalities are missing in some years (e.g. Penedono, "dado não disponível"). Missing is not zero.
5. **Contracts are not spending.** Public contracts (Portal BASE, see `pt-public-procurement`) are what was contracted and published, signed in a given year, possibly paid over several years. Total expenditure includes salaries, transfers, debt service. Show both side by side when useful (Coimbra 2023: expenditure €141.7 M; 2025 contracts €38.1 M), but never divide one by the other: different years and different bases.
6. **Same year, same population.** Per-resident figures need the INE resident population (`0008273`) of the same municipality and, ideally, the same year. State both years when they differ.
7. **The câmara is not the whole municipality.** Municipal companies (water, transport), parishes and inter-municipal bodies have their own accounts.

## Other sources

| Source | What | Format | Status |
|---|---|---|---|
| Council budgets and "Grandes Opções do Plano" | Planned revenue and spending | PDF on each council's site; ~10 on dados.gov.pt (`q=orçamento municipal`) | Text extraction needed |
| Accounts (prestação de contas) | Executed budget, balance sheet | PDF on each council's site | Text extraction needed |
| State transfers (FEF, FSM, IRS share) | Amounts per municipality | Annex maps of the State Budget law (Lei do Orçamento do Estado); DGAL publishes per-municipality tables | To verify |
| Anuário Financeiro dos Municípios Portugueses | Yearly analysis and rankings by the Ordem dos Contabilistas Certificados | PDF report | Secondary source; cite as such |
| Conselho das Finanças Públicas | Reports on local administration finances | PDF | Secondary source |
| IMI tax rates (308 municipalities, 2023–2025) | Rates set by each council | Community dataset on dados.gov.pt by Flat In Portugal (CC BY, OpenAPI at flatin.pt/openapi.json) | Unofficial; official source is the Portal das Finanças table |

## Method for "how does council X compare"
1. Get revenue and expenditure (`0013908`, `0013909`) and debt (`0009156`) for X and its peers, same year.
2. Get resident population (`0008273`) for the same year; compute per resident in code.
3. Choose peers by a stated rule (same NUTS III, similar population band) and write the rule.
4. Run `pt-data-checks`. Footer: "Source: INE, from DGAL data (indicator codes), cash basis, YYYY preliminary; population INE YYYY".
