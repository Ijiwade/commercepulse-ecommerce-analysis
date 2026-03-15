-- Which customers place multiple orders within a very short period? 
-- Flag customers with 3 or more orders within 7 days 
-- Output grain is one customer per row 
-- CTE 1 - Order seq LAG() 
WITH sequence AS( 
  SELECT 
  	customer_id, 
  	order_date, 
  	LAG(order_date)OVER( 
      PARTITION BY customer_id 
      ORDER BY order_date, order_id 
    )AS prev1_order_date, 
  	LAG(order_date,2)OVER( 
      PARTITION BY customer_id 
      ORDER BY order_date, order_id 
    )AS prev2_order_date 
  FROM orders 
), 
scored AS ( 
  SELECT 
  	*, 
  	(julianday(order_date) - julianday(prev2_order_date)) AS days_between_orders 
  FROM sequence 
) 
SELECT 
	customer_id,
    COUNT(*) AS burst_orders 
FROM scored 
WHERE days_between_orders <= 7 
	AND days_between_orders IS NOT NULL
GROUP BY customer_id;
