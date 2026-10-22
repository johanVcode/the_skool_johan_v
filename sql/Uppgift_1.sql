-- group by and count whats most populer, maybe we can add compares with other headers??

-- experimented after a while from finding the solution in my scratch file
-- and thought what if we can use 1 command block instead of many? checked to add more counts to the questions so in short 
-- we can pack it more densely and use the same SELECT instead of many blocks 
-- COUNT can be used as many times since every condition is still seperate, and doesnt mix with other counts

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
-- d), e). Sorted by most
SELECT UTBILDNINGSNAMN, COUNT(*) AS ANTAL_ANSÖKNINGAR,
    COUNT(CASE WHEN BESLUT = 'Beviljad' THEN 1 END) AS DATA_IT_BEVILJAD, -- d)
    COUNT(CASE WHEN BESLUT = 'Avslag' THEN 1 END) AS DATA_IT_AVSLAG -- e)
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT' -- keep only "Data/IT" so its the only thing being counted.
GROUP BY UTBILDNINGSNAMN
ORDER BY ANTAL_ANSÖKNINGAR DESC;

-- Uppgift 1
-- f). was about to use the same method as d)/e) but had some knowledge gap and was prompted to fix it with a much more elegant way
-- still not satisfied because the data looks ugly, sure Nackademin Aktiebolag comes up a lot for example, and it only should show once
SELECT UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN, COUNT(*) AS ANTAL_BEVILJAD
FROM MYH_TABELL_2025
WHERE UTBILDNINGSOMRÅDE = 'Data/IT' 
    AND BESLUT = 'Beviljad'
GROUP BY UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN
ORDER BY UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN; 
-- ORDER BY ANTAL_BEVILJAD DESC; was my last attempt, it wasnt wrong per say, all counts were 1 so sorting by it did nothing
-- the "duplicates" were not duplicates, each row is a different program from the same provider.
-- claude LLM suggested that i put UTBILDNINGSANORDNARE_ADMINISTR, UTBILDNINGSNAMN; because its A -> Z because its not a numerical value
-- and DESC; is not needed. THIS IS A HUGE KNOWLEDGE GAP AND I WILL READ MORE THOROUGLY ABOUT IT

-- TOP 5 LÄN BY APPROVED APPLICATION
-- Uppgift 1
-- g)
SELECT BESLUT, LÄN, COUNT(*) AS ANTAL_BEVILJAD FROM MYH_TABELL_2025
WHERE BESLUT = 'Beviljad'
GROUP BY BESLUT, LÄN
ORDER BY ANTAL_BEVILJAD DESC
FETCH FIRST 5 ROWS ONLY; 
-- knew there was a command to take only the TOP by a value, and could write a simple code block 
-- that took BESLUT with the text 'Beviljad' and counted those up, with a bouncer called WHERE.
-- ORDER BY fixed with LLM help: top = sort by the count DESC, not by LÄN

-- Uppgift 1
-- h). Distans vs Bunden

SELECT STUDIEFORM, COUNT(*) AS ANTAL_ANSÖKNINGAR FROM MYH_TABELL_2025
    COUNT(CASE WHEN STUDIEFORM = 'Bunden' THEN 1 END) AS ANTAL_BUNDEN
    COUNT(CASE WHEN STUDIEFORM = 'Distans' THEN 1 END) AS ANTAL_DISTANS
FROM MYH_TABELL_2025
GROUP BY 
ORDER BY