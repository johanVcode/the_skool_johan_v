-- experimented after a while from finding the solution in my scratch file
-- and thought what if we can use 1 command block instead of many? checked to add more counts to the questions so in short 
-- we can pack it more densely and use the same SELECT instead of many blocks 
-- COUNT can be used as many times since every condition is still separate, and doesnt mix with other counts

-- Uppgift 1
-- a), b), c). Sorted by most applications.
SET PAGESIZE 100
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD, -- b)
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG -- c)
FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_ANSÖKNINGAR DESC; -- a)

-- Uppgift 1
-- d), e). Sorted by most applications.
SELECT UTBILDNINGSNAMN, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS DATA_IT_BEVILJAD, -- d)
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS DATA_IT_AVSLAG -- e)
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT' -- keep only "Data/IT" so it's the only thing being counted.
GROUP BY UTBILDNINGSNAMN
ORDER BY ANTAL_ANSÖKNINGAR DESC;

-- Uppgift 1
-- f)
SELECT UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN, COUNT(*) AS ANTAL_BEVILJAD
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT' 
    AND BESLUT = 'Beviljad'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN
ORDER BY UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN; 
-- the "duplicates" were not duplicates, each row is a different program from the same provider.
-- ORDER BY provider, program (A→Z, ASC is default): groups each provider's programs together.
-- Sorting by ANTAL_BEVILJAD was useless since every count is 1. Sort order fix suggested by LLM.

-- TOP 5 LÄN BY APPROVED APPLICATION
-- Uppgift 1
-- g)
/* Old Version
SELECT BESLUT, LÄN, COUNT(*) AS ANTAL_BEVILJAD FROM MYH_TABELL_2025
WHERE BESLUT = 'Beviljad'
GROUP BY BESLUT, LÄN
ORDER BY ANTAL_BEVILJAD DESC
FETCH FIRST 5 ROWS ONLY; 

-- knew there was a command to take only the TOP by a value, and could write a simple code block 
-- that took BESLUT with the text 'Beviljad' and counted those up, with a bouncer called WHERE.
-- ORDER BY fixed with LLM help: top = sort by the count DESC, not by LÄN
*/

-- SANITY CHECK - each table 

SELECT BESLUT, LÄN, COUNT(DISTINCT DIARIENUMMER) AS ANTAL_BEVILJAD FROM MYH_TABELL_2025
WHERE ANTAL_KOMMUNER = 1
    AND BESLUT = 'Beviljad'
GROUP BY BESLUT, LÄN
ORDER BY ANTAL_BEVILJAD DESC
FETCH FIRST 5 ROWS ONLY; 

-- cross check
-- Stockholm 89 Beviljad
-- Västra Götaland 89 Beviljad
-- Skåne 45 Beviljad

SELECT BESLUT, LÄN, COUNT(DISTINCT DIARIENUMMER) AS ANTAL_BEVILJAD FROM MYH_TABELL4_2025
WHERE BESLUT = 'Beviljad'
GROUP BY BESLUT, LÄN
ORDER BY ANTAL_BEVILJAD DESC
FETCH FIRST 5 ROWS ONLY; 

-- cross check
-- Stockholm 46 Beviljad
-- Västra Götaland 33 Beviljad
-- Skåne 32 Beviljad

-- g) --- ANSWER ---
SELECT BESLUT, LÄN, COUNT(DISTINCT DIARIENUMMER) AS ANTAL_BEVILJAD 
FROM (
    SELECT BESLUT, LÄN, DIARIENUMMER FROM MYH_TABELL4_2025
    UNION ALL
    SELECT BESLUT, LÄN, DIARIENUMMER FROM MYH_TABELL_2025 WHERE ANTAL_KOMMUNER = 1
)
WHERE BESLUT = 'Beviljad'
GROUP BY BESLUT, LÄN
ORDER BY ANTAL_BEVILJAD DESC
FETCH FIRST 5 ROWS ONLY; 

-- cross check
-- Stockholm 89 + 46 = 135
-- Västra Götaland 89 + 33 = 122
-- Skåne 45 + 32 = 77 

-- Task 0d says keep only Tabell 3, but Tabell 3 lumps multi-kommun applications under
-- LÄN = 'Flera kommuner'. Tabell 4 has one row per kommun for those, so it's needed to place them in a län.
-- Tabell 4 can list the same application twice in one län (e.g. MYH 2025/3229: Nacka + Södertälje),
-- so COUNT(*) double-counts. COUNT(DISTINCT DIARIENUMMER) counts each application once per län.
-- LLM flagged the duplicates and corrected my DISTINCT placement (count in outer query, not inner).

---

-- Uppgift 1
-- h). Distans vs Bunden
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN STUDIEFORM = 'Bunden' THEN 1 END) AS ANTAL_BUNDEN,
    COUNT(CASE WHEN STUDIEFORM = 'Distans' THEN 1 END) AS ANTAL_DISTANS,
    ROUND(COUNT(CASE WHEN STUDIEFORM = 'Bunden' THEN 1 END) * 100.0 / COUNT(*), 2) AS BUNDEN_PROCENT,
    ROUND(COUNT(CASE WHEN STUDIEFORM = 'Distans' THEN 1 END) * 100.0 / COUNT(*), 2) AS DISTANS_PROCENT
FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_ANSÖKNINGAR DESC;

-- SANITY CHECK: expected Distans to dominate, but totals show Bunden 630 vs Distans 554.

SELECT STUDIEFORM, COUNT(*) AS TOTAL_DISTANS FROM MYH_TABELL_2025
WHERE STUDIEFORM = 'Distans'
GROUP BY STUDIEFORM;

SELECT STUDIEFORM, COUNT(*) AS TOTAL_BUNDEN FROM MYH_TABELL_2025
WHERE STUDIEFORM = 'Bunden'
GROUP BY STUDIEFORM;

---

-- Uppgift 1
-- i). AI counted
SELECT COUNT(*) AS ANTAL_AI
FROM MYH_TABELL_2025
WHERE UTBILDNINGSNAMN LIKE '%AI%' -- 48 on its own. No UPPER() on purpose: avoids matching lowercase "ai" inside words
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIAL INTELLIGENCE%' -- adds 0, total still 48
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIELL INTELLIGENS%'; -- adds 0, total still 48
-- After the Uppgift_3 sanity check/baseline, I added the 2 ORs because AI can be
-- written out in full, in English or Swedish.

/* Old Version, before adding ARTIFICIELL INTELLIGENS:
SELECT COUNT(*) AS ANTAL_AI
FROM MYH_TABELL_2025
WHERE UTBILDNINGSNAMN LIKE '%AI%' OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIAL INTELLIGENCE%'
Don't need specifics, just count all lines
add a bouncer WHERE UTBILDNINGSNAMN with a specific filter LIKE '%WORD%'
*/