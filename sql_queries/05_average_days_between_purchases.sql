-- Average days between purchases 
/*On average, how many days pass between one purchase and the next for each customer?*/

WITH seq AS (
SELECT
  customer_id, 
  order_date, 
  order_id, 
  LAG(order_date)OVER(
    PARTITION BY customer_id 
    ORDER BY order_date, order_id
  ) AS prev_order_date
FROM orders
), 

scored AS (
SELECT
  *,
  (julianday(order_date) - julianday(prev_order_date)) AS days_between_orders
FROM seq
)

SELECT
	c.customer_id, 
    c.name, 
    ROUND(AVG(s.days_between_orders),2) AS avg_days_between_orders
FROM customers c 
LEFT JOIN scored s 
	ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
-- HAVING AVG(s.days_between_orders) IS NOT NULL
ORDER BY avg_days_between_orders DESC;
