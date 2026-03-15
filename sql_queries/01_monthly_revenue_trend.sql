-- monthly revenue trend 
SELECT
	SUBSTR(o.order_date,1,7) AS month,
	ROUND(COALESCE(SUM(
    COALESCE(oi.quantity,0)*
    COALESCE(p.unit_price,0)* 
    (1 - COALESCE(oi.discount_pct,0))
    ),0),2) AS monthly_revenue
FROM orders o 
LEFT JOIN order_items oi 
	ON o.order_id = oi.order_id
LEFT JOIN products p
	ON p.product_id = oi.product_id
GROUP BY month
ORDER BY month;
