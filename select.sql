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

-- Selects all countries which earned 0 medals in a certain sport and year of the olympic games
-- despite having over 50 participants and 10,000,000 country population.
SELECT c.Name as CountryName, t.Year, s.SportName FROM Country as c
INNER JOIN
	(SELECT o.CountryCode, o.SportID, o.Year FROM OlympicTeam AS o
	WHERE TotalParticipants > 50 AND NoMedalCount = TotalParticipants) AS t
ON c.Code = t.CountryCode
INNER JOIN Sport as s
ON s.SportID = t.SportID
WHERE c.Population > 10000000;

-- Selects Olympic sports that get over 10 participants 
-- and have been in the games over 100 times, returns average gold count & participants.
SELECT 
	s.SportName, 
	AVG(o.TotalParticipants) AS AvgTotalParticipants,
    AVG(o.GoldCount) AS AvgGoldCount 
FROM Sport as s
JOIN
    OlympicTeam AS o ON s.SportID = o.SportID
WHERE s.SportID IN
	(SELECT o.SportID FROM OlympicTeam AS o
    GROUP BY o.SportID
    HAVING COUNT(o.SportID) > 100
    AND AVG(o.TotalParticipants) > 10)
GROUP BY s.SportName;

-- Selects cities which have a population that makes up
-- 10% of their respective countries population
-- AND the countries GNP is higher than the global average
SELECT 
	ci.Name AS CityName, 
    ci.Population,
    t.Name AS CountryName,
    t.Population AS CountryPopulation,
    (ci.Population / t.Population) AS PopulationRatio
FROM City AS ci
LEFT JOIN
	(SELECT * FROM Country
    WHERE GNP > (SELECT AVG(GNP) FROM Country)
    ) AS t
ON ci.CountryCode = t.Code
HAVING PopulationRatio > 0.10
ORDER BY PopulationRatio DESC, ci.Population DESC;


-- Brianna's Queries

-- Query with subquery that shows sports that are more popular than the average popularity. 
SELECT Sport.SportName, Sport.SportID, CountrySport.CountryCode, CountrySport.Popularity -- Select the SportName variable from the "Sport" table
FROM Sport 
JOIN CountrySport ON Sport.SportID = CountrySport.SportID
WHERE CountrySport.Popularity > (
	SELECT AVG(Popularity) 
    FROM CountrySport
)
ORDER BY CountrySport.Popularity DESC;
    
-- Query with subquery that finds the top 10 least popular sports in europe
SELECT Sport.SportName, Sport.SportID, MIN(CountrySport.Popularity) AS LeastPopular
FROM Sport
JOIN CountrySport ON Sport.SportID = CountrySport.SportID
WHERE CountrySport.CountryCode IN (
    SELECT Code
    FROM Country
    WHERE Continent = 'Europe'
)
GROUP BY Sport.SportName, Sport.SportID
ORDER BY LeastPopular ASC
LIMIT 10;


-- Query with subquery that shows the sports, organized by popularity, in Asian countries who have official languages
SELECT Sport.SportName, Sport.SportID, CountrySport.CountryCode, CountrySport.Popularity, CountryLanguage.Language
FROM Sport
JOIN CountrySport ON Sport.SportID = CountrySport.SportID
JOIN CountryLanguage ON CountrySport.CountryCode = CountryLanguage.CountryCode
WHERE CountryLanguage.IsOfficial = 'T'
  AND CountryLanguage.CountryCode IN (
      SELECT Code
      FROM Country
      WHERE Continent = 'Asia'
  )
ORDER BY CountryLanguage.Language ASC;
    
-- Query with subquery that finds cities in Italy with the lowest population
SELECT Name as CityName, Population, CountryCode,
	( 
		SELECT Name 
        FROM Country
        WHERE Code = City.CountryCode
	) AS CountryName
FROM City
WHERE CountryCode = (
	SELECT Code
    FROM Country
    WHERE Name = "Italy"
)
ORDER BY Population ASC;

-- Query with subquery that finds the largest cities where basketball is played
SELECT City.Name AS CityName, City.Population, City.CountryCode
FROM City
WHERE City.CountryCode IN (
    SELECT CountryCode
    FROM CountrySport
    JOIN Sport ON CountrySport.SportID = Sport.SportID
    WHERE Sport.SportName = 'Basketball'
)
ORDER BY City.Population DESC;

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
ORDER BY NumberOfSports DESC;


-- Ahad's Queries

-- Query 1: Countries and their cities with population info
SELECT c.Name AS Country, ci.Name AS City, ci.Population, ci.District
FROM Country AS c
JOIN City AS ci
    ON c.Code = ci.CountryCode
ORDER BY c.Name, ci.Population DESC;

-- Query 2- Countries with official languages and and their sports
SELECT c.Name AS Country, cl.Language, s.SportName, cs.Popularity
FROM Country AS c
JOIN CountryLanguage AS cl
    ON c.Code = cl.CountryCode
JOIN CountrySport AS cs
    ON c.Code = cs.CountryCode
JOIN Sport AS s
    ON cs.SportID = s.SportID
WHERE cl.IsOfficial = 'T'
ORDER BY c.Name, cs.Popularity DESC;


-- Query 3- Sports and where they came from plus countries that plays that sport
SELECT s.SportName, co_origin.Name AS OriginCountry, co_play.Name AS PlayingCountry, cs.Popularity
FROM Sport AS s
JOIN Country AS co_origin
    ON s.CountryOrigin = co_origin.Code
JOIN CountrySport AS cs
    ON s.SportID = cs.SportID
JOIN Country AS co_play
    ON cs.CountryCode = co_play.Code
ORDER BY s.SportName, cs.Popularity DESC;


-- Query 4: Countries with their official languages
SELECT c.Name AS Country, cl.Language, cl.Percentage, cl.IsOfficial
FROM Country AS c
JOIN CountryLanguage AS cl
    ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
ORDER BY c.Name, cl.Percentage DESC;

-- Query 5: Countries with their languages and sports they play
SELECT c.Name AS Country, cl.Language, s.SportName, cs.Popularity
FROM Country AS c
JOIN CountryLanguage AS cl
    ON c.Code = cl.CountryCode
JOIN CountrySport AS cs
    ON c.Code = cs.CountryCode
JOIN Sport AS s
    ON cs.SportID = s.SportID
ORDER BY c.Name, cl.Language, cs.Popularity DESC;





