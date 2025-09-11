In the first query, which calculates the average total amount paid by the top five customers, I used Common Table Expressions (CTEs) to simplify the nested subqueries. 
I began by creating a base CTE that joins customer data with address, city, and country information. From there, I identified the top 10 countries and the top 10 cities based on customer count. 
Then, I calculated the total amount paid per customer within those top cities. After sorting by payment totals, I selected the top five customers and computed the average of their payments in the final step. 
Using CTEs helped modularize the query and made the logic clearer and easier to follow.

In the second query, which determines how many of the top five highest-paying customers are located in each country, I followed a similar approach. 
I reused the same CTE structure to extract customer location and payment data, and again identified top countries and cities based on customer volume. 
After calculating total payments and identifying the top five customers, I joined this data back to the broader customer-location dataset. 
This allowed me to count both the total number of customers per country and how many of the top five are in each one. Using CTEs in both queries made the SQL more readable and logically organized.



1A. Fining the average amount paid by the top 5 customers with CTE
WITH customer_with_lctn AS (
    SELECT 
        cust.customer_id, cust.first_name, cust.last_name,
        addr.address_id, city.city, country.country
    FROM customer cust
    INNER JOIN address addr ON cust.address_id = addr.address_id
    INNER JOIN city ON addr.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
),
top_countries_by_customer_count AS (
    SELECT country
    FROM customer_with_lctn
    GROUP BY country
    ORDER BY COUNT(customer_id) DESC
    LIMIT 10
),
top_city_country_pairs AS (
    SELECT country, city
    FROM customer_with_lctn
    WHERE country IN (SELECT country FROM top_countries_by_customer_count)
    GROUP BY country, city
    ORDER BY COUNT(customer_id) DESC
    LIMIT 10
),
customer_payments AS (
    SELECT 
        cust.customer_id, cust.first_name, cust.last_name,
        city.city, country.country,
        SUM(pay.amount) AS total_amount_paid
    FROM customer cust
    INNER JOIN address addr ON cust.address_id = addr.address_id
    INNER JOIN city ON addr.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    INNER JOIN payment pay ON cust.customer_id = pay.customer_id
    WHERE (country, city) IN (SELECT country, city FROM top_city_country_pairs)
    GROUP BY cust.customer_id, cust.first_name, cust.last_name, city.city, country.country
),
top_five_customers AS (
    SELECT *
    FROM customer_payments
    ORDER BY total_amount_paid DESC
    LIMIT 5
)
SELECT AVG(total_amount_paid) AS avg_amount_paid
FROM top_five_customers;

// 

1B. Finding out how many of the top 5 customers we identified in step 1 are based within each country.

WITH customer_with_lctn AS (
    SELECT 
        cust.customer_id, cust.first_name, cust.last_name,
        addr.address_id, city.city, country.country
    FROM customer cust
    INNER JOIN address addr ON cust.address_id = addr.address_id
    INNER JOIN city ON addr.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
),
top_countries_by_customer_count AS (
    SELECT country
    FROM customer_with_lctn
    GROUP BY country
    ORDER BY COUNT(customer_id) DESC
    LIMIT 10
),
top_cities_in_top_countries AS (
    SELECT city
    FROM customer_with_lctn
    WHERE country IN (SELECT country FROM top_countries_by_customer_count)
    GROUP BY city
    ORDER BY COUNT(customer_id) DESC
    LIMIT 10
),
customer_payments AS (
    SELECT 
        cust.customer_id, cust.first_name, cust.last_name,
        city.city, country.country, SUM(pay.amount) AS total_amount_paid
    FROM customer cust
    INNER JOIN address addr ON cust.address_id = addr.address_id
    INNER JOIN city ON addr.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    INNER JOIN payment pay ON cust.customer_id = pay.customer_id
    WHERE city.city IN (SELECT city FROM top_cities_in_top_countries)
    GROUP BY cust.customer_id, cust.first_name, cust.last_name, city.city, country.country
),
top_five_customers AS (
    SELECT *
    FROM customer_payments
    ORDER BY total_amount_paid DESC
    LIMIT 5
)
SELECT 
    cwl.country,
    COUNT(DISTINCT cwl.customer_id) AS all_customer_count,
    COUNT(DISTINCT tfc.customer_id) AS top_customer_count
FROM customer_with_lctn cwl
LEFT JOIN top_five_customers tfc ON cwl.country = tfc.country
GROUP BY cwl.country
ORDER BY all_customer_count DESC, top_customer_count DESC
LIMIT 5;

 
