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
    NoMedalCount INT(11) DEFAULT '0',
    TotalParticipants INT(11) DEFAULT NULL,
    PRIMARY KEY (OlympicTeamID),
    FOREIGN KEY (CountryCode) REFERENCES Country (Code),
    FOREIGN KEY (SportID) REFERENCES Sport (SportID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
