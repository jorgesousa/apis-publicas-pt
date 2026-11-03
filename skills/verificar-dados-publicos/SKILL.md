---
name: verificar-dados-publicos
description: Checklist to run before publishing any number, chart or comparison built from public data (official statistics, public contracts, budgets, council records). Catches mismatched years, wrong units, contracts mistaken for spending, small samples, duplicated entities and licence problems. Use whenever an answer or product cites open data. Verificação de dados públicos antes de responder ou publicar.
license: MIT
metadata:
  version: "1.0.1"
  verified: "2026-11-02"
---

# Check public data before you publish it

Public data is easy to fetch and easy to misread. Most mistakes are not in the API call but in what the number means. Run this checklist **before** giving an answer, drawing a chart or shipping a page, and put what you found in the output (a footnote, a caveat line, a "how we calculated" note). Never hide a caveat to make a result look cleaner.

Every rule below comes from a real case. The examples use Portuguese data, but the checks apply to any country.

## How to use it

1. Write down the claim in one sentence ("Arouca spends €845 per resident on public contracts").
2. Go through the eight checks. For each one, either confirm it or add a caveat.
3. End the output with: sources, reference period(s), extraction date, method in one line, and the caveats.

## The eight checks

### 1. Reference period
- Every number gets an explicit year (or date range). "Latest" is not a year.
- When combining sources, **compare their years**. If they differ, say so on the chart, not only in a footnote.
- Check the latest period actually has values: some APIs return an empty latest year (Eurostat `lastTimePeriod=1` returned `value: {}`), and INE marks recent years as "Dado preliminar".
- Watch which date a dataset uses. Portal BASE files have a "year" field that is the contract year while the portal says dates are publication dates; pick one and state it.
- A year in progress needs a label everywhere ("2026 to 4 Oct"), and must not be compared with a full year without saying so.

> Example: contracts are from 2025, the latest INE population is 2023 → "€/resident = 2025 contracts ÷ 2023 population".

### 2. Units and scale
- Read the metadata before the data. INE's municipal finance indicators are in **thousands of euros** (power of 10 = 3): `23754` is €23.8 M, not €23,754.
- Check currency, nominal vs real (inflation), cash vs accrual basis, and whether "%" means share or change.
- Per-capita figures need the population **of the same area and, ideally, the same year**.

### 3. What the number measures
- Name the concept exactly. **Public contracts are not total spending**: they cover what was contracted (and published), not salaries, transfers or everything paid. Municipal revenue and expenditure come from the budget execution (DGAL, via INE).
- Contract value ≠ amount paid. In Portal BASE, the "effective price" field is often 0 or missing — do not treat it as real.
- Estimates, forecasts and AI-generated transcripts are not official records. Say which one it is.

### 4. Coverage and gaps
- Check for missing entities and years (e.g. one municipality without budget data for a year; schools suppressed when fewer than 15–20 pupils).
- Suppressed values ("*", "-99.0", "dado não disponível") are **missing**, never zero. Exclude them from averages and say how many.
- If a dataset is abandoned (e.g. the BASE OCDS feed, frozen since 2020; the `api.openar.pt` API, archived in 2026), do not mix it with live data.

### 5. Small numbers and outliers
- One large item can dominate a total: in Arouca one project (Parque da Saúde) was 35% of 2025 contracts. Say so whenever one item is more than ~20% of the total.
- Small populations make per-capita figures jumpy. Rank small and large places together only with a caveat, or group by size.
- Show uncertainty or the sample size where it exists (e.g. "observed vs expected" school indicators with few pupils).

### 6. Entities and duplicates
- The same supplier, school or body appears under different names → match on an identifier (tax number NIF/NIPC, DGEEC school code, INE geography code), not on the name.
- Check for duplicates across files (yearly files that overlap, the same contract amended later).
- Classification codes can be unreliable (CPV codes in contracts): use them as a signal, verify, and report the share still "under review".
- Never publish personal data of private individuals. Mask personal tax numbers; councillors and officials acting in public roles are fine.

### 7. Fair comparison
- Compare like with like: same period, same definition, same unit, similar size or context.
- Prefer context-adjusted indicators to raw rankings when they exist (e.g. schools' "observed vs expected for a similar profile").
- Present patterns as patterns, not accusations ("grades above the expected profile", not "grade inflation by school X").

### 8. Licence and attribution
- Record the licence of **each** dataset or resource; on dados.gov.pt the same dataset can appear with different licences.
- Typical cases: Portal BASE `other-pd` (public domain); INE `cc-by` (cite INE + indicator code); IPMA no commercial use; Eurostat and ECB free incl. commercial with attribution; Assembleia da República attribution required.
- If the licence is `notspecified` or unclear, say so and do not put the data in a commercial product until it is confirmed.

## Output template

End every data answer or page with a block like this:

```
Sources: Portal BASE/IMPIC via dados.gov.pt (contracts 2025, public domain) · INE, resident population 2023 (indicator 0008273, CC BY)
Extracted: 2026-11-02
Method: value of 2025 contracts ÷ 2023 resident population
Caveats: different reference years; contracts ≠ total spending; one project = 35% of Arouca's total
```

## Quick pass (when time is short)
Year? Unit? What exactly does it measure? Anything missing? One item dominating? Same entity counted twice? Fair comparison? Licence? — If any answer is "not sure", say so in the output.
