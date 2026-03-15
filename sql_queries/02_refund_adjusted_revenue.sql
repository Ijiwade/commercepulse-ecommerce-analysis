-- Refund-adjusted monthly revenue 

WITH monthly_revenue AS (
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
), 

monthly_refunds AS ( 
SELECT
  SUBSTR(refund_date,1,7) AS month,
  COALESCE(SUM(refund_amount),0) AS monthly_refund
FROM refunds r
GROUP BY month
), 

all_months AS (
SELECT month FROM monthly_revenue
UNION
SELECT month FROM monthly_refundS
)

SELECT
	am.month,
    COALESCE(mr.monthly_revenue,0) AS monthly_revenue,
    COALESCE(mf.monthly_refund,0) AS monthly_refund,
    ROUND(COALESCE(mr.monthly_revenue,0) 
    - COALESCE(mf.monthly_refund,0),2) 
    AS net_revenue
FROM all_months am
LEFT JOIN monthly_revenue mr
	ON mr.month = am.month
LEFT JOIN monthly_refunds mf
	ON mf.month = am.month
ORDER BY am.month;
