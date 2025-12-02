-- Eli's Queries

-- Selects every City where the first letter equals their countrys first letter

SELECT * FROM
	(SELECT c.Name AS City, ci.Name AS Country FROM City AS ci
	LEFT JOIN Country AS c
	ON ci.CountryCode = c.Code) as t
WHERE SUBSTRING(t.City, 1, 1) LIKE SUBSTRING(t.Country, 1, 1)
;

-- Selects all countries having a language with over 50% usage despite it not being an official language

SELECT c.name, t.language FROM Country AS c
RIGHT JOIN
	(SELECT * FROM CountryLanguage 
    WHERE Percentage > 50 AND IsOfficial = 'F'
    ORDER BY Percentage DESC) AS t
ON t.CountryCode = c.Code;

-- 
SELECT * FROM Sport;

SELECT c.Name, s.SportID FROM Country AS c
RIGHT JOIN CountrySport as s
ON c.Code = s.CountryCode;
