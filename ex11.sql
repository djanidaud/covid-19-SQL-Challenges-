CREATE TABLE Dates(
    dateRep DATE PRIMARY KEY,
    day INTEGER,
    month INTEGER,
    year INTEGER
);

CREATE TABLE Countries(
    geoId VARCHAR(255) PRIMARY KEY,
    countriesAndTerritories VARCHAR(255),
    countryterritoryCode VARCHAR(255),
    popData2018 INTEGER
 );

CREATE TABLE Continents(
    countriesAndTerritories VARCHAR(255) PRIMARY KEY,
    continentExp VARCHAR(255)
 );

 CREATE TABLE Cases(
    dateRep DATE,
    geoId VARCHAR(255),
    cases INTEGER,
    deaths INTEGER,
    PRIMARY KEY(dateRep,geoId)
 );
 

