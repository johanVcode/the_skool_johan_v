--Uppgift 3

-- Baseline/Sanity check
-- How many applications each education area has.
--First we need to know how many areas of education we have descending
--We need UTBILDNINGSOMRÅDE column and count each and every one for its area
--we also set pagesize to 100 as to not get page cut-off since its SQLcl repeating the column headers each time a page fills up.

SET PAGESIZE 100
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL DESC;

---

-- Question 1: Approval rate per education area
-- Per area, the number of applications, approved and rejected, plus the approval and rejection percentage.

SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAG_PROCENT
FROM MYH_TABELL_2025
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_ANSÖKNINGAR DESC;

--will take the whole UTBILDNINGSOMRÅDE and count for 'Beviljad' and 'Avslag' and as a procent.
--återkallad application, "teknik och tillverkning" doesnt sum to 100% because of it
--motivering - It costs a lot of money to apply, so they need to know what to apply for.
--Data/IT is applied for a lot, and the expert thinks parts of it are already full.

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

---

-- Question 3: Which niches within Data/IT have the highest approval rate?
-- Motivation: the expert thinks parts of Data/IT are already full. Data/IT in general has a low
-- approval rate (14%), but there are probably some niches where an application is worth the cost,
-- and some where it's wasted.

-- Baseline: Data/IT overall (14.09% approved, 85.91% rejected)
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.0 / count(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY BEVILJAD_PROCENT DESC;

-- Approval rate per niche (SUN5_INRIKTNING) within Data/IT
SELECT UTBILDNINGSOMRÅDE, SUN5_INRIKTNING, SUN5_INRIKTNING_NAMN, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.0 / count(*), 2) AS AVSLAGEN_PROCENT
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

-- SANITY CHECK / BASELINE
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / count(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY ANTAL_DATA_IT DESC;

-- Data/IT baseline: 220 applications, 31 approved (14.09%).

---

-- Top 10 providers by number of Data/IT applications
SELECT UTBILDNINGSANORDNARE_ADMINISTR, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / count(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR
ORDER BY ANTAL_DATA_IT DESC
FETCH FIRST 10 ROWS ONLY;

-- Nackademin has the highest approval rate among the top appliers: 7 of 12 (58.33%), well above the baseline.
-- Jensen Education has the most applications (15, three more than Nackademin) but 0 approved (0%), far below the baseline.

---

-- Top 10 providers by number of approved Data/IT applications
SELECT UTBILDNINGSANORDNARE_ADMINISTR, COUNT(*) AS ANTAL_DATA_IT,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR
ORDER BY ANTAL_BEVILJAD DESC, ANTAL_DATA_IT DESC
FETCH FIRST 10 ROWS ONLY;

-- Sorted by approvals first, then by number of applications.
-- Some providers have a 100% approval rate on very few applications, which can be misleading,
-- so the number of applications is shown next to the approvals.

-- CONCLUSION:
-- Jensen applies the most but gets nothing approved. Nackademin is the most successful:
-- 7 of 12 (58.33%), about 4x the baseline. Applying more does not mean getting approved more.

---

-- Question 5: Do programs with AI in the name get approved more often than others?

SELECT CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END AS AI_GRUPP, COUNT(*) AS ANTAL_UTBILDNINGSNAMN,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_BEVILJAD,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT
FROM MYH_TABELL_2025
GROUP BY CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END
ORDER BY BEVILJAD_PROCENT DESC;

-- Not AI: 1136 applications, 460 approved (40.49%)
-- AI: 48 applications, 2 approved (4.17%)

--SANITY CHECK/BASELINE
SELECT UTBILDNINGSNAMN, COUNT(*) AS ANTAL_UTBILDNINGSNAMN,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) ANTAL_AI_BEVILJAD
FROM MYH_TABELL_2025
WHERE UTBILDNINGSNAMN LIKE '%AI%'
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIAL INTELLIGENCE%'
    OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIELL INTELLIGENS%'
GROUP BY UTBILDNINGSNAMN
ORDER BY ANTAL_UTBILDNINGSNAMN DESC;

-- I knew I could use '%AI%' to find AI in UTBILDNINGSNAMN, but didn't know how to use it in my queries.
-- Got the idea from the Uppgift_1 i) code block, but didn't understand how to create a "Not AI" group.
-- I thought I also needed a COUNT(CASE ...) for AI.
-- Got a hint to use: CASE WHEN UTBILDNINGSNAMN LIKE '%AI%' THEN 'AI' ELSE 'Not AI' END
-- It works like LIKE '%AI%' OR UPPER(UTBILDNINGSNAMN) LIKE '%ARTIFICIAL INTELLIGENCE%', but with an ELSE that labels everything else.
-- Writing this also gave me the idea to check for "ARTIFICIAL INTELLIGENCE" and "ARTIFICIELL INTELLIGENS".
-- Added 2 extra conditions for AI spelled out in 2 different ways (English and Swedish).
-- Still found only 2 approved AI applications, so the result did not change.

--CONCLUSION
-- AI programs are approved about 10x less often than others: 4.17% vs 40.49%.


-- Uppgift 3: queries and analysis ideas are my own. LLM used for hints on SQL errors, 
-- pointing out that Q1/Q2 had swapped queries, suggesting 
-- how to structure the findings, and wording the conclusions and Q4 comments.