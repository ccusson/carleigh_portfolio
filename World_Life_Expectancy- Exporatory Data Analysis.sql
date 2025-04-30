SELECT * 
FROM world_life_expectancy
;


# This query is returning the minimum and maxium life expectancy for each country and determining the increase within the last 15 years.
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`) ,1) AS Life_Increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_years DESC
;

#Looking through data to determine the average life expectancy per each year
SELECT YEAR, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY YEAR
ORDER BY YEAR
;

# Query is identifying the average life expectany is correlation with the average GDP
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp <> 0
AND GDP <> 0
ORDER BY GDP
;

# This is a Case statement determining the Average life exp for country that has a GDP that is greater or less than 1500 (determined this is
	# about the halfway point). Utilized a count function and case statement to return the total country that meet the criteria using 1 or 0. Then 
	# took an average of those country's life_exp. Used NULL instead of 0 as to not affect our average.
SELECT 
SUM(CASE WHEN GDP  >= 1500 THEN 1  ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP  >= 1500 THEN `Life expectancy`  ELSE NULL END),2) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP  <= 1500 THEN 1  ELSE 0 END) LOW_GDP_Count,
ROUND(AVG(CASE WHEN GDP  <= 1500 THEN `Life expectancy`  ELSE NULL END),2) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

# Utilized the Distinct Count function determine if there is a small amount of a certain status.
SELECT Status, COUNT( DISTINCT Country), ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
GROUP BY Status
;

# Query is identifying the average life expectany is correlation with the average BMI
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp <> 0
AND BMI <> 0
ORDER BY BMI DESC
;



#This query is utilizing a rolling total year after year per country with Adult Mortality. So the last row of that country show the total mortality. Then utilized 
	# Where statement to search for countries with United in the country name.
SELECT Country, Year, `Life expectancy`, `Adult Mortality`, SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;



