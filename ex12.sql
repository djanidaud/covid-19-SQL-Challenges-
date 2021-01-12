INSERT INTO Dates ('dateRep','day','month','year') SELECT DISTINCT dateRep,day,month,year FROM dataset;

INSERT INTO Continents ('countriesAndTerritories','continentExp') SELECT DISTINCT countriesAndTerritories,continentExp FROM dataset;

INSERT INTO Countries ('geoId','countriesAndTerritories','countryterritoryCode','popData2018') SELECT DISTINCT geoId,countriesAndTerritories,countryterritoryCode,popData2018 FROM dataset;

INSERT INTO Cases ('dateRep','geoId','cases','deaths') SELECT DISTINCT dateRep,geoId,cases,deaths FROM dataset;