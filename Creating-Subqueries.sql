With this query we find the average amount paid by the top 5 customers: 

SELECT AVG (total_amount_paid) AS avg_amount_paid
FROM (SELECT A.customer_id, A.first_name, A.last_name, C.city, D.country, SUM(amount) AS total_amount_paid
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
LIMIT 5) AS mean;



This second query helps us to find out how many of the top 5 customers we identified in step 1 are based within each country.

SELECT couA.country,
COUNT(DISTINCT custA.customer_id) AS all_customer_count,
COUNT (DISTINCT top_five_customers.customer_id) AS top_customer_count
FROM customer AS custA
INNER JOIN address AS addrA ON custA.address_id = addrA.address_id
INNER JOIN city AS citA ON addrA.city_id = citA.city_id
INNER JOIN country AS couA ON citA.country_id = couA.country_id
LEFT JOIN
(SELECT A.customer_id, A.first_name, A.last_name, C.city, D.country, SUM(amount) AS total_amount_paid
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
LIMIT 5)
AS top_five_customers ON top_five_customers.country = couA.country
GROUP BY couA.country
ORDER BY top_customer_count DESC, all_customer_count DESC
LIMIT 5;


While steps 1 and 2 could technically be done without subqueries, combining all logic into a single large query would make it harder to read, maintain and debug. 
Subqueries allow us to isolate specific tasks (like calculating the average amount paid by the top 5 customers) and handle complex aggregations more cleanly. 
They help break down problems into manageable parts, improving clarity and reducing the risk of error.
