<div align="center">

# apis-publicas-pt

**Os dados públicos de Portugal e da UE, prontos para o teu agente de IA.**

Três skills para Claude, Claude Code e outros agentes que leem `SKILL.md`: um catálogo curado de APIs de dados abertos de Portugal e da UE, uma lista de verificações que impede o agente de publicar um número enganador, e um guia para as reuniões das câmaras e assembleias municipais.

[![Licença: MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-2fa36b)](LICENSE)
[![Verificado em](https://img.shields.io/badge/verificado-2026--11--02-2fa36b)](skills/apis-publicas-pt/SKILL.md)
[![Endpoints](https://github.com/jorgesousa/apis-publicas-pt/actions/workflows/check-endpoints.yml/badge.svg)](https://github.com/jorgesousa/apis-publicas-pt/actions/workflows/check-endpoints.yml)

<img src="docs/demo.gif" alt="Demonstração: perante 'Quanto gasta Arouca por habitante em contratos públicos? Compara com Coimbra.', o agente escolhe o dados.gov.pt e o INE, faz as chamadas reais, verifica anos e licenças e responde com fontes" width="860">

**[Read in English](README.md)**

</div>

---

## As três skills

| Skill | O que faz |
|---|---|
| [`apis-publicas-pt`](skills/apis-publicas-pt/SKILL.md) | Catálogo de 13 fontes (mais a norma OParl) — estatística oficial, meteorologia, bancos centrais, contratação pública, parlamento e câmaras municipais — cada uma com endpoint, autenticação, licença, limites, armadilhas e um exemplo que funciona. |
| [`verificar-dados-publicos`](skills/verificar-dados-publicos/SKILL.md) | Oito verificações antes de publicar um número com dados públicos: anos de referência, unidades, o que o número mede, lacunas, valores extremos, entidades duplicadas, comparação justa e licença. |
| [`reunioes-municipais-pt`](skills/reunioes-municipais-pt/SKILL.md) | Reuniões de câmara e assembleia municipal: o MCP público do OpenCouncil onde existe, atas e vídeos oficiais nos outros municípios, um pipeline de transcrição, as regras de privacidade da CNPD e o modelo de dados OParl. |

Funcionam sozinhas, mas foram feitas para andar juntas: o catálogo encontra e chama os dados, a verificação garante que a resposta é honesta sobre eles, e o guia das reuniões cobre o que as câmaras discutem e decidem.

As skills estão escritas em inglês para chegarem a mais gente, mas mantêm os nomes oficiais portugueses e reagem a pedidos em português. O agente responde na tua língua.

## Porquê

O catálogo de APIs mais conhecido do GitHub, [public-apis](https://github.com/public-apis/public-apis), tem mais de 2 000 entradas. Para Portugal quase nada:

| Fonte | public-apis | apis-publicas-pt |
|---|:---:|:---:|
| dados.gov.pt | ✅ | ✅ |
| IPMA | ✅ | ✅ |
| INE, incluindo receitas e despesas das câmaras | ❌ | ✅ |
| Banco de Portugal (BPstat) | ❌ | ✅ |
| Assembleia da República | ❌ | ✅ |
| OpenCouncil Portugal (reuniões de câmara) | ❌ | ✅ |
| Eurostat | ❌ | ✅ |
| Banco Central Europeu | ❌ | ✅ |
| TED (contratos públicos da UE) | ❌ | ✅ |

E um link não chega. Antes de construir alguma coisa precisas de saber se a API pede chave, se podes usar os dados num produto comercial e onde estão as armadilhas — como as finanças municipais do INE virem em **milhares** de euros, ou o Eurostat devolver vazio o "último ano". É isso que estas skills dão ao teu agente.

## O que está no catálogo

| Fonte | O que tens lá | Chave | Licença | Estado |
|---|---|:---:|---|---|
| [dados.gov.pt](https://dados.gov.pt) | Portal nacional de dados abertos (contratos do Portal BASE, câmaras, organismos) | não | por dataset | ✅ |
| [INE](https://www.ine.pt) | Estatística oficial: população, receitas e despesas das câmaras | não | CC BY | ✅ |
| [IPMA](https://api.ipma.pt) | Previsão, avisos, sismos, risco de incêndio | não | ⚠ sem fins lucrativos | ✅ |
| [Banco de Portugal](https://bpstat.bportugal.pt) | BPstat: séries económicas e financeiras | não | reutilização livre (SEBC) | ✅ |
| [GeoAPI.pt](https://geoapi.pt) | Municípios, freguesias, códigos postais (não oficial) | não | não indicada | ✅ |
| [Assembleia da República](https://www.parlamento.pt/Cidadania/Paginas/DadosAbertos.aspx) | Iniciativas, votações, debates, deputados (ficheiros XML/JSON) | não | atribuição obrigatória | ✅ |
| [OpenCouncil Portugal](https://pt.opencouncil.eu) | Reuniões de câmara transcritas, com servidor MCP público (para já, Cascais) | não | reutilização livre | ✅ |
| [Eurostat](https://ec.europa.eu/eurostat) | Estatística europeia (JSON-stat, SDMX) | não | livre, incl. comercial | ✅ |
| [BCE](https://data.ecb.europa.eu) | Câmbios, taxas de juro, agregados monetários | não | livre, incl. comercial | ✅ |
| [TED](https://ted.europa.eu) | Contratos públicos acima dos limiares europeus | não | por confirmar | ✅ |
| [data.europa.eu](https://data.europa.eu) | Portal europeu de dados | não | por dataset | 🔍 |
| [Open-Meteo](https://open-meteo.com) | Meteorologia global | não | ⚠ não comercial | ✅ |
| OParl | Modelo de dados para informação municipal (norma de referência) | — | — | 📐 |
| Transparência SNS | Dados do Serviço Nacional de Saúde | — | — | 🔍 |

✅ endpoint respondeu na [verificação semanal](.github/workflows/check-endpoints.yml) · 🔍 responde, mas faltam confirmar detalhes da consulta · 📐 é uma norma, não uma fonte de dados.

## Instalar

### claude.ai (web, desktop, telemóvel)
1. Descarrega os zips de [`dist/`](dist/): [`apis-publicas-pt.zip`](dist/apis-publicas-pt.zip), [`verificar-dados-publicos.zip`](dist/verificar-dados-publicos.zip) e [`reunioes-municipais-pt.zip`](dist/reunioes-municipais-pt.zip).
2. Carrega-os na secção de skills das definições do claude.ai.
3. Se o teu plano limitar o acesso à rede, permite os domínios de que precisas (ver [Rede](#rede)).

### Claude Code
```bash
git clone https://github.com/jorgesousa/apis-publicas-pt.git
mkdir -p ~/.claude/skills
cp -r apis-publicas-pt/skills/* ~/.claude/skills/
```
Para um só projeto, copia as pastas para `.claude/skills/` dentro do projeto.

### Com a CLI `skills` (Claude Code, Cursor, Codex e outros agentes)
```bash
npx skills add jorgesousa/apis-publicas-pt
```

## Experimenta

Depois de instaladas, as skills entram sozinhas quando o pedido envolve dados públicos portugueses ou europeus:

- "Qual era a população residente em Coimbra em 2023? Cita a fonte."
- "Quanto gastou a Câmara de Arouca em 2023 e quanto veio de receitas próprias?"
- "Compara os contratos públicos por habitante de Arouca e Coimbra em 2025."
- "O que discutiu a Câmara de Cascais sobre habitação este ano? Cita os vereadores."
- "Onde encontro as atas e os vídeos da Assembleia Municipal de Matosinhos?"
- "Posso usar os dados do IPMA numa app paga?"

## Rede

As skills não fazem pedidos sozinhas: dizem ao agente onde e como pedir. Se o teu ambiente só deixar sair para domínios autorizados, o catálogo usa:

`dados.gov.pt` · `www.ine.pt` · `api.ipma.pt` · `bpstat.bportugal.pt` · `json.geoapi.pt` · `www.parlamento.pt` · `app.parlamento.pt` · `pt.opencouncil.eu` · `ec.europa.eu` · `data-api.ecb.europa.eu` · `api.ted.europa.eu` · `data.europa.eu` · `api.open-meteo.com`

Se um domínio estiver bloqueado, a skill manda o agente parar e dizer qual é, em vez de tentar contornar o bloqueio.

## Segurança e princípios

- **Só texto.** Cada skill é um único `SKILL.md`. Não instala nada, não corre scripts, não tem dependências.
- **Zero chaves.** Todas as fontes leem-se sem registo. O agente é instruído a nunca pôr credenciais em URLs ou ficheiros.
- **Licença sempre à vista.** O agente cita a fonte e a data, e avisa quando uma licença proíbe uso comercial.
- **Honesto sobre o que não sabe.** O que não foi testado está marcado "to verify" e não deve ir para produção.

## Manter o catálogo atual

- **Verificação semanal:** um [workflow do GitHub Actions](.github/workflows/check-endpoints.yml) chama todos os endpoints às segundas-feiras e publica o resultado. Localmente: `./scripts/check-endpoints.sh`.
- **Data de verificação:** cada versão diz quando foi verificada. Entradas com mais de 6 meses são reverificadas antes de se confiar nelas.

## Contribuir

Falta uma fonte? Abre um issue ou um pull request. Uma fonte só entra com: endpoint testado (ou marcado "to verify"), autenticação, licença com link para os termos, limites (ou "not published"), um exemplo de chamada e a data da verificação. Depois de editar um `SKILL.md`, gera os zips com `./scripts/build-zip.sh`.

## Licença

[MIT](LICENSE) © 2026 Jorge Sousa · [Tosco Labs](https://github.com/jorgesousa)

Este projeto não tem ligação a nenhuma das fontes listadas. Os dados pertencem a cada fonte e seguem os termos de cada uma.
