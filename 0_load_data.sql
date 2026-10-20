-- Dialect: Oracle Database (run via SQLcl: orac 0_load_data.sql)
-- Purpose: load MYH application results 2025 (Tabell 3) into a table

SET LOADFORMAT XLSX
DROP TABLE myh_tabell_2025;
SET LOAD SCAN_ROWS 2000
LOAD TABLE myh_tabell_2025 'data/resultat_2025_tabell3.xlsx' NEW

COMMIT;

-- sanity check: should be 1184 rows
SELECT COUNT(*) FROM myh_tabell_2025;
EXIT
