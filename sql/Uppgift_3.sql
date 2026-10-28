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

SELECT STUDIEFORM, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAG,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.00 / COUNT(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.00 / COUNT(*), 2) AS AVSLAG_PROCENT
FROM MYH_TABELL_2025
GROUP BY STUDIEFORM
ORDER BY ANTAL_ANSÖKNINGAR DESC;

--Same codeblock as question 1, but grouped by STUDIEFORM instead of UTBILDNINGSOMRÅDE.
--Bunden has the higher approval rate: 42.54% vs 35.02% for Distans.

---

-- Question 3: Which niches within Data/IT have the highest approval rate?

SET PAGESIZE 100
SELECT UTBILDNINGSOMRÅDE, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.0 / count(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE
ORDER BY BEVILJAD_PROCENT DESC;

SELECT UTBILDNINGSOMRÅDE, SUN5_INRIKTNING, SUN5_INRIKTNING_NAMN, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS ANTAL_BEVILJAD,
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS ANTAL_AVSLAGEN,
    ROUND(COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) * 100.0 / count(*), 2) AS BEVILJAD_PROCENT,
    ROUND(COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) * 100.0 / count(*), 2) AS AVSLAGEN_PROCENT
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT'
GROUP BY UTBILDNINGSOMRÅDE, SUN5_INRIKTNING, SUN5_INRIKTNING_NAMN
ORDER BY BEVILJAD_PROCENT DESC;

-- small sample size, have high approval rating, dont take that literally since the sample size is small.
-- Data/IT sanitycheck/baseline (14.09% approval and 85.91% denial)

--HIGH APPROVAL RATE WITH LOW APPLICATION
-- 481ae 2 applications and 2 approvals, 100%
-- 481ab 6 applications and 4 approvals, 66.67%
-- 481xd 5 applications and 2 approvals, 40%

--ABOVE BASELINE - 14.09% approval
--489zd 16 applications and 4 approvals, 25% approval
--489zf 9 applications and 2 approvals, 22.22% approval
--481xf 33 applications and 7 approvals, 21.21% approval

--HIGH DENY RATE
--481ad 10 applications and 1 approvals, 10% approval
--481xe 34 applications and 3 approvals, 8.82% approval
--481ac 41 applications and 3 approvals, 7.32% approval

--100% DENY RATE
--481xu 12 applications and 0 approvals, 0% approval
--481xy 1 applications and 0 approvals, 0% approval - dont count this one, to small sample
--481af 32 applications and 0 approvals, 0% approval - dont apply more for this, waste of money.
--481ay 10 applications and 0 approvals, 0% approval

--CONCLUSION
--481xf (IT-säkerhet) has the most reliable high approval rate: 21.21% on 33 applications, above the 14.09% Data/IT baseline.
---

-- Question 4: Which providers apply most within Data/IT, and what is their approval rate?

-- SANITY CHECK / BASELINE
SET PAGESIZE 100
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