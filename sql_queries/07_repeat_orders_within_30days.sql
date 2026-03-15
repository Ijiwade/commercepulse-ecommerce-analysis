-- Orders within 30 days of first purchase 
-- which customers place additional orders shortly after their first purchase? 

WITH first_order_date AS (
SELECT
  customer_id,
  MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id
)

SELECT
	c.customer_id,
    c.name,
	fod.first_order_date, 
    COUNT(*) AS repeat_orders_in_30_days
FROM customers c 
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN first_order_date fod
	ON fod.customer_id = o.customer_id
WHERE o.order_date > fod.first_order_date
	AND o.order_date <= DATE(fod.first_order_date, '+30 Days')
GROUP BY c.customer_id, c.name, fod.first_order_date;
