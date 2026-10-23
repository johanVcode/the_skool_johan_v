# The Skool – SQL analysis of MYH applications 2025

My first SQL analysis project: loading MYH's 2025 application results into
Oracle Database and answering questions with SQL, to help the education
provider The Skool decide which programs to apply for.

> **Kept as submitted.** This was my first SQL analysis project, and I've
> left it exactly as I handed it in, mistakes included, so you can see where
> I started. What I'd do differently today is listed at the bottom.
 
## Uppgift 0 – Uppvärmning
Code: [sql/Uppgift_0.sql](sql/Uppgift_0.sql)
- ✅ a) Repo: `the_skool_johan_v` (surname shortened for privacy)
- ✅ b) [.gitignore](.gitignore)
- ✅ c) Data from MYH: [data/resultat-ansokningsomgang-2025.xlsx](data/resultat-ansokningsomgang-2025.xlsx)
- ✅ d) Only Tabell 3 kept: [data/resultat_2025_tabell3.csv](data/resultat_2025_tabell3.csv)
- ✅ e) Load into Oracle: [sql/Uppgift_0.sql](sql/Uppgift_0.sql)
- ✅ f) One script per task: see the [sql/](sql/) folder
- ✅ Extra: data cleaning (130 values with extra spaces), also in [sql/Uppgift_0.sql](sql/Uppgift_0.sql)

## Uppgift 1 – Grundläggande EDA
Code: [sql/Uppgift_1.sql](sql/Uppgift_1.sql)
- ✅ a) Applications per education area, sorted most first [a)-c)](sql/Uppgift_1.sql#L11-L16)
- ✅ b) Approved applications per education area [a)-c)](sql/Uppgift_1.sql#L11-L16)
- ✅ c) Rejected applications per education area [a)-c)](sql/Uppgift_1.sql#L11-L16)
- ✅ d) Approved per program name within Data/IT [d)-e)](sql/Uppgift_1.sql#L20-L26)
- ✅ e) Rejected per program name within Data/IT [d)-e)](sql/Uppgift_1.sql#L20-L26)
- ✅ f) Approved per provider + program name within Data/IT [f)](sql/Uppgift_1.sql#L31-L36)
- ✅ g) Top 5 län by approved applications [g)](sql/Uppgift_1.sql#L45-L49)
- ✅ h) Share of distance vs classroom per area [h)](sql/Uppgift_1.sql#L58-L65)
- ✅ i) Number of programs containing "AI" [i)](sql/Uppgift_1.sql#L85-L86)
 
## Uppgift 2 – Intervju
- ✅ Interview with domain expert

Key insight: The Skool wants to understand the **competitive landscape**: which
areas and programs are most likely to get funded, and who the competition is.
 
## Uppgift 3 – Datadrivna beslut
- ⬜ Not started yet (planned file: `sql/Uppgift_3.sql`)

## Uppgift 4 – Datamodell (BONUS)
- ⬜ Implement the data model (split the flat table into smaller tables)
- ⬜ Answer the Uppgift 1 questions again using the new tables

## Uppgift 5 – README
- ✅ This file

## Uppgift 6 – Video + slides
- ⬜ Presentation (PDF): ...
- ⬜ Video (5–10 min): ...

## Tools
- Oracle Database 26ai Free (run in rootless Podman on Oracle Linux 10)
- SQLcl (for `LOAD` and running scripts)
- VS Code with Remote-SSH + Oracle SQL Developer extension

## How to run
1. Start Oracle Database (Podman) and connect with SQLcl or SQL Developer.
2. Change the CSV path in [sql/Uppgift_0.sql](sql/Uppgift_0.sql) to where you cloned this repo.
3. Run `Uppgift_0.sql` (load + clean, expect `COUNT(*) = 1184`), then `Uppgift_1.sql`.

Note: `DROP TABLE IF EXISTS` requires Oracle 23ai or later.
The raw CSV is never modified; the scripts rebuild the table `MYH_TABELL_2025` from it.
 
## LLM usage
LLM (Claude) used as a sounding board ("bollplank"), noted in each file where used:
- Environment setup (Podman mount, VS Code connection)
- [sql/Uppgift_0.sql](sql/Uppgift_0.sql): load script drafted with LLM, reviewed by me;
  cleaning blocks 5–18 generated from my own 4-column pattern
- [sql/Uppgift_1.sql](sql/Uppgift_1.sql): f) sorting fix (ORDER BY provider, program) suggested by LLM;
  g) ORDER BY fix (sort by count DESC); i) false-positive note (lowercase "ai" matches sustAInable etc.)
- `.gitignore`: added linux, macOS and Windows, with gitignore.io, also added scratch file name since its a playground.
  nano was suggested was added and vim removed since it can add complications down the road.

## Sources
- MYH: resultat ansökningsomgång 2025
- Course material: [oracle_sql_course](https://github.com/AIgineerAB/oracle_sql_course)
  (lectures 04 load_csv, 05 filtering, 06 crud, 07 aggregation, 08 strings)
- Alexander Obregon, Substack: TRIM and the `UPDATE ... WHERE col <> TRIM(col)` pattern
- Interview Query: [SQL COUNT CASE WHEN](https://www.interviewquery.com/p/sql-count-case-when).
  Learned to turn 'Beviljad' into a 1 so it can be counted, used for several counts side by side
  (Uppgift 1 a–e) and for approval % (`Beviljad * 100.0 / COUNT(*)`). See [Notes.md](Notes.md).
