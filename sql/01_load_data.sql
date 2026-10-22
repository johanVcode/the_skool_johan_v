-- Dialect: Oracle Database
-- Purpose: load MYH application results 2025 (Tabell 3) into one flat table
-- LLM note: load script drafted with LLM assistance (Claude), reviewed by me.

DROP TABLE IF EXISTS myh_tabell_2025;

SET LOADFORMAT CSV -- format im loading the table in, csv so it can take å/ä/ö
SET LOAD SCAN_ROWS 2000 -- added 2000 rows because there was a problem with 100_000 for some reason so kept it simple
LOAD TABLE myh_tabell_2025 '/home/bunk.moreland/projects/the_skool_johan_v/data/resultat_2025_tabell3.csv' NEW

-- simple sanity check of the table numbered.
SELECT COUNT(*) FROM myh_tabell_2025;