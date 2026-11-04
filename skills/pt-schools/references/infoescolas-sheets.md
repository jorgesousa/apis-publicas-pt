# InfoEscolas sheets (edition of February 2025)

Checked on the ten `DadosPorEscola` / `DadosPorUO` files of the February 2025 edition (`docs/2024/`). Each file also has a `DescriçãoGeral` sheet with the methodology — read it before using a new indicator.

Sheet names differ slightly between files: `ConclusãoTempoEsperado` in school files, `ConclusaoTempoEsperado` (no accent) in some UO files. Look sheets up by a normalised name.

## Sheets per level

| Sheet | 1.º | 2.º | 3.º | Sec. CH | Sec. Prof. | Content |
|---|:-:|:-:|:-:|:-:|:-:|---|
| `Populacao` | ✓ | ✓ | ✓ | ✓ | ✓ | Pupils by school year (4 years) and curricular year; vocational: total per year only |
| `Idades` | ✓ | ✓ | ✓ | ✓ | ✓ | Age distribution, 2022/23 |
| `Sexo` | ✓ | ✓ | ✓ | ✓ | ✓ | Share by sex in the school and nationally, 2022/23 |
| `Retencao` | ✓ | ✓ | ✓ | ✓ | — | Retention or drop-out rate by school year and curricular year |
| `ConclusãoTempoEsperado` | ✓ | ✓ | ✓ | ✓ | ✓ | Completion on time: sample size, observed %, expected % (similar profile), 4 years (vocational: 3 years, with the outcome split into concluded / still in vocational / in another secondary track / left secondary) |
| `PercursosDiretosSucesso` | — | — | ✓ | — | — | 9.º ano: no retention in 7.º–8.º and positive in both national tests; observed, expected, difference in points, category; 2021/22 and 2022/23 |
| `Cursos` | — | — | — | ✓ | ✓ | Pupils by course (CH: Ciências e Tecnologias, Socioeconómicas, Línguas e Humanidades, Artes Visuais; vocational: one row per course with code and completion on time) |
| `CTE_Curso` | — | — | — | ✓ | — | Completion on time by course, 3 years |
| `CI_Curso por escola` / `CI_Curso por UO` | — | — | — | ✓ | — | Internal grades by course (0–20): sample, number of grades, observed mean, expected mean; 3 years |
| `CTEcomASEeEquidade` (UO files only) | ✓ | ✓ | ✓ | ✓ | ✓ | Pupils with social support (ASE): completion on time vs expected, and "Equidade" = difference in points; 3 years |

## Layout

- Rows 1–5: titles. Row 6 (sometimes rows 5–7): header, with year labels on one row and the measure on the next (merged cells).
- First data row: `TOTALPT` = national total (expected value is `N/A` there).
- School files: `Código Escola DGEEC`, `Nome da Escola`, `Município` (also spelt `Munícipio`), then the year blocks, then `Observações` (e.g. "Escola com menos de 15 alunos na amostra…").
- UO files: `Código do Agrupamento`, `Código da Escola` (only for non-grouped schools), `Natureza da Unidade` (Pública/Privada), `Natureza Pública da Unidade` (Agrupamento / Escola não agrupada), `Nome da Unidade`, `Distrito`.
- Values: shares as fractions (0.7686 = 76.9%); `*` suppressed; `-` not applicable.
