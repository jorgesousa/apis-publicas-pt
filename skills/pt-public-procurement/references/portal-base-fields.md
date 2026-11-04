# Portal BASE contract fields

Measured on `Contratos2026.json` (201 862 contracts, file of 2026-11-03). "Filled" = not empty, not `None`, not 0. Re-measure for other years: older files can differ.

| Field | Filled | Meaning / notes |
|---|---|---|
| `idcontrato` | 100% | Contract id; key for the modifications file. One duplicate in 2026. |
| `idprocedimento` | 100% | Procedure id (several contracts can share one, e.g. lots). |
| `tipoprocedimento` | 100% | Procedure type ("Ajuste Direto Regime Geral", "Consulta Prévia", "Concurso público", "Ao abrigo de acordo-quadro (art.º 258.º/259.º)", "Contratação excluída II", …). |
| `tipoContrato` | 100% | List, e.g. `["Aquisição de bens móveis"]`, `["Empreitadas de obras públicas"]`, `["Aquisição de serviços"]`. |
| `objectoContrato` / `descContrato` | 100% | Free-text subject and description — the best input for classification. |
| `adjudicante` | 100% | List of buyers: `nifEntContrato`, `descEntContrato`, `codPaisEntContrato`, `NUTsCod`, `NUTsDesc`, `adjudicatarioPME`, `tipoEntidade`, `atividadeEntidade`. |
| `adjudicatarios` | 100% | List of suppliers, same keys. 11.8% of entries have no NIF. 653 contracts have more than one supplier. |
| `dataPublicacao` | 100% | Publication on Portal BASE (ISO date). |
| `dataCelebracaoContrato` | 100% | Signing date. `Ano` = its year. |
| `dataDecisaoAdjudicacao` | 100% | Award decision date. |
| `precoContratual` | 100% | Signed price (float). 381 contracts at 0 in 2026. |
| `precoBaseProcedimento` | 98% | Base price of the procedure. |
| `precoEstimadoProc` | 26% | Estimated price. |
| `PrecoTotalEfetivo` | 8% | Price actually paid at closing — mostly empty, do not use as spending. |
| `dataFechoContrato` / `tipoFimContrato` | 8% / 7% | Closing date and type. |
| `CPV` | 100% | List: `cpvID`, `cpvdescricao`, `cpvValor`. 1.2% of contracts have more than one. |
| `prazoExecucao` | 99% | Execution period in days. |
| `localExecucao` | 100% | List of "Country, District, Municipality" strings. |
| `NUTs` | 100% | List of NUTS III codes + names. |
| `fundamentacao` | 100% | Legal basis (CCP article). |
| `fundamentAjusteDireto` | 6% | Extra justification for direct awards. |
| `regime` | 100% | Legal regime text. |
| `ProcedimentoCentralizado`, `compraConjunta`, `CritMateriais`, `ContratEcologico` | 100% | "Sim"/"Não" flags. |
| `numAcordoQuadro` / `DescrAcordoQuadro` | 17% | Framework agreement, when applicable. |
| `concorrentes` | 42% | List of "NIF-Name" strings of bidders. |
| `entidadesConvidadas` | 29% | Invited entities (may include individuals: `NIPCEntidade` = "-"). |
| `Lotes` | 100% | Lots with award criteria. |
| `nAnuncio`, `TipoAnuncio`, `idINCM`, `IDAnuncio` | 16% | Link to the notice (Diário da República) when there was one. |
| `linkPecasProc` | 52% | Link to tender documents. |
| `justifNReducEscrContrato` | 49% | Why there is no written contract. |
| `CausasAlteraPrazo` / `CausasAlteraPreco` | 1% | Causes of changes (details are in the modifications file). |
| `Observacoes` | 3% | Notes. |
| `TipoMEC`, `estadoContrato`, `ocorrencias` | 0% | Empty in 2026. |
| `Ano` | 100% | Integer signing year. |

## Modifications file (`modcontratsYYYY.json`, 4 463 rows in 2026)
`idcontrato`, `modifContratoFundamento`, `modifContratoTipoAto`, `modifContratoData` and `modifDataPublicacao` (`DD/MM/YYYY HH:MM:SS`), `modifContratoPrecoAlterado`, `modifPrazoExecucao`, `modifJustNContratEscrito`, `Ano`.

## Entities file (`entidades.json`, ≈ 216 600 rows)
`nifEntidade` (`-` for entities without a Portuguese NIF), `desigEntidade`, `numContratos`, `totAdjudicatario`, `totValorContratIni`, `totAdjudicante`, `totAdjudicanteValorContratIni`, `descPais`, `AliasPais`. Numbers are strings. Useful to find a body's NIF and its all-time totals.
