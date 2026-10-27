--Uppgift 3
--how many applications each education area has.

-- Baseline/Sanity check
--First we need to know how many areas of education we have descending
--We need UTBILDNINGSOMRÅDE column and count each and every one for its area
--we also set pagesize to 100 as to not get page cut-off since its SQLcl repeating the column headers each time a page fills up.
SET PAGESIZE 100
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL FROM MYH_TABELL_2025 
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL DESC;

---

-- Uppgift 3
--per area, the number of applications, approved and rejected, plus the approval and rejection percentage.

--Second i took the same codeblock as in distans vs bunden and added it here but with Beviljad och Avslagen instead
--will take the whole UTBILDNINGSOMRÅDE and count for 'Beviljad' and 'Avslagen' and as a procent.
SET PAGESIZE 100
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.0 / count(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_ANSÖKNINGAR DESC;