WITH Top_10_countries AS (
    SELECT TOP 10 D.country
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city C ON B.city_id = C.city_id
    INNER JOIN country D ON C.country_id = D.country_id
    GROUP BY D.country
    ORDER BY COUNT(A.customer_id) DESC
),
Top_city AS (
    SELECT TOP 10 Ci.city
    FROM customer cu
    INNER JOIN address ad ON cu.address_id = ad.address_id
    INNER JOIN city Ci ON ad.city_id = Ci.city_id
    INNER JOIN country co ON Ci.country_id = co.country_id
    WHERE co.country IN (SELECT D.country FROM Top_10_countries D)
    GROUP BY co.country, Ci.city
    ORDER BY COUNT(cu.customer_id) DESC
),
Top_customer AS (
    SELECT TOP 5 SUM(A.amount) AS total_amount
    FROM payment A
    INNER JOIN customer B ON A.customer_id = B.customer_id
    INNER JOIN address C ON B.address_id = C.address_id
    INNER JOIN city D ON C.city_id = D.city_id
    INNER JOIN country E ON D.country_id = E.country_id
    WHERE D.city IN (SELECT city FROM Top_city)
    GROUP BY B.first_name, B.last_name, D.city, E.country
    ORDER BY total_amount DESC
)
SELECT AVG(total_amount) AS avg_total_amount
FROM Top_customer;
