-- Which customers had no orders in certain months 
WITH months AS (
SELECT
  DISTINCT SUBSTR(order_date,1,7) AS month
FROM orders 
), 

customer_month_grid AS ( 
SELECT
  c.customer_id, 
  c.name, 
  m.month
FROM customers c 
CROSS JOIN months m 
), 

customer_month_order AS ( 
SELECT
  customer_id, 
  SUBSTR(order_date,1,7) AS month, 
  COUNT(*) AS order_count
FROM orders
GROUP BY customer_id, SUBSTR(order_date,1,7)
)

SELECT
	cmg.name, 
    cmg.customer_id, 
    cmg.month, 
    COALESCE(cmo.order_count,0) AS order_count
FROM customer_month_grid cmg
LEFT JOIN customer_month_order cmo 
	ON cmo.customer_id = cmg.customer_id
    AND cmo.month = cmg.month
WHERE order_count IS NULL
ORDER BY cmg.customer_id, cmg.month;
