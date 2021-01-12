#!/bin/bash

echo "DROP TABLE IF EXISTS Extension;
CREATE TABLE Extension(
    dateRep DATE PRIMARY KEY
);
INSERT INTO Extension ('dateRep') SELECT dateRep FROM Dates;

.output output.txt
SELECT geoId FROM Cases GROUP BY geoid ORDER BY sum(abs(deaths)) DESC LIMIT 10;
.exit" | sqlite3 coronavirus.db

COUNTRIES=$(cat output.txt) 
rm "output.txt"

for GEOID in $COUNTRIES
do 
    echo "ALTER TABLE Extension ADD '${GEOID}' INTEGER;
.exit" | sqlite3 coronavirus.db
done

for GEOID in $COUNTRIES
do 
    echo ".output output${GEOID}.txt
    SELECT daterep, SUM(Abs(deaths)) OVER (ORDER by (substr(dateRep, 7, 4) || '/' || substr(dateRep, 4, 2) || '/' ||
    substr(dateRep, 1, 2)) ASC) FROM dataset WHERE geoId='${GEOID}';" | sqlite3 coronavirus.db
    
    file="output${GEOID}.txt"
    while IFS= read -r line
    do
        DATEREP=$(echo ${line} | cut -d"|" -f1)
        DEATHS=$(echo ${line} | cut -d"|" -f2)
        echo "UPDATE Extension SET $GEOID='${DEATHS}' WHERE dateRep='${DATEREP}';" | sqlite3 coronavirus.db
    done < "$file"
    
    rm "output${GEOID}.txt"
done

echo "
.output data.dat
SELECT * FROM Extension ORDER by (substr(dateRep, 7, 4) || '/' || substr(dateRep, 4, 2) || '/' || substr(dateRep, 1, 2)) ASC;
.exit" | sqlite3 coronavirus.db

PLOT_INFO="";
INDEX=2
for GEOID in $COUNTRIES
do
    PLOT_INFO=$PLOT_INFO"'data.dat' u 1:${INDEX} t '${GEOID}',"
    INDEX=`expr $INDEX + 1`
done


echo > gnuplot.in 
echo "set style data lines
set datafile separator '|'
set key autotitle columnhead
set xdata time
set format x '%bn%y'
set term png 
set output 'graph.png'
plot ${PLOT_INFO}" >> gnuplot.in
gnuplot gnuplot.in

rm gnuplot.in
rm data.dat