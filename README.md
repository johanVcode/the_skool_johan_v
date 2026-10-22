# The Skool – SQL analysis of MYH applications 2025

Analysis of MYH's 2025 application round (Tabell 3, programs starting 2026) to help
the education provider **The Skool** make data-driven decisions about which programs
to apply for.

## Uppgift 0 – Uppvärmning
Code: [sql/Uppgift_0.sql](sql/Uppgift_0.sql)
- [x] a) Repo: `the_skool_johan_v` (surname shortened for privacy)
- [x] b) [.gitignore](.gitignore)
- [x] c) Data from MYH: [screenshot](screenshots/myh_source_2025.png)
- [x] d) Only Tabell 3 kept: [data/resultat_2025_tabell3.csv](data/resultat_2025_tabell3.csv)
- [x] e) Load into Oracle: [sql/Uppgift_0.sql](sql/Uppgift_0.sql)
- [x] f) One script per task: see the [sql/](sql/) folder
- [x] Extra: data cleaning (130 values with extra spaces), also in [sql/Uppgift_0.sql](sql/Uppgift_0.sql)

## Uppgift 1 – Grundläggande EDA
Code: [sql/Uppgift_1.sql](sql/Uppgift_1.sql)
- [x] a) Applications per education area, sorted most first
- [x] b) Approved applications per education area
- [x] c) Rejected applications per education area
- [x] d) Approved per program name within Data/IT
- [x] e) Rejected per program name within Data/IT
- [x] f) Approved per provider + program name within Data/IT
- [ ] g) Top 5 län by approved applications
- [ ] h) Share of distance vs classroom per area
- [ ] i) Number of programs containing "AI"

**Finding a–c:** Ekonomi (239), Teknik (221) and Data/IT (220) get the most
applications, but Data/IT has by far the fewest approvals (31 of 220).
The top 5 areas hold 987 of 1184 applications (~83%).

## Uppgift 2 – Intervju
- [x] Interview with domain expert
Key insight: The Skool wants to understand the **competitive landscape**: which
areas and programs are most likely to get funded, and who the competition is.

## Uppgift 3 – Datadrivna beslut
Code: [sql/Uppgift_3.sql](sql/Uppgift_3.sql)

## Uppgift 4 – Datamodell (BONUS)
- [ ] Implement the data model (split the flat table into smaller tables)
- [ ] Answer the Uppgift 1 questions again using the new tables

## Uppgift 5 – README
- [x] This file

## Uppgift 6 – Video + slides
- [ ] Presentation (PDF): ...
- [ ] Video (5–10 min): ...

## Tools
- Oracle Database 26ai Free (run in rootless Podman on Oracle Linux 10)
- SQLcl (for `LOAD` and running scripts)
- VS Code with Remote-SSH + Oracle SQL Developer extension

## LLM usage
LLM (Claude) used as a sounding board ("bollplank"), noted in each file where used:
- Environment setup (Podman mount, VS Code connection)
- [sql/Uppgift_0.sql](sql/Uppgift_0.sql): load script drafted with LLM, reviewed by me;
  cleaning blocks 5–18 generated from my own 4-column pattern
- `.gitignore`: created together with LLM, decided Vim will not be needed since it can clash down the line by ignoring stuff that I might want to show.
- Explanations of concepts (DROP TABLE IF EXISTS, UTF-8 vs CSV, operator order)

The approval-rate query (Uppgift 3, Fråga 1) was written by me using Google.

## Sources
- MYH: resultat ansökningsomgång 2025
- Course material: [oracle_sql_course](https://github.com/AIgineerAB/oracle_sql_course)
  (lectures 04 load_csv, 05 filtering, 06 crud, 07 aggregation, 08 strings)
- Alexander Obregon, Substack: TRIM and the `UPDATE ... WHERE col <> TRIM(col)` pattern