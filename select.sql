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

-- Brianna's Queries

-- Subquery of sports that are more popular than the average popularity. 
SELECT SportName -- Select the SportName variable from the "Sport" table
FROM Sport 
WHERE SportID IN ( -- Find the SportID in table "CountrySport" that meet the following conditions
	SELECT SportID 
    FROM CountrySport 
    WHERE Popularity > ( -- Specifically, the SportID where the popularity is greater than the average popularity
		SELECT AVG(Popularity) -- Calc avg popularity in CountrySport table
        FROM CountrySport 
        )
	);
    
-- Subquery of the sports that are played by the country with the highest population
SELECT SportName
FROM Sport
WHERE SportID IN (
	SELECT SportID
    FROM CountrySport
    WHERE CountryCode = (
		SELECT Code
        FROM Country
        ORDER BY Population DESC
        LIMIT 1
	)
);

-- Subquery that shows the LEAST popular sport in countries where Italian is spoken
SELECT SportName
From Sport
Where SportID = (
	SELECT SportID
    FROM CountrySport
    WHERE CountryCode IN (
		SELECT CountryCode
        FROM CountryLanguage 
        WHERE Language = 'Italian' AND IsOfficial = 'T'
	)
    ORDER BY Popularity ASC
    LIMIT 1
);
    
-- Subquery that finds the city in Italy with the lowest population
SELECT Name as CityName, Population
FROM City
WHERE CountryCode = (
	SELECT Code
    FROM Country
    WHERE Name = "Italy"
)
AND Population = (
	SELECT MIN(Population)
    FROM CITY
    WHERE CountryCode = (
		SELECT Code
        FROM Country
        WHERE Name = "Italy"
	)
);

-- Subquery that finds the official language or languages of the country whos most popular sport is tennis
SELECT CountryLanguage.Language
FROM CountryLanguage 
WHERE CountryLanguage.CountryCode = (
	SELECT CountrySport.CountryCode
    FROM CountrySport
    JOIN Sport ON CountrySport.SportID = Sport.SportID
    WHERE Sport.SportName = 'Tennis'
    ORDER BY CountrySport.Popularity DESC
    LIMIT 1
)
AND CountryLanguage.IsOfficial = 'T'


-- Dhuha's Queries 

--  List all sports with the countries where they originated

SELECT s.SportName, c.Name AS OriginCountry
FROM Sport AS s
JOIN Country AS c
    ON s.CountryOrigin = c.Code;

--  Show each country with its most popular sport

SELECT c.Name AS Country, s.SportName, cs.Popularity
FROM Country AS c
JOIN CountrySport AS cs
    ON c.Code = cs.CountryCode
JOIN Sport AS s
    ON cs.SportID = s.SportID
JOIN (
        SELECT CountryCode, MAX(Popularity) AS MaxPop
        FROM CountrySport
        GROUP BY CountryCode
     ) AS t
    ON t.CountryCode = cs.CountryCode
   AND t.MaxPop = cs.Popularity;


--  List all cities and the most popular sport in their country

SELECT ci.Name AS City,
       co.Name AS Country,
       sp.SportName,
       cs.Popularity
FROM City AS ci
JOIN Country AS co
    ON ci.CountryCode = co.Code
JOIN CountrySport AS cs
    ON co.Code = cs.CountryCode
JOIN Sport AS sp
    ON cs.SportID = sp.SportID
ORDER BY co.Name, cs.Popularity DESC;


--  List countries grouped by continent with the sports they play

SELECT co.Continent,
       co.Name AS Country,
       sp.SportName
FROM Country AS co
JOIN CountrySport AS cs
    ON co.Code = cs.CountryCode
JOIN Sport AS sp
    ON cs.SportID = sp.SportID
ORDER BY co.Continent, co.Name;

-- Shows each country and how many sports are played there
SELECT c.Name AS Country,
       COUNT(cs.SportID) AS NumberOfSports
FROM Country AS c
JOIN CountrySport AS cs
    ON c.Code = cs.CountryCode
GROUP BY c.Name
ORDER BY NumberOfSports DESC;;

