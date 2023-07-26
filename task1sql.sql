

/* Q1. What are the Number of Unique customers? */

SELECT COUNT(DISTINCT customer_ID) AS [Unique Customers]
FROM [Customer Purchase]

/* Q2. What is the highest average cost at location level On Monday? 
Hint: You are required to calulate average cost for each location on Monday. 
Find the average cost for top most location */



SELECT TOP 1 location, CAST(AVG(CAST(cost AS decimal(18, 2))) AS float) AS average_cost
FROM [Customer Purchase]
WHERE [day] = 0
GROUP BY location
ORDER BY average_cost DESC;


/* Q3. Which age_oldest has more number of records after 9PM? */

SELECT TOP 1 age_oldest, COUNT(*) AS record_count
FROM [Customer Purchase]
WHERE DATEPART(HOUR, [time]) >= 21 
GROUP BY age_oldest
ORDER BY record_count DESC;

/* Q4. Find the third highest state which generating more cost. */

SELECT [state]
FROM [Customer Purchase]
GROUP BY [state]
ORDER BY SUM(cost) DESC
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY

/* Q5. Which risk factor has the highest percentage of records(Ignore nulls)? */

SELECT TOP 1 risk_factor, 
       COUNT(*) AS total_records,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage
FROM [Customer Purchase]
WHERE risk_factor != 'NA'
GROUP BY risk_factor
ORDER BY total_records DESC

/* Q6. Q6. What percentage of married couples are purchasing car insurance on Wednesday? */


SELECT 
    (CAST(SUM(CASE WHEN married_couple = 1 AND day = 2 THEN cost ELSE 0 END) AS float) * 100) / CAST(SUM(cost) AS float) AS percentage
FROM 
    [Customer Purchase]


/* Q7. What is the highest average cost for the coverage options B is zero and G is 4 at customer level? */

SELECT TOP 1 customer_id, AVG(cost) AS average_cost
FROM [Customer Purchase]
WHERE B = 0
  AND G = 4
GROUP BY customer_id
ORDER BY average_cost DESC;


/* Q8. What is the highest percentage of records was covered by thier previous issuer for the unmarried couples? */
/* question lacks description */

SELECT
    (SUM(CASE WHEN married_couple = 0 AND ISNUMERIC(duration_previous) = 1 AND CAST(duration_previous AS INT) > 0 THEN 1 ELSE 0 END) * 100.0) / (SELECT COUNT(*) FROM [Customer Purchase] WHERE married_couple = 0 ) AS highest_percentage_of_records_covered
FROM
    [Customer Purchase]
WHERE
    married_couple = 0 ;



/* Q9. Select all the records which has the cost value is greater than 90th percentile value and what is the average 
shopping_pt for those selected records? */

SELECT *
FROM [Customer Purchase]
WHERE cost > (
  SELECT MAX(cost)
  FROM (
    SELECT cost, NTILE(100) OVER (ORDER BY cost) AS percentile
    FROM [Customer Purchase]
  ) AS Subquery
  WHERE percentile = 90
)

SELECT CAST(AVG(CAST(shopping_pt AS float)) AS float) AS average_shopping_pt
FROM [Customer Purchase]
WHERE cost > (
  SELECT MAX(cost)
  FROM (
    SELECT cost, NTILE(100) OVER (ORDER BY cost) AS percentile
    FROM [Customer Purchase]
  ) AS Subquery
  WHERE percentile = 90
);


/* Q10. What is the percentage of records difference 
between weekdays and weekends(Saturday & Sunday) for married couples? */

SELECT 
    (SUM(CASE WHEN [day] IN (0, 1, 2, 3, 4) THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS weekday_percentage,
    (SUM(CASE WHEN [day] IN (5, 6) THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS weekend_percentage,(SUM(CASE WHEN [day] IN (0, 1, 2, 3, 4) THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
	-(SUM(CASE WHEN [day] IN (5, 6) THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
	as [Percentage difference]
FROM [Customer Purchase]
WHERE married_couple =  1

/* Q11. What percentage of homeowner records are in the risk factor 4 category? */


SELECT (
  CAST(NULLIF((SELECT COUNT(*) FROM [Customer Purchase] WHERE homeowner = 1 AND risk_factor = 4 AND risk_factor != 'NA'), 0) AS float) * 100.0
) / CAST((SELECT COUNT(*) FROM [Customer Purchase] WHERE homeowner = 1) AS float) AS percentage;



/* Q12. What the second highest cost hour for all purchase point records? */

SELECT TOP 1 second_highest_hour
FROM (
    SELECT TOP 2 DATEPART(HOUR, [time]) AS second_highest_hour
    FROM [Customer Purchase]
    WHERE record_type = 1
    GROUP BY DATEPART(HOUR, [time])
    ORDER BY SUM(cost) DESC
) AS subquery
ORDER BY second_highest_hour ASC;

/* Q13. What is the average shopping points for the maximum car age value and only for the shopping point records? */

SELECT CAST(AVG(CAST(shopping_pt AS FLOAT)) AS FLOAT) AS average_shopping_points
FROM [Customer Purchase]
WHERE car_age = (
  SELECT MAX(car_age) FROM [Customer Purchase]
) AND record_type = 0;



/* Q14. What is the least percentage of records for the customers not own's a home at state level? */


SELECT TOP 1 state, 
       COUNT(*) AS total_records,
       (COUNT(*) * 100.0) / 
         (SELECT COUNT(*) FROM [Customer Purchase] WHERE homeowner = 0) AS percentage
FROM [Customer Purchase]
WHERE homeowner = 0
GROUP BY state
ORDER BY percentage ASC;


/* Q15. How many number of unique unmarried customers from state in which the state is start with 'M'? */


SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM [Customer Purchase]
WHERE married_couple = 0 AND state LIKE 'M%'










