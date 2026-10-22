-- Dialect: Oracle Database
-- Purpose: load MYH application results 2025 (Tabell 3) into one flat table
-- LLM note: load script drafted with LLM assistance (Claude), reviewed by me.

DROP TABLE IF EXISTS myh_tabell_2025;

SET LOADFORMAT CSV
SET LOAD SCAN_ROWS 2000
LOAD TABLE myh_tabell_2025 '/home/bunk.moreland/projects/the_skool_johan_v/data/resultat_2025_tabell3.csv' NEW

-- sanity check: compare with `wc -l` on the CSV, minus 1 for the header
SELECT COUNT(*) FROM myh_tabell_2025;