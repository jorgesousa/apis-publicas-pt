<div align="center">

# apis-publicas-pt

**As APIs públicas de Portugal e da União Europeia, prontas para o teu agente.**

Uma skill para Claude e Claude Code com um catálogo curado de fontes de dados abertos: dados.gov.pt, INE, IPMA, Banco de Portugal, Eurostat, BCE, TED e mais. Cada fonte vem com endpoint, autenticação, licença, limites e um exemplo pronto a correr.

[![Licença: MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-2fa36b)](LICENSE)
[![Verificado em](https://img.shields.io/badge/verificado-2026--11--02-2fa36b)](skills/apis-publicas-pt/SKILL.md)
[![Endpoints](https://github.com/jorgesousa/apis-publicas-pt/actions/workflows/check-endpoints.yml/badge.svg)](https://github.com/jorgesousa/apis-publicas-pt/actions/workflows/check-endpoints.yml)

<img src="docs/demo.gif" alt="Demonstração: o agente responde a 'Quanto gasta Arouca por habitante em contratos públicos? Compara com Coimbra.' escolhendo o dados.gov.pt e o INE, fazendo as chamadas reais, verificando anos e licenças e mostrando o resultado com fontes" width="860">

[English summary below](#english)

</div>

---

## Porquê

O catálogo de APIs mais conhecido do GitHub, [public-apis](https://github.com/public-apis/public-apis), tem mais de 2 000 entradas. Para Portugal quase nada:

| Fonte | public-apis | apis-publicas-pt |
|---|:---:|:---:|
| dados.gov.pt | ✅ | ✅ |
| IPMA | ✅ | ✅ |
| INE | ❌ | ✅ |
| Banco de Portugal (BPstat) | ❌ | ✅ |
| Eurostat | ❌ | ✅ |
| Banco Central Europeu | ❌ | ✅ |
| TED (contratos públicos da UE) | ❌ | ✅ |

E um link não chega. Antes de construir alguma coisa precisas de saber se a API pede chave, se podes usar os dados num produto comercial e onde estão as armadilhas. É isso que esta skill dá ao teu agente.

## O que está no catálogo

| Fonte | O que tens lá | Chave | Licença | Estado |
|---|---|:---:|---|---|
| [dados.gov.pt](https://dados.gov.pt) | Portal nacional de dados abertos (contratos BASE, câmaras, organismos) | não | por dataset | ✅ verificada |
| [INE](https://www.ine.pt) | Estatística oficial: população, demografia, economia por município | não | citar a fonte | ✅ verificada |
| [IPMA](https://api.ipma.pt) | Previsão, avisos, sismos, risco de incêndio | não | ⚠ sem fins lucrativos | ✅ verificada |
| [Banco de Portugal](https://bpstat.bportugal.pt) | BPstat: séries económicas e financeiras | não | reutilização livre (SEBC) | ✅ verificada |
| [GeoAPI.pt](https://geoapi.pt) | Municípios, freguesias, códigos postais (projeto não oficial) | não | não indicada | 📄 documentação |
| [Eurostat](https://ec.europa.eu/eurostat) | Estatística europeia (JSON-stat, SDMX) | não | livre, incl. comercial | ✅ verificada |
| [BCE](https://data.ecb.europa.eu) | Câmbios, taxas de juro, agregados monetários | não | livre, incl. comercial | 📄 documentação |
| [TED](https://ted.europa.eu) | Contratos públicos acima dos limiares europeus | não | por confirmar | 📄 documentação |
| [Open-Meteo](https://open-meteo.com) | Meteorologia global | não | ⚠ não comercial | 📄 documentação |
| Transparência SNS · Parlamento · data.europa.eu | — | — | — | 🔍 por verificar |

**Legenda:** ✅ endpoint chamado com sucesso · 📄 confirmado na documentação oficial · 🔍 ainda por testar.

## Instalar

### claude.ai (web, desktop, telemóvel)
1. Descarrega [`dist/apis-publicas-pt.zip`](dist/apis-publicas-pt.zip).
2. Nas definições do claude.ai, na secção de skills, carrega o zip.
3. Se o teu plano tiver controlo de acesso à rede, permite os domínios de que precisas (ver [Rede](#rede)).

### Claude Code
```bash
git clone https://github.com/jorgesousa/apis-publicas-pt.git
mkdir -p ~/.claude/skills
cp -r apis-publicas-pt/skills/apis-publicas-pt ~/.claude/skills/
```
Para um só projeto, copia a pasta para `.claude/skills/` dentro do projeto.

### Com a CLI `skills` (Claude Code, Cursor, Codex e outros agentes)
```bash
npx skills add jorgesousa/apis-publicas-pt
```

## Experimenta

Depois de instalada, a skill entra sozinha quando o pedido envolve dados públicos portugueses ou europeus:

- "Qual era a população residente em Coimbra em 2023? Cita a fonte."
- "Vai chover amanhã no Porto?"
- "Que datasets de contratos públicos existem no dados.gov.pt? Quais têm licença aberta?"
- "Compara o câmbio euro-dólar deste ano com o do ano passado."
- "Posso usar os dados do IPMA numa app paga?"

## Rede

A skill não faz pedidos sozinha: diz ao agente onde e como pedir. Se o teu ambiente só deixar sair para domínios autorizados, estes são os que o catálogo usa:

`dados.gov.pt` · `www.ine.pt` · `api.ipma.pt` · `bpstat.bportugal.pt` · `json.geoapi.pt` · `ec.europa.eu` · `data-api.ecb.europa.eu` · `api.ted.europa.eu` · `data.europa.eu` · `api.open-meteo.com`

Se um domínio estiver bloqueado, a skill manda o agente parar e dizer-te qual é, em vez de tentar contornar o bloqueio.

## Segurança e princípios

- **Só texto.** A skill é um único `SKILL.md`. Não instala nada, não corre scripts, não tem dependências.
- **Zero chaves.** Todas as fontes leem-se sem registo. O agente é instruído a nunca pôr credenciais em URLs ou ficheiros.
- **Licença sempre à vista.** O agente cita a fonte e a data, e avisa quando uma licença proíbe uso comercial.
- **Honesto sobre o que não sabe.** O que não foi testado está marcado "por verificar" e não deve ir para produção.

## Manter o catálogo atual

As APIs públicas mudam. Por isso:

- **Verificação semanal:** um [workflow do GitHub Actions](.github/workflows/check-endpoints.yml) chama todos os endpoints às segundas-feiras e publica o resultado. Também podes correr `./scripts/check-endpoints.sh` localmente.
- **Data de verificação:** cada versão diz quando foi verificada. Entradas com mais de 6 meses são reverificadas antes de se confiar nelas.

## Contribuir

Falta uma fonte? Abre um issue ou um pull request. Uma API só entra com:

1. endpoint testado (ou marcado "por verificar");
2. autenticação;
3. licença, com link para os termos;
4. limites (ou "não publicados");
5. um exemplo de chamada;
6. a data da verificação.

Depois de editar o `SKILL.md`, gera o zip para o claude.ai com `./scripts/build-zip.sh`.

## Estrutura

```
skills/apis-publicas-pt/SKILL.md   a skill (o único ficheiro que o agente lê)
dist/apis-publicas-pt.zip          a mesma skill, pronta a carregar no claude.ai
scripts/check-endpoints.sh         verifica se as fontes respondem
scripts/build-zip.sh               gera o zip
.github/workflows/                 verificação semanal
docs/                              GIF e imagem do README
```

---

<a id="english"></a>
## English

**apis-publicas-pt** is a Claude skill (also works with Claude Code and other agents that support `SKILL.md`) with a curated catalog of Portuguese and EU open-data APIs: dados.gov.pt, INE (Statistics Portugal), IPMA (weather), Banco de Portugal, Eurostat, the European Central Bank, TED and more.

The popular [public-apis](https://github.com/public-apis/public-apis) list has 2,000+ entries but no INE, Banco de Portugal or ECB. This skill fills that gap and goes further than a link: for every source the agent gets the endpoint, whether a key is needed (none are), the licence (and whether commercial use is allowed), known limits and pitfalls, and a ready-to-run example.

- **Install:** upload `dist/apis-publicas-pt.zip` in your claude.ai skill settings, copy `skills/apis-publicas-pt` to `~/.claude/skills/`, or run `npx skills add jorgesousa/apis-publicas-pt`.
- **Safe by design:** a single markdown file. No scripts, no dependencies, no credentials.
- **Kept fresh:** a weekly GitHub Action checks every endpoint.
- The skill is written in Portuguese; agents read it fine and answer in your language.

## Licença

[MIT](LICENSE) © 2026 Jorge Sousa · [Tosco Labs](https://github.com/jorgesousa)

Este projeto não tem ligação a nenhuma das entidades listadas. Os dados pertencem a cada fonte e seguem os termos de cada uma.
