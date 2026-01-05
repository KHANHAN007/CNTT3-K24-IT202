SELECT order_date, 
       SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000
ORDER BY order_date;

SELECT order_date, 
       COUNT(order_id) AS total_orders
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000
ORDER BY order_date;
