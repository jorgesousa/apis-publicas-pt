#!/usr/bin/env bash
# Verifica se os endpoints do catálogo respondem.
# Uso: ./scripts/check-endpoints.sh            (tabela no terminal)
#      ./scripts/check-endpoints.sh --markdown (tabela Markdown, para o resumo do GitHub Actions)
# Só faz pedidos GET/POST de leitura, sem credenciais. Sai com código 1 se alguma fonte falhar.

set -u
MARKDOWN=0
[ "${1:-}" = "--markdown" ] && MARKDOWN=1

UA="apis-publicas-pt-healthcheck (+https://github.com/jorgesousa/apis-publicas-pt)"

# nome|método|url
CHECKS=(
  "dados.gov.pt|GET|https://dados.gov.pt/api/1/datasets/?q=contratos&page_size=1"
  "INE|GET|https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=0008273&Dim1=S7A2023&lang=PT"
  "IPMA|GET|https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/1060300.json"
  "Banco de Portugal (BPstat)|GET|https://bpstat.bportugal.pt/data/v1/domains/?lang=PT"
  "GeoAPI.pt|GET|https://json.geoapi.pt/"
  "Eurostat|GET|https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_r_pjanaggr3?geo=PT16D&sex=T&age=TOTAL&sinceTimePeriod=2020"
  "BCE|GET|https://data-api.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?lastNObservations=1&format=csvdata"
  "TED|POST|https://api.ted.europa.eu/v3/notices/search"
  "data.europa.eu|GET|https://data.europa.eu/api/hub/search/search?q=portugal&limit=1"
  "Open-Meteo|GET|https://api.open-meteo.com/v1/forecast?latitude=40.2&longitude=-8.4&current=temperature_2m"
)

fail=0
if [ $MARKDOWN -eq 1 ]; then
  echo "| Fonte | HTTP | Estado |"
  echo "|---|---|---|"
fi

for entry in "${CHECKS[@]}"; do
  IFS='|' read -r name method url <<< "$entry"
  if [ "$method" = "POST" ]; then
    code=$(curl -s -o /dev/null -m 30 -A "$UA" -w '%{http_code}' -X POST \
      -H 'Content-Type: application/json' \
      -d '{"query":"buyer-country=PRT","fields":["publication-number"],"limit":1}' "$url")
  else
    code=$(curl -s -o /dev/null -m 30 -A "$UA" -w '%{http_code}' "$url")
  fi
  if [[ "$code" =~ ^2 ]]; then status="ok"; else status="FALHOU"; fail=1; fi
  if [ $MARKDOWN -eq 1 ]; then
    echo "| $name | $code | $status |"
  else
    printf '%-28s %s  %s\n' "$name" "$code" "$status"
  fi
done

exit $fail
