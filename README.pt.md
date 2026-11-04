<div align="center">

# portugal-open-data

**Os dados públicos de Portugal, prontos para o teu agente de IA.**

Onze skills para Claude, Claude Code e outros agentes que leem `SKILL.md`: uma porta de entrada para as fontes de dados abertos de Portugal e da UE, nove skills de domínio que sabem onde está cada tipo de dado e onde engana, e uma lista de verificações que impede o agente de publicar um número enganador.

[![Licença: MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-2fa36b)](LICENSE)
[![Verificado em](https://img.shields.io/badge/verificado-2026--11--04-2fa36b)](skills/portugal-open-data/SKILL.md)
[![Endpoints](https://github.com/jorgesousa/portugal-open-data/actions/workflows/check-endpoints.yml/badge.svg)](https://github.com/jorgesousa/portugal-open-data/actions/workflows/check-endpoints.yml)

<img src="docs/demo.gif" alt="Demonstração gravada com a versão 1: encontrar a fonte do INE para a população por município, verificar um gráfico antes de o publicar, e encontrar os vídeos e as atas das reuniões de Matosinhos" width="860">

<sub>Demonstração gravada com a versão 1 (três skills, nomes antigos).</sub>

**[Read in English](README.md)**

</div>

---

## As skills

| Skill | O que cobre |
|---|---|
| [`portugal-open-data`](skills/portugal-open-data/SKILL.md) | **Começa aqui.** Regras para chamar fontes públicas, as fontes gerais (dados.gov.pt, INE, IPMA, Banco de Portugal, Parlamento, Eurostat, BCE) e qual a skill de domínio a usar. |
| [`pt-data-checks`](skills/pt-data-checks/SKILL.md) | Oito verificações antes de publicar um número: anos de referência, unidades, o que mede, lacunas, extremos, entidades duplicadas, comparação justa, licença. |
| [`pt-public-procurement`](skills/pt-public-procurement/SKILL.md) | Contratos, anúncios, modificações e entidades do Portal BASE; TED. Significado e preenchimento de cada campo, ano de celebração vs data de publicação, fornecedores por NIF. |
| [`pt-territory`](skills/pt-territory/SKILL.md) | Limites da CAOP, códigos de concelhos e freguesias, NUTS, a reposição de freguesias de 2025, projeções, BUPi. |
| [`pt-schools`](skills/pt-schools/SKILL.md) | Ficheiros do InfoEscolas para todas as escolas: "observado vs esperado" para alunos de perfil semelhante, retenção, classificações internas, equidade. |
| [`pt-local-finance`](skills/pt-local-finance/SKILL.md) | Receitas, despesas e dívida das câmaras (INE/DGAL), orçamentos, transferências, IMI — e porque contratos não são despesa. |
| [`pt-council-meetings`](skills/pt-council-meetings/SKILL.md) | Reuniões de câmara e assembleia: MCP público do OpenCouncil, atas e vídeos oficiais, transcrição, regras da CNPD, OParl. |
| [`pt-web-archive`](skills/pt-web-archive/SKILL.md) | Arquivo.pt: pesquisa de texto e histórico de versões dos sites portugueses desde 1996. |
| [`pt-mobility`](skills/pt-mobility/SKILL.md) | Horários GTFS e NeTEx por operador, bicicletas partilhadas, carregamento elétrico, redes rodoviária e ferroviária. |
| [`pt-health`](skills/pt-health/SKILL.md) | Transparência SNS, ACSS, INFARMED, INEM; cópias duplicadas com licenças diferentes; listas de profissionais como dados pessoais. |
| [`pt-environment`](skills/pt-environment/SKILL.md) | Água e ar da APA, emissões, risco de inundação, incêndios rurais, proteção civil. |

A porta de entrada encaminha, as skills de domínio vão ao detalhe e a verificação garante que a resposta é honesta. Cada skill só é carregada quando um pedido precisa dela, por isso instalar todas não custa nada até serem usadas.

As skills estão escritas em inglês para chegarem a mais gente, mas mantêm os nomes oficiais portugueses e reagem a pedidos em português. O agente responde na tua língua.

## Porquê

O catálogo de APIs mais conhecido do GitHub, [public-apis](https://github.com/public-apis/public-apis), tem mais de 2 000 entradas e quase nada para Portugal. O [devpt-org/public-data-portugal](https://github.com/devpt-org/public-data-portugal) lista 57 fontes portuguesas, como links. Nenhum diz ao teu agente:

- se uma fonte pede chave, e se a podes usar num produto comercial;
- que as finanças municipais do INE vêm em **milhares** de euros;
- que o campo `Ano` do Portal BASE é o ano em que o contrato foi **celebrado**, não publicado, e que o preço efetivamente pago só está preenchido em 8% dos contratos;
- que os resultados das escolas só fazem sentido comparados com alunos de **perfil semelhante**, e que `*` quer dizer suprimido, não zero;
- que um feed GTFS pode expirar na próxima semana, ou que uma lista de psicólogos com licença aberta continua a ser dados pessoais.

É isso que estas skills levam. Cada armadilha vem de trabalho real, com a data em que foi verificada.

## Instalar

### Claude Code (plugin)
```
/plugin marketplace add jorgesousa/portugal-open-data
/plugin install portugal-open-data@portugal-open-data
```
As skills aparecem como `portugal-open-data:pt-schools`, `portugal-open-data:pt-public-procurement`, etc.

### claude.ai (web, desktop, telemóvel)
1. Descarrega os zips em [`dist/`](dist/) — um por skill. Começa por `portugal-open-data.zip` e `pt-data-checks.zip` e junta os domínios de que precisas.
2. Carrega-os na secção de skills das definições do claude.ai.
3. Se o teu plano restringe o acesso à rede, autoriza os domínios que cada skill indica.

### Outros agentes (CLI `skills`: Cursor, Codex e outros)
```bash
npx skills add jorgesousa/portugal-open-data
```

### À mão
```bash
git clone https://github.com/jorgesousa/portugal-open-data.git
mkdir -p ~/.claude/skills && cp -r portugal-open-data/skills/* ~/.claude/skills/
```

## Experimenta

Pergunta em português ou em inglês:

- "Qual era a população residente de Coimbra em 2023? Indica a fonte."
- "Que fornecedores receberam mais da Câmara de Arouca em 2025? Junta-os por NIF."
- "Compara de forma justa as escolas secundárias de Coimbra."
- "Quanto deve a Câmara de Braga por habitante, comparada com municípios parecidos?"
- "O que dizia o site da Câmara de Coimbra sobre o Metro Mondego em 2015?"
- "Quantas partidas de autocarro tem esta freguesia num dia útil?"
- "Posso usar dados do IPMA numa app paga?"

## Rede

As skills não fazem pedidos: dizem ao agente onde e como pedir. Cada skill indica os domínios que usa. Se um domínio estiver bloqueado, o agente tem instruções para parar e dizer qual é, nunca para contornar o bloqueio.

## Princípios

- **Só texto.** Cada skill é um `SKILL.md`, às vezes com um ficheiro de referência. Sem scripts para correr, sem dependências, sem chaves.
- **Licenças à vista.** Cada resposta cita fonte, licença e data de extração.
- **Honestas sobre o que falta.** O que não foi testado fica marcado "to verify".
- **Sem dados pessoais.** Listas de pessoas identificadas são agregadas, nunca republicadas para outro fim.

## Manter atualizado

- **Verificação semanal:** um [workflow do GitHub Actions](.github/workflows/check-endpoints.yml) chama todos os endpoints às segundas. Localmente: `./scripts/check-endpoints.sh`.
- **Validação:** `python3 scripts/validate-skills.py` verifica nomes, descrições, tamanhos e links; corre em cada pull request.
- **Data de verificação:** cada skill tem `metadata.verified`. Volta a verificar o que tiver mais de seis meses antes de confiar.

## Contribuir

Uma fonte só entra com endpoint testado (ou marcado "to verify"), autenticação, licença com link para os termos, limites (ou "não publicados"), um exemplo e a data de verificação. Fontes de um domínio vão para a skill desse domínio; as gerais para `portugal-open-data`. Depois de editar, corre `python3 scripts/validate-skills.py` e `./scripts/build-zip.sh`.

## Estrutura

```
.claude-plugin/            manifestos do plugin e do marketplace
skills/<nome>/SKILL.md     uma pasta por skill (algumas com references/)
dist/*.zip                 as mesmas skills, um zip cada, para o claude.ai
scripts/                   verificação de endpoints, validador, criação dos zips
.github/workflows/         verificação semanal e validação dos pull requests
docs/                      imagens do README
README.md                  README em inglês
```

## O que mudou desde `apis-publicas-pt`

A versão 2.0.0 muda o nome do projeto e divide o antigo catálogo numa porta de entrada e em skills de domínio. `apis-publicas-pt` → `portugal-open-data`, `verificar-dados-publicos` → `pt-data-checks`, `reunioes-municipais-pt` → `pt-council-meetings`. Se instalaste os zips antigos, remove-os e instala os novos.

## Licença

[MIT](LICENSE) © 2026 [Jorge Sousa](https://github.com/jorgesousa)

Sem ligação a nenhuma das fontes. Os dados pertencem a cada fonte e seguem os seus próprios termos.
