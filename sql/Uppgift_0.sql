-- Oracle Database
-- Purpose: load MYH application results 2025 (Tabell 3) into one flat table
-- LLM note: load script drafted with LLM assistance (Claude), reviewed by me. 

-- Uppgift 0
-- e)

-- Drop the old table first so the script can be rerun from scratch
-- IF EXISTS: no error on the very first run, when the table doesn't exist
DROP TABLE IF EXISTS MYH_TABELL_2025;

-- got corrected, apparently UTF-8 encoding keeps å/ä/ö but data in CSV will keep the data in plain text. 
-- (its a gap in my knowledge, and thought CSV was the thing that allowed å/ä/ö)
SET LOADFORMAT CSV

-- added 2000 rows because there was a problem with 100_000 for some reason so kept it simple
SET LOAD SCAN_ROWS 2000

-- loading the table to the oracle database
LOAD TABLE myh_tabell_2025 '/home/bunk.moreland/projects/the_skool_johan_v/data/resultat_2025_tabell3.csv' NEW

-- simple sanity check of the table numbered, minus the header. 1184 
SELECT COUNT(*) FROM myh_tabell_2025;