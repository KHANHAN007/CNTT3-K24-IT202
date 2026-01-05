USE SS06;
SELECT	o.order_date,
		COUNT(order_id) AS count_orders,
        SUM(total_amount) AS total_revenue
	FROM Orders o
    WHERE o.status = 'completed'
    GROUP BY o.order_date
	HAVING SUM(o.total_amount) > 10000000    
	ORDER BY o.order_date;
