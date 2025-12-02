-- Original tables given by professor

-- City table
CREATE TABLE City (
    ID INT(11) NOT NULL auto_increment,
    Name CHAR(35) NOT NULL DEFAULT '',
    CountryCode CHAR(3) NOT NULL DEFAULT '',
    District CHAR(20) NOT NULL DEFAULT '',
    Population INT(11) DEFAULT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- country table
CREATE TABLE Country (
    Code CHAR(3) NOT NULL DEFAULT '',
    Name CHAR(52) NOT NULL DEFAULT '',
    Continent ENUM('Asia','Europe','North
    America','Africa','Oceania','Antarctica','South America') NOT NULL default 'Asia',
    Region CHAR(26) NOT NULL DEFAULT '',
    SurfaceArea FLOAT(10,2) NOT NULL DEFAULT '0.00',
    IndepYear SMALLINT(6) DEFAULT NULL,
    Population INT(11) DEFAULT NULL,
    LifeExpectancy FLOAT(3,1) DEFAULT NULL,
    GNP FLOAT(10,2) DEFAULT NULL,
    GNPOld FLOAT(10,2) DEFAULT NULL,
    LocalName CHAR(45) NOT NULL DEFAULT '',
    GovernmentForm CHAR(45) NOT NULL DEFAULT '',
    HeadOfState CHAR(60) DEFAULT NULL,
    Capital INT(11) DEFAULT NULL,
    Code2 CHAR(2) NOT NULL DEFAULT '',
    PRIMARY KEY (Code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- CountryLanguage table
CREATE TABLE CountryLanguage (
    CountryCode CHAR(3) NOT NULL DEFAULT '',
    Language CHAR(30) NOT NULL DEFAULT '',
    IsOfficial ENUM('T','F') NOT NULL DEFAULT 'F',
    Percentage FLOAT(4,1) NOT NULL DEFAULT '0.0',
    PRIMARY KEY (CountryCode,Language)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- new tables based on the ER diagram

-- Sport table
CREATE TABLE Sport (
    SportID INT(11) NOT NULL auto_increment,
    SportName CHAR(35) NOT NULL DEFAULT '',
    Type CHAR(20) NOT NULL DEFAULT '',
    CountryOrigin CHAR(52) NOT NULL DEFAULT '',
    PRIMARY KEY (SportID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- CountrySport table
CREATE TABLE CountrySport (
    CountryCode CHAR(3) NOT NULL DEFAULT '',
    SportID INT(11) NOT NULL DEFAULT '0',
    ParticipationRate FLOAT(4,1) DEFAULT '0.0',
    Popularity INT(11) DEFAULT NULL,
    PRIMARY KEY (CountryCode, SportID),
    FOREIGN KEY (CountryCode) REFERENCES Country (Code),
    FOREIGN KEY (SportID) REFERENCES Sport (SportID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- OlympicTeam table
CREATE TABLE OlympicTeam (
    OlympicTeamID INT(11) NOT NULL auto_increment,
    CountryCode CHAR(3) NOT NULL DEFAULT '',
    SportID INT(11) NOT NULL DEFAULT '0',
    Year INT(11) NOT NULL DEFAULT '0',
    GoldCount INT(11) DEFAULT '0',
    SilverCount INT(11) DEFAULT '0',
    BronzeCount INT(11) DEFAULT '0',
    TotalParticipants INT(11) DEFAULT NULL,
    PRIMARY KEY (OlympicTeamID),
    FOREIGN KEY (CountryCode) REFERENCES Country (Code),
    FOREIGN KEY (SportID) REFERENCES Sport (SportID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;