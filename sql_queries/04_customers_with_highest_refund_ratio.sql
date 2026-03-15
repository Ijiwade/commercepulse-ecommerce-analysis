-- Customers with highest refund ratio 
 -- Which customers generate the highest proportion of refunds relative to the revenue they bring in? 
 WITH order_revenue AS ( 
 SELECT
   o.customer_id,
   o.order_id,
   ROUND(COALESCE(SUM(
   	COALESCE(oi.quantity,0) * 
   	COALESCE(p.unit_price,0) * 
   	(1 - COALESCE(oi.discount_pct,0))
   ),0),2) AS order_revenue
 FROM orders o 
 LEFT JOIN order_items oi 
   ON o.order_id = oi.order_id
 LEFT JOIN products p 
   ON p.product_id = oi.product_id
 GROUP BY o.customer_id, o.order_id
 ),
 
 customer_revenue AS (
 SELECT
   customer_id,
   COALESCE(SUM(order_revenue),0) AS total_revenue
 FROM order_revenue
 GROUP BY customer_id
 ),
 
 customer_refund AS ( 
 SELECT 
   o.customer_id,
   ROUND(COALESCE(SUM(r.refund_amount),0),2) AS total_refund
 FROM orders o 
 LEFT JOIN refunds r 
   ON o.order_id = r.order_id
 GROUP BY o.customer_id
 )
 
SELECT
	c.customer_id,
	c.name,
  cr.total_revenue, 
  COALESCE(crf.total_refund,0) AS total_refund,
	ROUND(
        (100.0 * COALESCE(crf.total_refund,0)) / 
        NULLIF(cr.total_revenue,0)
      ,2) AS refund_ratio
FROM customer_revenue cr 
JOIN customers c
	ON c.customer_id = cr.customer_id 
LEFT JOIN customer_refund crf 
	ON crf.customer_id = c.customer_id
ORDER BY refund_ratio DESC;
