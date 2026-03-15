-- Discount impact on revenue 
-- How much revenue is lost due to discounts? 
SELECT
    COALESCE(SUM(
    oi.quantity * p.unit_price),0) AS gross_revenue, 
    ROUND(COALESCE(SUM(oi.quantity * p.unit_price * (1 - COALESCE(oi.discount_pct,0))
             ),0),2) AS net_revenue, 
    ROUND(COALESCE(SUM(oi.quantity * p.unit_price * COALESCE(oi.discount_pct,0)),0),2) AS discountImpact
FROM order_items oi
LEFT JOIN products p 
	ON oi.product_id = p.product_id;
	
	-- VERSION A

WITH aggs AS ( 
SELECT
  SUM(oi.quantity * p.unit_price) AS gross_rev,
  SUM(oi.quantity * p.unit_price * (1 - COALESCE(oi.discount_pct,0))) AS net_rev
FROM products p 
LEFT JOIN order_items oi 
  ON p.product_id = oi.product_id
)

SELECT
	a.gross_rev, 
    a.net_rev,
	(a.gross_rev - a.net_rev) AS discountImpact
FROM aggs a;

-- VERSION B
-- This is the case where the actual columns has been provided in the table, it is not a row-level query
