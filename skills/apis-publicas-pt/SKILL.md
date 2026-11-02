---
name: apis-publicas-pt
description: Catálogo curado de APIs públicas portuguesas e europeias (dados.gov.pt, INE, IPMA, Banco de Portugal, Eurostat, BCE, TED…) com endpoint, autenticação, licença, limites e exemplo de chamada. Usar ao escolher, citar ou chamar fontes de dados abertos de Portugal ou da UE. Curated catalog of Portuguese and EU open-data APIs.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-02"
---

# APIs públicas PT/UE

Catálogo curto e verificado de fontes de dados abertos de Portugal e da União Europeia. O valor está na curadoria (licença, limites, armadilhas), não na quantidade. Para o que não estiver aqui, procurar primeiro no catálogo do próprio dados.gov.pt e, só depois, em github.com/public-apis/public-apis (quase não tem fontes estatísticas PT/UE).

Última verificação: 2026-11-02. Entradas com mais de 6 meses devem ser reverificadas antes de se construir em cima delas.

## Regras

1. **Esta skill não dá acesso à rede.** Só descreve as APIs. Se o ambiente tiver uma lista de domínios permitidos, o acesso depende dela.
2. **Testar com uma chamada antes de construir.** Se o pedido for recusado pelo ambiente (por exemplo `CONNECT tunnel failed, response 403`, ou um erro de domínio não permitido), parar, dizer ao utilizador qual é o domínio exato e esperar pela decisão. Não tentar contornar (outro comando, mirror, cache, proxy) e não alterar permissões de rede.
3. **Sem credenciais.** Todas as APIs deste catálogo leem-se sem chave. Se alguma passar a pedir chave, perguntar ao utilizador; nunca colar chaves em URLs nem em ficheiros versionados.
4. **Licença e atribuição em cada produto.** Mostrar sempre "Fonte: …" e a data de extração. No dados.gov.pt a licença é por dataset (campo `license`); `notspecified` = confirmar antes de publicar.
5. **Ano de referência explícito.** A estatística oficial tem atraso (INE e Eurostat publicam o ano N em N+1 ou N+2). Nunca usar "último período" sem verificar se tem valores.
6. **Guardar o bruto.** Descarregar para ficheiro (csv/json/parquet) e calcular em código; não paginar resultados grandes pela conversa.

## Rede: domínios usados

Se o ambiente usar uma lista de domínios permitidos, estes são os necessários (pedir ao utilizador só os que o trabalho precisar):

| Fonte | Domínio |
|---|---|
| dados.gov.pt | `dados.gov.pt` |
| INE | `www.ine.pt` |
| IPMA | `api.ipma.pt` |
| Banco de Portugal | `bpstat.bportugal.pt` |
| GeoAPI.pt | `json.geoapi.pt` |
| Eurostat | `ec.europa.eu` |
| BCE | `data-api.ecb.europa.eu` |
| TED | `api.ted.europa.eu` |
| data.europa.eu | `data.europa.eu` |
| Open-Meteo | `api.open-meteo.com` |

## Portugal

### dados.gov.pt — portal nacional de dados abertos (API udata v1)
- **Endpoint:** `https://dados.gov.pt/api/1/` (Swagger: `/api/1/swagger.json`)
- **Autenticação:** nenhuma para ler. A escrita exige `X-API-KEY` (fora do âmbito desta skill).
- **Licença:** por dataset (`license`: `cc-by`, `other-open`, `notspecified`, …).
- **Limites:** não documentados. Paginação via `page`, `page_size` e `next_page` (seguir o URL de `next_page`, não calcular páginas).
- **Bom para:** contratos públicos (Portal BASE/IMPIC, ficheiros anuais), descobrir datasets de câmaras e organismos.
- **Exemplo:**
  ```bash
  curl -s "https://dados.gov.pt/api/1/datasets/?q=contratos%20publicos&page_size=5"
  curl -s "https://dados.gov.pt/api/1/datasets/{id_ou_slug}/"   # resources[].url = ficheiros para descarregar
  ```

### INE — Instituto Nacional de Estatística
- **Endpoint:** `https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd={código}&lang=PT|EN&Dim1=…&Dim2=…`
- **Autenticação:** nenhuma.
- **Licença:** termos não confirmados na última verificação; citar "Fonte: INE" e o código do indicador.
- **Limites:** sem limite publicado; indicadores grandes devolvem respostas enormes → filtrar sempre por `Dim1` (período) e outras dimensões. O campo `MetaInfUrl` da resposta aponta para os metadados.
- **Resposta:** lista com `IndicadorCod`, `IndicadorDsg`, `DataUltimoAtualizacao`, `UltimoPref` e `Dados{ano:[{geocod, geodsg, dim_3, dim_4, valor}]}`.
- **Bom para:** população por município (valores per capita), indicadores sociais e económicos regionais.
- **Exemplo (população residente, 2023):**
  ```bash
  curl -s "https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0008273&Dim1=S7A2023&lang=PT"
  ```

### IPMA — meteorologia, avisos, sismos, risco de incêndio
- **Endpoint:** `https://api.ipma.pt/open-data/`
- **Autenticação:** nenhuma. O IPMA pede um email a webmaster@ipma.pt a descrever o uso (para estatística interna).
- **Licença/termos:** uso gratuito para fins pessoais ou públicos **sem fins lucrativos**; citar sempre a fonte; logótipo com link em páginas web. ⚠ Um produto comercial precisa de autorização ou de outra fonte.
- **Limites:** não publicados. Previsões 2×/dia (00 e 12 UTC); observações horárias; horas em UTC; `-99.0` = sem dados.
- **Endpoints úteis:** `forecast/meteorology/cities/daily/{globalIdLocal}.json` (5 dias), `forecast/warnings/warnings_www.json`, `observation/seismic/{3|7}.json` (3 = Açores, 7 = Continente e Madeira), `forecast/meteorology/rcm/rcm-d{0..2}.json` (risco de incêndio), CSV diários por concelho em `observation/climate/…`. IDs de locais em `distrits-islands.json`.
- **Exemplo (Coimbra, globalIdLocal 1060300):**
  ```bash
  curl -s "https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/1060300.json"
  ```

### Banco de Portugal — BPstat
- **Endpoint:** `https://bpstat.bportugal.pt/data/v1`
- **Autenticação:** nenhuma.
- **Licença:** estatísticas do SEBC — reutilização gratuita, incluindo comercial, citando a fonte e sem alterar os dados (confirmar que se aplica ao BPstat antes de publicar).
- **Limites:** não publicados. Paginação em `extension.next_page`.
- **Endpoints:** `/domains`, `/domains/{d}/datasets`, `/domains/{d}/datasets/{ds}` (observações, JSON-stat), `/domains/{d}/dimensions`, `/series`. Parâmetros: `lang`, `series_ids`, `obs_since`, `obs_to`, `obs_last_n`, `obs_published_since`.
- **Exemplo:**
  ```bash
  curl -s "https://bpstat.bportugal.pt/data/v1/domains/?lang=PT"
  curl -s "https://bpstat.bportugal.pt/data/v1/domains/54/datasets/ce3e4e50cda325537eff729ef64037cd?lang=PT&series_ids=12518356&obs_last_n=12"
  ```

### GeoAPI.pt — divisões administrativas, códigos postais, censos
- **Endpoint:** `https://json.geoapi.pt/` (documentação em geoapi.pt/docs)
- **Autenticação:** nenhuma na API JSON.
- **Licença:** não indicada. Fontes: CAOP 2024.1 (DGT), CTT/INE (códigos postais), Censos 2011/2021, IPMA, APA. Projeto não oficial → bom para prototipar; em produção, preferir a fonte oficial (CAOP/DGT, INE).
- **Limites:** não publicados.
- **Exemplo:** `curl -s "https://json.geoapi.pt/municipio/coimbra"` (caminho a confirmar na documentação).

### Por verificar (não usar em produção antes de testar)
- **Transparência SNS** — `https://transparencia.sns.gov.pt/api/explore/v2.1/` (plataforma Opendatasoft). Licença e limites por confirmar.
- **Parlamento** — dados abertos da Assembleia da República (ficheiros JSON/XML por legislatura).

## União Europeia

### Eurostat — Statistics API
- **Endpoint:** `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/{dataset}?{filtros}` (JSON-stat 2.0). SDMX 2.1/3.0 em `/api/dissemination/sdmx/…`.
- **Autenticação:** nenhuma.
- **Licença:** reutilização livre, incluindo comercial (Decisão 2011/833/UE; conteúdos editoriais CC BY 4.0). Citar a fonte e indicar alterações. Exceções: dados de terceiros e de países fora da UE, EFTA e candidatos.
- **Limites:** sem limite publicado; pedidos grandes demoram minutos → usar o endpoint assíncrono. Atualização 2×/dia (11:00 e 23:00 CET). Línguas: EN, FR, DE.
- **Armadilha verificada:** `lastTimePeriod=1` pode devolver o ano mais recente **vazio** (`value: {}`). Pedir um intervalo e escolher o último ano com valores.
- **Exemplo (população, NUTS 3 Região de Aveiro):**
  ```bash
  curl -s "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_r_pjanaggr3?geo=PT16D&sex=T&age=TOTAL&sinceTimePeriod=2020"
  ```

### Banco Central Europeu — ECB Data Portal
- **Endpoint:** `https://data-api.ecb.europa.eu/service/data/{flowRef}/{key}` (SDMX 2.1 REST)
- **Autenticação:** nenhuma referida.
- **Licença:** reutilização gratuita, incluindo comercial; citar "Fonte: estatísticas do BCE"; não modificar os dados.
- **Limites:** não publicados. Parâmetros `startPeriod`, `endPeriod`, `lastNObservations`, `format=jsondata|csvdata`, `detail=dataonly`, `updatedAfter`; `If-Modified-Since` devolve 304.
- **Exemplo (câmbio USD/EUR diário):**
  ```bash
  curl -s "https://data-api.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?startPeriod=2026-01-01&format=csvdata"
  ```

### TED — contratos públicos europeus (acima dos limiares UE)
- **Endpoint:** gateway `https://api.ted.europa.eu/v3/…`; pesquisa em `POST /v3/notices/search` (confirmar no Swagger em api.ted.europa.eu/swagger).
- **Autenticação:** nenhuma para pesquisar anúncios publicados.
- **Licença/limites:** por confirmar no Legal Notice do TED.
- **Bom para:** contratos de maior valor de qualquer país da UE; cruzar com o Portal BASE em Portugal.
- **Exemplo (sintaxe da query a confirmar):**
  ```bash
  curl -s -X POST "https://api.ted.europa.eu/v3/notices/search" \
    -H "Content-Type: application/json" \
    -d '{"query":"buyer-country=PRT","fields":["publication-number","notice-title"],"limit":10}'
  ```

### data.europa.eu — portal europeu de dados (por verificar)
- Catálogo que agrega os portais nacionais (incluindo o dados.gov.pt). Pesquisa em `https://data.europa.eu/api/hub/search/search?q=…`. Licença por dataset. Não testado na última verificação.

### Open-Meteo — meteorologia global (alternativa ao IPMA)
- **Endpoint:** `https://api.open-meteo.com/v1/forecast?latitude=…&longitude=…`
- **Autenticação:** nenhuma.
- **Licença/limites:** grátis só para uso não comercial (600/min, 10 000/dia, 300 000/mês); atribuição CC BY 4.0. Uso comercial = plano pago.

## Quando acrescentar uma API
Só entra no catálogo com: endpoint testado (ou marcado "por verificar"), autenticação, licença com link, limites (ou "não publicados"), exemplo de chamada e data da verificação.
