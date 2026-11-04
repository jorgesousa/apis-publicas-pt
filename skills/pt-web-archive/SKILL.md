---
name: pt-web-archive
description: How to use Arquivo.pt, the Portuguese web archive (sites since 1996), through its public API — full-text search, version history of a URL, archived copies and extracted text — and its ready-made lists of public-body websites. Use to find what a Portuguese site said in the past, recover deleted pages (old council minutes, prices, announcements), or study change over time. Arquivo.pt, páginas antigas, histórico de sites, web archive.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-04"
---

# Arquivo.pt — the Portuguese web archive

Part of the `portugal-open-data` skills. Arquivo.pt (run by FCT/FCCN) has preserved Portuguese websites since 1996. Its API is the most reused source on dados.gov.pt. Use it when the live page is gone or changed: an old council minute, a previous price list, a deleted announcement.

**Domain used:** `arquivo.pt`. Licence of the API dataset on dados.gov.pt: CC BY 4.0. The archived pages keep their original authors' rights: quote and link, do not republish whole pages.

## TextSearch API (verified from the official documentation)

Endpoint: `https://arquivo.pt/textsearch` → JSON.

| Parameter | Meaning |
|---|---|
| `q` | Search terms; `"..."` for phrases, `-word` to exclude. Do not put URLs here (HTTP 400). |
| `versionHistory` | A URL: returns its archived versions, newest first (include the protocol, percent-encode). |
| `from`, `to` | Dates `YYYYMMDDHHMMSS` or shorter (`YYYY`). Default `from` 1996; **default `to` = last year**. |
| `siteSearch` | Restrict to one site (e.g. `cm-coimbra.pt`). |
| `type` | MIME subtype: `pdf`, `html`, `doc`, … |
| `maxItems`, `offset` | Page size (default 50, max 500) and start. Follow `next_page`. |
| `dedupValue`, `dedupField` | Limit items per `site` (default) or `url`. |
| `fields` | Subset of response fields. |
| `prettyPrint` | `false` for compact output. |

Response items: `title`, `originalURL`, `linkToArchive` (the archived copy), `tstamp` (**crawl time in UTC, not publication time**), `date` (crawl, epoch), `linkToExtractedText` (plain text; can be empty), `linkToScreenshot`, `linkToNoFrame`, `linkToOriginalFile`, `mimeType`, `digest`, `snippet` (text search), `collection`. Paging: `next_page`, `previous_page`, `estimated_nr_results` / `total_items`.

```bash
# PDFs mentioning "ata" on a council site in 2015–2018
curl -s "https://arquivo.pt/textsearch?q=ata%20reuni%C3%A3o&siteSearch=cm-matosinhos.pt&type=pdf&from=2015&to=2018&maxItems=20&prettyPrint=false"
# all archived versions of a page
curl -s "https://arquivo.pt/textsearch?versionHistory=https%3A%2F%2Fwww.cm-coimbra.pt%2F&maxItems=50"
```

Also available (documented in the Arquivo.pt wiki, not verified here — test before relying on them): a CDX server for URL lookups (`https://arquivo.pt/wayback/cdx?url=…&output=json`), an image search API, a SPARQL/metadata endpoint, and a Java client (github.com/arquivo/client-java-api). Usage limits are not published: keep requests modest and sequential.

## Traps

1. **Crawl date ≠ publication date.** `tstamp` says when Arquivo.pt saw the page. A 2016 crawl of a minute does not mean the meeting was in 2016. Read the date from the content.
2. **Recent content is not searchable by default.** The default `to` is last year; very recent captures may not be indexed yet.
3. **Coverage is uneven.** Large sites are crawled often; small ones rarely; pages behind forms, logins or heavy JavaScript are often missing. "Not found" means "not archived", not "never existed".
4. **Duplicates.** The same page appears many times; use `digest` to keep only changed versions, or `dedupField=url`.
5. **Text extraction can be empty** for scans and some PDFs; fall back to `linkToOriginalFile` and OCR.
6. **Personal data.** Archived pages can contain personal data that the live site removed. Do not resurface it about private individuals.

## Ready-made lists (Arquivo.pt on dados.gov.pt, CC BY)
Arquivo.pt publishes lists of websites and their version history for groups of public bodies — useful as seed URLs: parishes (freguesias), school clusters, fire brigades, companies, elections (pages collected for each election, e.g. "Eleições Presidenciais 2026: lista de páginas"). Search dados.gov.pt with `organization` = Arquivo.pt (68 datasets).

## Method for "what did site X say about Y in year Z"
1. `textsearch` with `q`, `siteSearch`, `from`/`to`; or `versionHistory` for one known URL.
2. Open `linkToArchive` for the evidence; use `linkToExtractedText` for analysis.
3. Cite as: "Arquivo.pt, copy of <originalURL> captured <tstamp>, <linkToArchive>".
