# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

# This query is returning the duplicate countries with the same year.
# Have to use GROUP BY due to the COUNT function in the SELECT statement
# Used CONCAT function because there is no unqiue column in date EX. employee id
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) >1
;

# This subquery is returning the Row_Id from original data, the CONCAT on the country and year	
	# the the ROW_NUMBER() OVER (PARITION BY ) is creating a column assigns a row_num to the CONCAT(COUNTRY, YEAR), which assigns a 2 or more to duplicates
# The main query is only selecting the rows that have more than 1 row_num (meaning they are duplicates)

SELECT *
FROM (
	SELECT Row_ID, 
    CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_num > 1
;

# This query is updating the table to delete the rows that have the row_id in the above query
# make sure that you have a backup table, so not to ruin the original data set
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID, 
    CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_num > 1
)
;

## Identifying missing data in Status column

#this query is returning rows that have a blank status
SELECT * 
FROM world_life_expectancy
WHERE Status= ''
;

# this query is identifying what distinct status types are in data set
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

#Searching the distinct countries that have developing
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

#this query is updating the table to refelct status of blanks by using previous years of that country's status
# this query does NOT work as you cannot have a subquery within a UPDATE statement
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN
	(SELECT DISTINCT(Country)
	FROM world_life_expectancy
	WHERE Status = 'Developing')
;

# this query is using a JOIN statement to work around the error from previous query
# this is joining table to itself
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country =t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;
    
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country =t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

## Life expectancy

# Since the life expectancy is constantly increaing, we will take average of previous year and next year to get average for missing year
SELECT * 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
;

# this query is combining the table to itself twice. The first join is subtracting a year and returning life expectancy and country. The second join is adding a year
# the joins now reflect in one row the inital blank LE, the next year's LE, and the previous year's LE

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country= t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country= t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy` = ''
;

#this query is returning a column to find the average
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1) AS average
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country= t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country= t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy` = ''
;

#this query is updating the table to add life expectancy into the actual data set
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country= t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country= t3.Country
    AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;



