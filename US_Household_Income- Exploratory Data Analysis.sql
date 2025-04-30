# US Household Income Project (Exploratory Data Analysis)

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

# Query that is summing the total Land and Water for each state. Returning the 10 total largest states by land.
SELECT State_Name,  SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

# Joining both tables with an Inner Join, which is just adding all of the columns from both tables using the id.
# This inner join will only add the data if there is no NULL values on both tables.
SELECT * 
FROM us_project.us_household_income u 
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
;
    
# Using a Right Join to add all the values from the statistic table regardless if there are any NULL values in the income table
	# This query is returning all the values that are NULL from the income table
    # You should always explore you data. We would want to use a INNER Join so that no NULL values are returned or alter our analysis. 
SELECT * 
FROM us_project.us_household_income u 
RIGHT JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE u.id IS NULL
;


# Filtering Mean and statistics that are equal to zero
SELECT * 
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

# This query is returning the average mean and median for each state as a whole and returning the bottom 5
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5
;

# This query returns the average mean and median for each type of living
SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY TYPE
ORDER BY 3 DESC
;

# Searching where the outliers of the community type was located
SELECT *
FROM us_household_income
WHERE Type= 'Community'
;


#Removing the outliers from the table. 
SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY TYPE
HAVING COUNT(TYPE) > 100
ORDER BY 3 DESC
;

# This query returns the average mean and median for each type of state and city
SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_name, City
ORDER BY ROUND(AVG(Median),1) DESC 
;


SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_name, City
HAVING State_Name = 'Colorado'
ORDER BY ROUND(AVG(Mean),1) DESC 
;
