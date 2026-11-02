---
name: reunioes-municipais-pt
description: How to find, read, transcribe and structure Portuguese municipal council meetings (Câmara Municipal and Assembleia Municipal) — minutes (atas), agendas and videos — using OpenCouncil's public MCP where it exists and a transcription pipeline elsewhere, with Portuguese privacy rules (CNPD) and the OParl data model. Use for questions about what a council discussed or decided, or when building tools on council meetings. Reuniões de câmara, assembleia municipal, atas, ordem do dia, vídeos, transcrição.
license: MIT
metadata:
  version: "1.0.0"
  verified: "2026-11-02"
---

# Portuguese municipal council meetings

Portugal has 308 municipalities, each with two bodies that meet in public: the **Câmara Municipal** (executive) and the **Assembleia Municipal** (deliberative). There is no national aggregator of their minutes or videos. Each council publishes in its own way, so the work is: find the sources, turn them into structured data, and publish without exposing private citizens.

Last verified: 2026-11-02.

## Decision: use OpenCouncil, or build?

1. **Is the municipality on OpenCouncil?** Call `list_cities` on the public MCP (below). If yes, use it first: transcripts, speakers, subjects and summaries already exist.
2. **If not**, work from the council's own sources (minutes PDFs, agendas, videos) and, if the task needs it, run the transcription pipeline in this skill.
3. **Building something new?** Do not rebuild what OpenCouncil already covers. Consume its data, add what it lacks (other municipalities, official votes from the minutes, alerts, visual speaker focus), and output in the OParl model so both can interoperate.

## OpenCouncil Portugal (public MCP)

Open-source project by Schema Labs (Greek non-profit; code AGPL-3.0 at github.com/schemalabz/opencouncil).

- **MCP server:** `https://pt.opencouncil.eu/mcp` — Streamable HTTP, JSON-RPC, **no auth** for read-only tools. Pending (unreleased) cities and the `create_highlight` tools need a personal token from the site's /mcp page.
- **Add to Claude Code:** `claude mcp add --transport http opencouncil-pt https://pt.opencouncil.eu/mcp`
- **Coverage on 2026-11-02:** only **Cascais**, 2 released meetings (Câmara 20/10/2026 with 82 subjects; Assembleia 28/09/2026 with 33), 48 people, 9 parties. `officialSupport: false` — the municipality is not a partner. Re-check with `list_cities` before relying on it.
- **Tools:** `list_cities`, `get_city` (bodies and parties), `list_people`, `get_person`, `get_party`, `list_meetings`, `get_meeting`, `get_subject`, `get_subject_transcript`, `get_transcript`, `search`, `list_hot_subjects`, `list_nearby_subjects`, `fetch`, `get_more_tools`.
- **How to use it well (from the server's own instructions, verified):**
  - Rank a meeting's subjects by `discussionSeconds`; agenda order says nothing about importance, and about half the items pass without debate (41 of 82 on 20/10/2026).
  - `search` ranks by relevance of the summaries, not by date and not by what was said. For "did X mention Y", use `get_transcript` with `personId` or `query`.
  - For "when did this body last meet", use `list_meetings` with `timeFilter: "past"`.
  - `list_nearby_subjects` only scans recent meetings: an empty result means "nothing since `oldestMeetingScanned`", not "nothing ever".
  - If a meeting is not `summarized` yet, its subjects may be missing or copied from the agenda; the full transcript still exists.
  - Always cite the `url` fields; utterance URLs open the video at that second (`?t=1164`).
- **Data shape:** city → administrative bodies (Assembleia Municipal, Câmara Municipal) → meetings (with `youtubeUrl`, `agendaUrl`, `place`) → subjects (topic, location, description, per-speaker contributions, decision) → utterances (`speaker`, `role`, `startSec`, `endSec`, `text`, `url`).
- **Terms:** free use and redistribution of the information; source videos stay public domain; logo and design protected. **Transcripts and summaries are AI-generated and not official minutes** — say so whenever you quote them.
- **Privacy caveat (verified):** summaries can name **members of the public** who spoke in the public-intervention period. Do not repeat those names (see Privacy).

## Official sources, municipality by municipality

There is no standard. For each council, find these five things (usually on the municipality's site, under "Órgãos municipais", "Assembleia Municipal", "Reuniões", "Atas" or "Editais"):

| What | Where it usually is | Format |
|---|---|---|
| Agenda (ordem do dia / ordem de trabalhos) | site of the council or assembly, edital | PDF/HTML |
| Minutes (ata, often published first as **minuta**) | site, by mandate and year | PDF, often digitally signed |
| Video | the council's YouTube channel or Facebook | live + archive (not always) |
| Rules of procedure (regimento) | site | PDF |
| Members (eleitos, pelouros) | site; Diário da República for results | HTML/PDF |

Known cases (checked 2026-11-01):

- **Cascais** — on OpenCouncil (above).
- **Matosinhos** — Assembleia Municipal streamed on YouTube with an archive per mandate (38 sessions in 2021–25, from April 2022; channel `UCp0H56bf9eA3YOGERY5QjkA`). Câmara minutes (minutas) online since the 2005–09 mandate. No video of Câmara meetings found.
- **Porto** — Assembleia minutes as signed PDFs, including votes by party; agendas of public and private executive meetings; Câmara YouTube channel `UCJA5FonY5Wbh7jnlYtRNcGQ`; the regimento allows transmission, video archive to confirm.

To list a channel's latest videos without an API key, use its RSS feed: `https://www.youtube.com/feeds/videos.xml?channel_id={id}` (about the last 15 videos). The YouTube Data API needs a key — ask the user before using one.

## Legal framework (what you can rely on)

- Meetings of both bodies are **public** (Lei 75/2013, Regime Jurídico das Autarquias Locais, art. 49), with a period for public intervention set in each regimento.
- Deliberations take effect through publication (Lei 75/2013, art. 56; Código do Procedimento Administrativo, art. 159). A minute is drawn up for every meeting; a **minuta** can be approved at the end of the meeting so decisions take effect before the full ata.
- **Video is not mandatory.** The temporary pandemic regime that required streaming ended on 30/06/2022; each council now decides by its own regulation.
- **CNPD guidelines (5 May 2023):** minutes with citizens' personal data may be published online only where the law requires publication, and then with the data reduced to the minimum; otherwise publish only anonymised. Streaming and recording are personal-data processing; the CNPD sees consent of those filmed as the only legal basis and treats local meetings differently from Parliament because citizens take an active part.
- **Contested point:** the national association of municipal assemblies (ANAM, opinion of 9 Dec 2022) argues streaming is lawful as a public-interest task (GDPR art. 6(1)(e)) and that elected members cannot refuse capture while acting in office. Councils follow different regulations. This skill is not legal advice; for a product, get it checked.

## Privacy rules for any output

1. **Elected members and officials acting in office** (mayor, vereadores, deputados municipais, presidentes de junta, staff answering for the council): name them and quote them.
2. **Members of the public** who speak in the intervention period: **do not name them**, even if the source does. Write "um munícipe" / "a resident", keep the substance of what they asked, and never add details that identify them (address, workplace, family).
3. Never publish special-category data (health, beliefs, union membership, sexual life) or offence data about any private person, and never personal tax numbers.
4. Prefer linking to the official source or the timestamped video over re-hosting video of private people.
5. If a council has asked for an item or a person to be removed, respect it in your copy too.

## Pipeline for councils without OpenCouncil

Run it on a machine with network and disk (council videos are hours long); cloud sandboxes usually block YouTube and council sites.

1. **Collect** — agenda, minuta/ata PDFs and video URLs per meeting. Keep the raw files and a manifest (`meeting_id, body, date, agenda_url, minutes_url, video_url, retrieved_at`).
2. **Audio** — extract mono 16 kHz audio (`ffmpeg -i in.mp4 -ac 1 -ar 16000 out.wav`). Downloading from YouTube (e.g. `yt-dlp`) is subject to YouTube's terms; prefer files the council publishes, or ask the council.
3. **Transcribe** — Whisper (`faster-whisper` or `whisper.cpp`, model large-v3 for Portuguese), with word timestamps. Set `language="pt"` to stop drift into Spanish or Galician.
4. **Diarize** — `pyannote/speaker-diarization-3.1` (the model is gated: needs a Hugging Face account and token — ask the user, never hard-code it). Voice prints of identified people need their consent; without them, name speakers from cues instead.
5. **Name the speakers** — from cues in the text ("tem a palavra o senhor vereador…", "Senhor Presidente…"), the order of the agenda, and the list of elected members; mark the rest "unidentified". Members of the public stay anonymous (Privacy rule 2).
6. **Segment by agenda item** — align the transcript with the ordem do dia: the chair announces each item ("passamos ao ponto 5…"). Record `discussionSeconds` per item and keep "antes da ordem do dia" separate.
7. **Summarise** — per item: what was proposed, who argued what, and the decision. Every claim in a summary should link to an utterance.
8. **Reconcile with the minutes** — **votes and decisions come from the ata/minuta**, not from the transcript (votes are often by show of hands and not spoken). Flag disagreements between transcript and minutes rather than resolving them silently.
9. **Publish** — in the OParl model (below), with sources, the "AI transcript, not official minutes" notice, and timestamped links.

## Data model (OParl, with one extension)

Use the OParl 1.1 names (`https://schema.oparl.org/1.1/`) so the data interoperates with German council APIs and tools like OpenCouncil:

| Portuguese | OpenCouncil | OParl |
|---|---|---|
| Município | city | `Body` |
| Câmara Municipal / Assembleia Municipal | administrative body | `Organization` (and `LegislativeTerm` for the mandate) |
| Grupo municipal / partido | party | `Organization` (type party) |
| Eleito, vereador, presidente de junta | person (roles) | `Person` + `Membership` (role, start/end) |
| Reunião / sessão | meeting | `Meeting` (`start`, `end`, `location`, `invitation` = agenda file) |
| Ponto da ordem do dia | subject | `AgendaItem` (`number`, `name`, `result`, `resolutionText`) |
| Proposta, deliberação | — | `Paper` + `Consultation` |
| Ata, minuta, edital | agendaUrl | `File` (`accessUrl`, `mimeType`, `sha1Checksum`) |
| Intervenção (fala) | utterance | **extension** — OParl has no transcript object: add `Utterance {meeting, agendaItem, speaker, startSec, endSec, text, url}` |

## Checks before answering

- Which source: official minutes, OpenCouncil AI transcript, or your own transcript? Say it.
- Is the meeting final (ata approved) or only a minuta / draft / unsummarised transcript?
- Decisions and votes: confirmed in the minutes?
- Quotes: verbatim, with speaker role and a timestamped link.
- Private citizens: anonymised.
- For any numbers (budgets, contracts discussed), run the `verificar-dados-publicos` checks and get the figures from `apis-publicas-pt` sources rather than from what was said in the meeting.
