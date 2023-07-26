/* Q1. How many number of customers not owning house and has more than 3 records in purchase point records?

  */

/* there are no records with record_type = 1 and have 3 records for the same customer so output is zero*/

SELECT COUNT(*) AS num_customers
FROM (
    SELECT customer_id
    FROM [Customer Purchase]
    WHERE homeowner = 0 and record_type = 1
    GROUP BY customer_id
    HAVING COUNT(*) > 3
) AS subquery;


/*
Q2. Which location has the highest percentage of
 records on Thursday and coverage 'D' option is greter than or equal to 2?

 */
WITH filtered_data AS (
    SELECT location
    FROM [Customer Purchase]
    WHERE [day] = 3 AND D >= 2
)
SELECT TOP 1 location
FROM (
    SELECT location, COUNT(*) AS location_count
    FROM filtered_data
    GROUP BY location
) AS subquery
ORDER BY location_count DESC

/*
Q3. Calculate the state level total shopping point for all purchase points records and 'G' coverage option is 3. 
Which state has the second highest value? 
*/
SELECT state, SUM(shopping_pt) AS total_shopping_points
FROM [Customer Purchase]
WHERE  G = 3 and record_type = 1
GROUP BY state
ORDER BY total_shopping_points DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY

/*
Q4. Calculate the percentages cost at each state level
 and what is the percentage of cost for the states ends with 'A'?
 */
WITH state_cost AS (
    SELECT state, SUM(cost) AS total_cost
    FROM [Customer Purchase]
    GROUP BY state
)
SELECT SUM(total_cost) AS total_cost,
       SUM(CASE WHEN RIGHT(state, 1) = 'A' THEN total_cost ELSE 0 END) AS cost_ending_with_A,
       (SUM(CASE WHEN RIGHT(state, 1) = 'A' THEN total_cost ELSE 0 END) * 100.0) / SUM(total_cost) AS percentage_ending_with_A
FROM state_cost;

/*
5.Which category car value has the
 fifth highest cost value for the purchase point records and group size is less than 3?
 */
WITH filtered_data AS (
    SELECT car_value, SUM(cost) AS total_cost
    FROM [Customer Purchase]
    WHERE group_size < 3 AND record_type = 1
    GROUP BY car_value
)
SELECT car_value
FROM (
    SELECT car_value, ROW_NUMBER() OVER (ORDER BY total_cost DESC) AS row_num
    FROM filtered_data
) AS subquery
WHERE row_num = 5;






