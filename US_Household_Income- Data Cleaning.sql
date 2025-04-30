# US Household Income Project (Data Cleaning)
#downloaded from a gov website

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

#Changing column name
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` to `id`;

SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;


#identifying duplicate ids
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) >1
;

# This query is deleting the duplicate ids that were found in the above query. Where the subquery is assigning row numbers to the ids and then the where statement
	# is filtering the items that have more than one entry and deleting
DELETE FROM us_household_income
WHERE row_id IN(
	SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_project.us_household_income
		) duplicates
	WHERE row_num>1)
;


#identifying duplicate ids
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) >1
;


# Searching data set for incorrect state names and formats
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY State_Name
;

#Updating the incorrect Georgia spelling
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

#Updating the uppercase alabama
UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

# checking all state ab. are correct
SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY State_ab
;

# Checking where the place and county match 
SELECT *
FROM us_project.us_household_income
WHERE County= 'Autauga County'
ORDER BY 1
;

# Updating data set to return the county for the location that was initially missing that data
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

# Checking the difference types for duplicates or different formats
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

# Updating to change the boroughs to borough within the data set.
UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

# Checking for 0, blanks, or NULL values for the AWater. Utilized DISTINCT function to return the data type.
SELECT distinct ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = ' ' OR AWater IS NULL
;

# Checking for 0, blanks, or NULL values for the ALand. Utilized DISTINCT function to return the data type.
SELECT distinct ALand, AWater
FROM us_project.us_household_income
WHERE ALand = 0 OR ALand = ' ' OR ALand IS NULL
;
