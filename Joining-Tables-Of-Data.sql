This query finds the top 10 countries for Rockbuster in terms of customer numbers: 

SELECT country,
COUNT (customer_id) AS count_of_customer
FROM customer
INNER JOIN address AS addrs ON customer.address_id = addrs.address_id
INNER JOIN city AS cty ON addrs.city_id = cty.city_id
INNER JOIN country AS cntry ON cty.country_id = cntry.country_id
GROUP BY country
ORDER BY count_of_customer DESC
LIMIT 10;

In order to extract the requested data, we need to join four tables from our dataset: customer, address, city, and country. These tables define the relational path:
customer (address_id) → address (city_id) → city (country_id) → country.
The results are grouped by country, ordered by the count of customers in descending order, and limited to show only the top 10 countries.

//

The following query identifies the top 10 cities that fall within the top 10 countries I identified in step 1.

SELECT city, country,
COUNT (customer_id) AS count_of_customer
FROM customer
INNER JOIN address AS addrs ON customer.address_id = addrs.address_id
INNER JOIN city AS cty ON addrs.city_id = cty.city_id
INNER JOIN country AS cntry ON cty.country_id = cntry.country_id
WHERE country IN ('India','China','United States','Japan', 'Mexico','Brazil',
'Russian Federation','Philippines','Turkey', 'Indonesia')
GROUP BY city,country
ORDER BY count_of_customer DESC
LIMIT 10;

Since we already know which countries to focus on, I applied a WHERE clause with an IN filter to limit the data to those specific countries. 
I also reused the necessary JOINs to bring together the relevant information. 
Finally, I grouped the results by both city and country to ensure the aggregation was accurate at the city level.

//

The next query finds the top 5 customers from the top 10 cities who’ve paid the highest total amounts to Rockbuster. 

SELECT A.customer_id, A.first_name, A.last_name, C.city, D.country, SUM(amount) AS total_amount_paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON b.city_id = c.city_id
INNER JOIN country D ON c.country_id = d.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE c.city IN(SELECT C.city
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D on C.country_id = D.country_id
WHERE D.country IN
(SELECT D.country
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D on C.country_id = D.country_id
GROUP BY country
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY D.country, C.city
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY A.customer_id, A.first_name, A.last_name, C.city, D.country
ORDER BY total_amount_paid DESC
LIMIT 5;

