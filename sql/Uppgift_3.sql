-- Uppgift 3 – Datadrivna beslut

-- Baseline: number of applications per education area.
-- SET PAGESIZE 200 stops SQLcl from repeating the column headers mid-result.

SET PAGESIZE 200
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL DESC;

-- Question 1: Approval rate per education area
-- Motivation: applying costs The Skool a lot of money, so they need to know which areas are worth applying for.
-- Data/IT is applied for a lot, and they think parts of it are already full.

SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAG_PROCENT
FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_ANSÖKNINGAR DESC;

-- Per area: number of applications, approved and rejected, plus approval and rejection percentage.
-- Teknik och tillverkning doesn't sum to 100% because of 1 Återkallad (withdrawn) application.

-- CONCLUSION
-- Data/IT has the lowest approval rate of all areas: 31 of 220 (14.09%), vs the 39.02% overall baseline.
-- Large areas like Hälso- och sjukvård (53.54% on 127) and Teknik och tillverkning (52.94% on 221) get about half approved.
-- Data/IT is crowded and hard to get approved in, which is why Q3–Q5 dig into it.

---

-- Question 2: Differences between Distans and Bunden: is the approval rate higher for one of them?
-- Motivation: applying costs The Skool a lot of money, and the study format is chosen per application.
-- If one format is approved less often, choosing it raises the risk of a costly rejection.
SELECT STUDIEFORM, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAG_PROCENT
FROM MYH_TABELL_2025
GROUP BY STUDIEFORM
ORDER BY ANTAL_ANSÖKNINGAR DESC;
-- Same code block as Question 1, but grouped by STUDIEFORM instead of UTBILDNINGSOMRÅDE.
-- Result: Bunden 42.54% vs Distans 35.02%, against an overall baseline of 39.02%.
-- Bunden is above the baseline, Distans is about 4 percentage points below it.
-- Recommendation: lean towards Bunden to beat the baseline. Don't drop Distans entirely.

-- Question 2 follow-up: same query, filtered to Data/IT only (The Skool's main area).
SELECT STUDIEFORM, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAG_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY STUDIEFORM
ORDER BY ANTAL_ANSÖKNINGAR DESC;

-- Result: Bunden 16.27% (27 of 166) vs Distans 7.41% (4 of 54), against the 14.09% Data/IT baseline.
-- The gap is about twice as large within Data/IT, so the Bunden recommendation matters even more here.

---

-- Question 3: Which niches within Data/IT have the highest approval rate?
-- Motivation: the expert thinks parts of Data/IT are already full. Data/IT in general has a low
-- approval rate (14%), but there are probably some niches where an application is worth the cost,
-- and some where it's wasted.

-- Baseline: Data/IT overall (14.09% approved, 85.91% rejected)
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY BEVILJAD_PROCENT DESC;

-- Approval rate per niche (SUN5_INRIKTNING) within Data/IT
SELECT UTBILDNINGSOMRÅDE, SUN5_INRIKTNING, SUN5_INRIKTNING_NAMN, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE, SUN5_INRIKTNING, SUN5_INRIKTNING_NAMN
ORDER BY BEVILJAD_PROCENT DESC;

-- Note: some niches have a high approval rate on very few applications.
-- Don't take those literally, since the sample size is too small.

-- HIGH APPROVAL RATE, FEW APPLICATIONS (too small to trust)
-- 481ae databasutvecklare:       2 applications, 2 approved, 100%
-- 481ab programmerare, spel:     6 applications, 4 approved, 66.67%
-- 481xd systemadministratörer:   5 applications, 2 approved, 40%

-- ABOVE BASELINE (14.09%)
-- 481ag mjukvarutestare:         9 applications, 3 approved, 33.33%
-- 489zd IT-infrastrukturtekniker: 16 applications, 4 approved, 25%
-- 489zf interaktionsdesign:      9 applications, 2 approved, 22.22%
-- 481xf IT-säkerhet:             33 applications, 7 approved, 21.21%

-- BELOW BASELINE
-- 481ad inbyggda system och IoT: 10 applications, 1 approved, 10%
-- 481xe dataanalys och datavetenskap: 34 applications, 3 approved, 8.82%
-- 481ac systemhantering och programmering: 41 applications, 3 approved, 7.32%

-- 0% APPROVED
-- 481af webbutvecklare:          32 applications, 0 approved
-- 481xu projektledare IT:        12 applications, 0 approved
-- 481ay övriga systemutveckling och programmering: 10 applications, 0 approved
-- 481xy övriga datavetenskap och systemvetenskap: 1 application, 0 approved (too small to count)

-- CONCLUSION
-- Apply for: 481xf IT-säkerhet is the most reliable, 21.21% on 33 applications, above the 14.09% baseline.
-- Avoid: 481af webbutvecklare is popular (32 applications) but got 0 approved, so applying there is likely wasted money.
-- Same for 481xu projektledare IT (0 of 12).

---

-- Question 4: Which providers apply most within Data/IT, and what is their approval rate?
-- Motivation: The Skool wants to know who the competition is. Seeing who applies the most,
-- and who actually gets approved, shows which providers are strong in Data/IT and how a new academy compares.

---

-- Baseline: Data/IT overall
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_DATA_IT DESC;

-- Data/IT baseline: 220 applications, 31 approved (14.09%).

---

-- Top 10 providers by number of Data/IT applications
SELECT UTBILDNINGSANORDNARE_ADMINISTR, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR
ORDER BY ANTAL_DATA_IT DESC
FETCH FIRST 10 ROWS ONLY;

-- Jensen Education has the most applications of any single unit (15) but 0 approved (0%), far below the baseline.
-- Nackademin has the highest approval rate among the top appliers: 7 of 12 (58.33%), about 4x the baseline.
-- Note: the column is per administrative unit, so one company can appear several times:
--   EC Utbildning (Stockholm 13 + Göteborg 6 + Malmö 5) = 24 applications, 4 approved
--   IT-Högskolan (Sverige 13 + Stockholm 10)            = 23 applications, 4 approved
-- At company level, EC Utbildning and IT-Högskolan apply more than Jensen.

---

-- Top 10 providers by number of approved Data/IT applications
SELECT UTBILDNINGSANORDNARE_ADMINISTR, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR
ORDER BY ANTAL_BEVILJAD DESC, ANTAL_DATA_IT DESC
FETCH FIRST 10 ROWS ONLY;

-- Sorted by approvals first, then by number of applications.
-- Some providers have a 100% approval rate on very few applications (e.g. Göteborgs Stad, Yrgo: 2 of 2),
-- which can be misleading, so the number of applications is shown next to the approvals.

-- CONCLUSION
-- Applying more does not mean getting approved more. Jensen applies the most as a single unit but gets
-- nothing approved. Nackademin is the most successful: 7 of 12 (58.33%), about 4x the baseline.
-- The biggest competitors by volume are EC Utbildning and IT-Högskolan (counted per company).

---

-- Question 5: Do programs with AI in the name get approved more often than others?
-- Motivation: the expert asked whether a course can be made more attractive with more AI.
-- If AI programs get approved more often, The Skool could add AI to its applications. If not, it may be a risk.

SELECT CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END AS AI_GRUPP, COUNT(*) AS ANTAL_UTBILDNINGSNAMN,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
GROUP BY CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END
ORDER BY BEVILJAD_PROCENT DESC;

-- Not AI: 1136 applications, 460 approved (40.49%)
-- AI:       48 applications,   2 approved (4.17%)

-- SANITY CHECK: list every AI program, including AI spelled out in English and Swedish
SELECT UTBILDNINGSNAMN, COUNT(*) AS ANTAL_UTBILDNINGSNAMN,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_AI_BEVILJAD
FROM MYH_TABELL_2025
WHERE UTBILDNINGSNAMN LIKE '%AI%'
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIAL INTELLIGENCE%'
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIELL INTELLIGENS%'
GROUP BY UTBILDNINGSNAMN
ORDER BY ANTAL_UTBILDNINGSNAMN DESC;

-- The spelled-out versions add 0 rows, so the main query only needs LIKE '%AI%'.
-- The CASE WHEN ... ELSE 'Not AI' pattern was an LLM hint: it labels every row as AI or Not AI,
-- so both groups can be compared in one GROUP BY.

-- CAUTION: the comparison above is misleading on its own.
-- 30 of the 48 AI applications are in Data/IT, which has a low approval rate overall (14.09%).

-- Question 5 follow-up: same query, filtered to Data/IT only.
SELECT CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END AS AI_GRUPP, COUNT(*) AS ANTAL_UTBILDNINGSNAMN,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END
ORDER BY BEVILJAD_PROCENT DESC;

-- Comparing within Data/IT only: AI 1 of 30 (3.3%) vs Not AI 30 of 190 (15.8%).

-- CONCLUSION
-- AI programs are approved less often, but not 10x less: within Data/IT it's 3.3% vs 15.8%, about 5x.
-- Putting AI in the program name does not make an application more likely to be approved.


-- Uppgift 3: queries and analysis ideas are my own. All SQL in this file is written by me.
-- LLM used for hints on SQL errors, pointing out that Q1/Q2 had swapped queries, the CASE/ELSE hint in Q5,
-- flagging the Data/IT confounding in Q5 and suggesting the Data/IT follow-up queries in Q2 and Q5
-- (I wrote both queries myself), the missing 481ag niche in Q3 and company-level grouping in Q4,
-- suggesting how to structure the findings, and wording the comments in Q1–Q5.