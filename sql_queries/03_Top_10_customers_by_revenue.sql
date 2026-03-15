-- Top 10 customers by revenue 
WITH order_revenue AS ( 
SELECT 
  o.order_id,
  o.customer_id,
  ROUND(COALESCE(SUM(
  COALESCE(oi.quantity,0) * 
  COALESCE(p.unit_price,0) *
  (1 - COALESCE(oi.discount_pct,0))
  ),0),2) AS gross_revenue
FROM orders o 
LEFT JOIN order_items oi 
  ON o.order_id = oi.order_id
LEFT JOIN products p 
  ON p.product_id = oi.product_id
GROUP BY o.order_id, o.customer_id
)

SELECT
	c.customer_id, 
    c.name,
   	ROUND(COALESCE(SUM(orr.gross_revenue),0),2) AS revenue_per_customer
FROM customers c
LEFT JOIN order_revenue orr
	ON orr.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue_per_customer DESC
LIMIT 10;
